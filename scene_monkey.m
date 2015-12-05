% Þessi skrá inniheldur allar stillanlegar breytur fyrir forritið

camera = [0, 0, 200];                   % Staðsetning myndavélar
light = [10, 30,200];                   % Staðsetning ljósuppsprettu

save_path = "scene_monkey.png";         % Heiti skráar sem skrifa á myndina sem
ray_shots = 1;                          % Fjöldi geisla sem á að skjóta í hvern pixel, fleiri skot gefa fínni útlínur
draw_each = 1;                          % Uppfæra mynd á skjá eftir hverja viðbætta línu

x=64;                                  % Lárétt upplausn
y=64;                                  % Lóðrétt upplausn

plane(1).normal = [0.2,1,0];            % Þverill á planinu
plane(1).point = [0,-120,0];            % Punktur á planinu
plane(1).colour = [0.1,0.1,0.1;1,1,1];  % Litur plans, ef taflborð þá þarf að skilgreina 2 liti í sitthvorri röðinni
% plane(1).chessboard = 0               % Ef plan er ekki taflborð þarf þessi lína að vera, annars ekki
plane(1).chess.size = [100,100];        % Stærð taflborðs
plane(1).chess.axis = 0;                % Barísentríska hnitakerfið á planinu (ef 0 þá reiknar chessboard það fyrir okkur)

% Breyta .obj skrá í safn hyrninga
polygon = polygon_import("monkey.obj", [1,0,0]);
