function pixel_colour = pixel(source, destination, light, plane, sphere, polygon)
    % Þetta fall tekur við tveimur punktum sem eru á geislanum (t.d. myndavél og punkt á mynd), staðsetningu ljósuppsprettu og hlutum (plönum, kúlum og hyrningum). Síðan reiknar það út hvaða hluti geislinn sker, hvort það sé skuggi í skurðpunktinum og hvort geislinn speglast og skilar síðan litnum sem svarar til geislans.
    % Höfundar: Atli Fannar Franklín & Brynjar Ingimarsson

    % Reiknum út hvaða hluti upphaflegi geislinn sker
    distances = dist(source, destination, plane, sphere, polygon);

    % Einingarvigur geislans
    direction = (destination - source) / norm(destination - source);

    % Ef geislinn sker einhverja hluti
    if(rows(distances) > 0)
        % Skilgreinum fjarlægðina í fremsta hlutinn (distance) og númer hans í fylkinu (index)
        [distance, index] = min(distances(:,3));
        
        % Reiknum út skurðpunkt fremsta hlutar
        point = source + distance * direction;

        switch distances(index, 1)
            case 1  % Ef fremsti hlutur er plan
                object = plane(distances(index, 2));

            case 2  % Ef fremsti hlutur er kúla
                object = sphere(distances(index, 2));

                % Fyrir kúlur þarf að reikna þveril í hverri lotu því hann er ekki sá sami í öllum skurðpunktum
                object.normal = (point - object.center) / norm(point - object.center);

            case 3  % Ef frensti hlutur er hyrningur
                object = polygon(distances(index, 2));
        end
        
        % Reiknum út hvaða hluti geislinn frá ljósuppsprettu að skurðpunkti sker
        light_intersect = dist(light, point, plane, sphere, polygon);

        % Einingarvigur ljósageislans
        light_direction = (light - point) / norm(light - point);

        % Ef hlutur er plan sem er skilgreint sem taflborð skilgreinum við litinn í skurðpunktinum
        if(distances(index, 1) == 1 && isstruct(object.chess))
            object.colour = chessboard(plane, distances(index, 2), point);
        
        end

        % Ef ljósageislinn sker einhverja hluti og fjarlægð fremsta hlutar frá ljósi er minni en fjarlægð milli ljóss og skurðpunktar þá kemur skuggi (-0.01 er til þess að leiðrétta villur)
        if(rows(light_intersect) > 0 && min(light_intersect(:,3)) < norm(point-light) - 0.01)
            pixel_colour = object.colour * 0.4;

        % Ef það á ekki að koma skuggi en hluturinn er kúla þá þarf að reikna mögulega speglun og phong lýsingu
        elseif(distances(index, 1) == 2)
            light_reflection = 2 * dot(light_direction, object.normal) * light_direction - object.normal;     % Einingarvigur speglunar af ljósvigrinum um þverilinn á kúlunni
            ray_reflection = 2 * dot(direction, object.normal) * object.normal - direction;                   % Einingarvigur speglunar af geislavigrinum um þverilinn á kúlunni

            % Litur á skurðpunkti við kúlu reiknaður með bæði venjulegri lýsingu og phong lýsingu
            pixel_colour = object.colour * (abs(dot(object.normal, light_direction) * 0.6 + 0.4)) + (dot(light_reflection, -direction)^object.alpha * 0.2);
            
            if(object.mirror)   % Ef speglunarmagn er ekki 0%
                reflection_point = point - ray_reflection;

                % Litur á skurðpunkti með tilliti til þess hlutfalls sem á að speglast, hér köllum við í fallið sem við erum í núna (endurkvæmni)
                pixel_colour = pixel_colour .* (1 - object.mirror) + pixel(point, reflection_point, light, plane, sphere, polygon) .* object.mirror;
            end

        % Ef við hittum plan eða hyrning reiknum við út litinn á skurðpunktinum með venjulegri lýsingu
        else
            pixel_colour = object.colour * (abs(dot(object.normal, light_direction) * 0.6 + 0.4));
        end

    % Ef upphaflegi geislinn hittir ekki neitt verður punkturinn svartur
    else
        pixel_colour = [0,0,0];
    end
end
