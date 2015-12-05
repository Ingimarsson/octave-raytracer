% Raytracer - aðalskrá
% Höfundar: Atli Fannar Franklín & Brynjar Ingimarsson

clear all       % Eyðum öllum breytum
close all       % Lokum öllum gluggum
clc             % Hreinsum skipanaglugga

% Slökkva á viðvörunum um deilingu með núlli, þótt það geti komið fyrir hefur það ekki áhrif á virkni forritsins
warning ("off", "Octave:divide-by-zero");

% Skilgreinum hluti (structues) fyrir mismunandi form
plane = struct([]);
sphere = struct([]);
polygon = struct([]);

% Lesum stillingar og þau form sem á að teikna úr "scene skrá"

source("scene_phong.m")
%source("scene_monkey.m")

% Reiknum út "grímur" (masks) fyrir hyrninga
polygon = polygon_mask(polygon, camera);

% Hefjum tímatöku
time = tic;

% Skilgreinum svarta mynd
frame = zeros(y,x,3);

% Eining á milli pixla, myndin hefur alltaf hæð 200 en breidd 200 * hlutfall upplausnar (200 * x / y)
delta = 200 / y;

% Reikna lit fyrir sérhvern pixel
for i=1:x
    for j=1:y
        % Skilgreinum pixel sem punkt í hnitakerfinu
        frame_pixel = [-(200 * (x / y) / 2) + delta * i + delta / 2 , 100 - delta * j - delta / 2,  0];
        
        random_pixel = frame_pixel;

        % Skjóta ray eftir skilgreindum fjölda, í fyrstu lotu er skotið á miðjan pixelinn
        for h=1:ray_shots
            frame(j, i, 1:3) = frame(j, i, 1:3)(:,:) + pixel(camera, random_pixel, light, plane, sphere, polygon) / ray_shots ;
            
            % Veljum punkt innan marka pixels af handahófi til að skjóta á í næstu lotu
            random_pixel = frame_pixel + [(rand - 0.5) * delta , (rand - 0.5) * delta, 0];
        end
    end

    % Birta hentugar upplýsingar um gang forritsins eftir hverja viðbætta röð í myndina
    printf("Lines processed: %d\tCompleted: %d%%\t\tETA: %fs \r", i, round(i/x * 100), toc(time) / i * (x - i));
    
    % Uppfæra mynd á skjá eftir hverja viðbætta röð í myndina ef það er skilgreint í scene skrá
    if(draw_each)
        imshow(frame);
        pause(0.01);
    end

    fflush(stdout);
end

% Ljúkum tímatöku
printf("\nRender time: %fs\n", toc(time));

% Teiknum mynd á skjá og skrifum hana í skilgreinda skrá
imshow(frame);
imwrite(frame, save_path);
