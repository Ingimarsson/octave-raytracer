function truth = polygon_same_side(point_1, point_2, vector_origin, vector_end)
    % Fall fyrir jöfnu sem reiknar út hvort punktur liggi innan tiltekinnar útlínu á hyrning
    % Höfundar: Atli Fannar Franklín & Brynjar Ingimarsson

    cross_p_1 = cross(vector_end - vector_origin, point_1 - vector_origin);
    cross_p_2 = cross(vector_end - vector_origin, point_2 - vector_origin);
    if (dot(cross_p_1, cross_p_2) >= 0)
        truth = 1;
    else 
        truth = 0;
    end
end
