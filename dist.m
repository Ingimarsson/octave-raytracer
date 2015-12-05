function distances = dist(source, destination, plane, sphere, polygon)
    % Fall sem tekur við tveimur punktum (source og destination), og reiknar hvaða hluti geisli í gegnum þá sker. Fallið skilar fylki með fjarlægðum í hluti (aðeins hlutir með jákvæðar fjarlægðir eru settir í fylkið)
    % Höfundar: Atli Fannar Franklín & Brynjar Ingimarsson

    % Fylki með hlutum sem geislinn sker, hver lína (row) er einn hlutur, í fremsta dálk er tala sem segir til um tegund hlutar (1: plan, 2: kúla, 3: hyrningur), næst er númer hlutar í hlutamengi sínu (structure), svo kemur fjarlægðin
    distances = [];

    % Einingarvigur geislans
    direction = (destination - source) / norm(destination - source);

    % Reikna hvaða plön geislinn sker
    for id=1:columns(plane)
        distance = dot((plane(id).point - source), plane(id).normal) / dot(direction, plane(id).normal);

        if(distance > 0)    % Aðeins gild lausn ef fjarlægðin er jákvæð
            distances(end+1, 1:3) = [1, id, distance];
        end
    end

    % Reikna hvaða kúlur hluturinn sker
    for id=1:columns(sphere)

        % Stuðlar í annars stigs jöfnu fyrir skurðpunkt stika og kúlu
        a = dot(direction, direction);
        b = 2 * dot(direction, (source - sphere(id).center));
        c = dot(source - sphere(id).center, source - sphere(id).center) - sphere(id).radius^2;

        % Lausnir annars stigs jöfnunnar (skilar einnig tvinntölulausnum)
        distance = roots([a, b, c]);

        if(isreal(distance) && min(distance) > 0)               % Aðeins gild lausn ef báðar lausnir eru rauntölulausnir og báðir punktar eru í jákvæðri fjarlægð
            distances(end+1, 1:3) = [2, id, min(distance)];     % Fjarlægð í þann skurðpunkt sem er í minni fjarlægð
        end
    end

    % Reikna hvaða hyrninga hluturinn sker
    for id=1:columns(polygon)
        % Aðeins framkvæma útreikninga fyrir hyrning ef hann er innan marka rétthyrningslaga "grímu" (mask) á myndinni
        if(polygon(id).mask(1) <= destination(1) && polygon(id).mask(2) >= destination(1) && polygon(id).mask(3) <= destination(2) && polygon(id).mask(4) >= destination(2))

            % Ef hyrningurinn er ekki hornréttur á geislann
            if(abs(dot(direction, polygon(id).normal)) > eps)

                % Fjarlægð í skurðpunkt (notum sömu jöfnur og fyrir plan)
                parameter = dot(polygon(id).points(1,:) - source, polygon(id).normal ) / dot( direction, polygon(id).normal );

                % Aðeins gild lausn ef fjarlægðin er jákvæð
                if(parameter > 0)
                    % Skilgreinum skurðpunktinn
                    intersection_point = source + parameter * direction;
                    
                    truth = 1;      % Ef útreikningar sýna að skurðpunkturinn er ekki innan marka hyrningsins setjum við truth = 0 til að sleppa óþarfa útreikningum

                    % Athugum hvort skurðpunktur sé innan sérhverjar útlínu hyrningsins
                    for i=1:rows(polygon(id).points)-2
                        if(truth)
                            truth = truth*polygon_same_side(intersection_point, polygon(id).points(i+2,:), polygon(id).points(i,:), polygon(id).points(i+1,:));
                        end
                    end

                    % Reiknum síðustu tvær útlínurnar utan lykkjunnar því þá erum við kominn allan hringinn
                    truth = truth*polygon_same_side(intersection_point, polygon(id).points(1,:), polygon(id).points(end-1,:), polygon(id).points(end,:));
                    truth = truth*polygon_same_side(intersection_point, polygon(id).points(2,:), polygon(id).points(end,:), polygon(id).points(1,:));
                    
                    if(truth) % Aðeins gild lausn ef skurðpunktur liggur innan hyrnings
                        distances(end+1, 1:3) = [3, id, parameter];
                    end
                end
            end
        end
    end
    
    if(rows(distances) > 0) % Ef fylkið er ekki tómt þá röðum við línunum í því upp eftir fjarlægðum (minnsta fjarlægð efst)
        distances = sortrows(distances, 3);
    end
end
