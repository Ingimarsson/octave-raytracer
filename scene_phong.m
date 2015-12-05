% Þessi skrá inniheldur allar stillanlegar breytur fyrir forritið

camera = [0, 0, 200];                   % Staðsetning myndavélar
light = [10, 30,200];                   % Staðsetning ljósuppsprettu

save_path = "scene_phong.png";          % Heiti skráar sem skrifa á myndina sem
ray_shots = 5;                          % Fjöldi geisla sem á að skjóta í hvern pixel, fleiri skot gefa fínni útlínur
draw_each = 1;                          % Uppfæra mynd á skjá eftir hverja viðbætta línu

x=1280;                                 % Lárétt upplausn
y=720;                                  % Lóðrétt upplausn

plane(1).normal = [0.2,1,0];            % Þverill á planinu
plane(1).point = [0,-120,0];            % Punktur á planinu
plane(1).colour = [0.1,0.1,0.1;1,1,1];  % Litur plans, ef taflborð þá þarf að skilgreina 2 liti í sitthvorri röðinni
% plane(1).chessboard = 0               % Ef plan er ekki taflborð þarf þessi lína að vera, annars ekki
plane(1).chess.size = [100,100];        % Stærð taflborðs
plane(1).chess.axis = 0;                % Barísentríska hnitakerfið á planinu (ef 0 þá reiknar chessboard það fyrir okkur)

sphere(1).center = [50,5,0];            % Miðpunktur kúlu
sphere(1).radius = 40;                  % Radíus kúlu
sphere(1).colour = [1,0,0];             % Litur kúlu
sphere(1).alpha = 80;                   % "gljástuðull" kúlu
sphere(1).mirror = 0.5;                 % Hlutfall sem speglast (gildi á bilinu [0,1])

sphere(2).center = [-50,5,0];
sphere(2).radius = 30;
sphere(2).colour = [0,0,1];
sphere(2).alpha = 80;
sphere(2).mirror = 0.5;

sphere(3).center = [-50,190,320];
sphere(3).radius = 160;
sphere(3).colour = [0,1,0];
sphere(3).alpha = 40;
sphere(3).mirror = 0.5;

