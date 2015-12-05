function polygon = polygon_mask(polygon, camera)
    % þetta fall tekur við öllum hyrningunum og myndavélinni og skilar hæsta og lægsta x og y hniti þeirra á myndinni, eða "grímum" (masks), sem við notum til þess að flýta fyrir útreikningum á skurðpunktum hyrninga
    % Höfundar: Atli Fannar Franklín & Brynjar Ingimarsson
    
    for i=1:length(polygon)                 % Fyrir sérhvern hyrning
        for j=1:length(polygon(i).points)   % Fyrir sérhvern punkt á hyrningi
            point = polygon(i).points(j,:); % Skilgreinum punktinn

            normal = camera - point;        % Einingarvigur frá punkti að myndavél
            normal = normal / norm(normal); 

            % fpoint er tímabundið fylki fyrir grímupunktana
            fpoint(j, 1:3) = point - (point(3) / normal(3)) * normal;
        end

        min_x = min(fpoint(:,1));   % Lægsta x hnit
        max_x = max(fpoint(:,1));   % Hæsta x hnit
        min_y = min(fpoint(:,2));   % Lægsta y hnit
        max_y = max(fpoint(:,2));   % Hæsta y hnit

        clear fpoint        % Tæmum tímabundna fylkið til að forðast villur

        % Bætum við mask í hlut hyrningsins
        polygon(i).mask(1:4) = [min_x, max_x, min_y, max_y];
    end
end
