function colour = chessboard(plane, plane_id, point)
    % Þetta fall tekur við upplýsingum um planið og skurðpunkti á því og skilar litnum á skurðpunktinum (jöfnur fylgja með í pdf skjali)
    % Höfundar: Atli Fannar Franklín & Brynjar Ingimarsson
   
    n = plane(plane_id).normal;         % Þverill plansins
    p = point - plane(plane_id).point;  % Vigur frá "miðpunkti" plans að skurðpunkti

    % Jöfnur númer 4-6
    if(n(1) ~= 0)
        i = [ -n(3) / n(1), 0, 1 ];

    elseif(n(2) ~= 0)
        i = [ 1, -n(3) / n(2), 0 ];

    elseif(n(3) ~= 0)
        i = [ 0, 1, -n(2) / n(3) ];

    end

    % Jöfnur númer 7-12
    if(n(3) * i(2) ~= n(2) * n(3) && i(2))
        cx = 1;
        cz = cx * (n(2) * i(1) - n(1) * i(2)) / (n(3) * i(2) - n(2) * i(3));
        cy = - (i(1) * cx + i(3) * cz) / i(2);

        j = [cx, cy, cz];

    elseif(n(3) * i(1) ~= n(1) * i(3) && i(3))
        cy = 1;
        cx = cy * (n(3) * i(2) - n(2) * i(3)) / (n(1) * i(3) - n(3) * i(1));
        cz = - (i(2) * cy + i(1) * cx) / i(3);

        j = [cx, cy, cz];
    
    elseif(n(2) * i(1) ~= n(1) * i(2) && i(1))
        cz = 1;
        cy = cz * (n(1) * i(3) - n(3) * i(1)) / (n(2) * i(1) - n(1) * i(2));
        cx = - (i(3) * cz + i(2) * cy) / i(1);

        j = [cx, cy, cz];

    end

    % Breytum vigrunum í þvervigur, þessir þrír vigrar eru allir hornréttir á hvorn annan
    n = n / norm(n);
    i = i / norm(i);
    j = j / norm(j);

    % Leysum línulegt jöfnuhneppi til þess að finna x færslu og y færslu í barísentríska hnitakerfinu
    barycentric = [ i(1), j(1) ; i(2), j(2); i(3),  j(3)] \ [p(1) ; p(2) ; p(3) ];

    % Leifin þegar fjöldi láréttra og lóðréttra "skrefa" á taflborðinu er lagður saman, annaðhvort 0 eða 1
    remainder = rem(round(barycentric(1) / plane(plane_id).chess.size(1)) + round(barycentric(2) / plane(plane_id).chess.size(2)), 2);
    
    if(remainder)
        colour = plane(plane_id).colour(1,:);
    else
        colour = plane(plane_id).colour(2,:);
    end
end
