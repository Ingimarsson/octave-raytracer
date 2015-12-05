function polygon = polygon_import(object_name, colour)
    % Þetta fall les .obj skrár og breytir þeim í polygon hluti fyrir raytracerinn
    % Höfundar: Atli Fannar Franklín & Brynjar Ingimarsson

    warning("off", "Octave:num-to-str");
        
    full_str = fileread(object_name);
        
    split_str = strsplit(full_str, "\n");
        
    for i=1:4
        split_str(:,1) = [];
    end
    
    split_str(:,end) = [];
    
    mtl_find = strfind(split_str, "usemtl");
    
    mtl_find = strjoin(mtl_find);
    
    for i=1:length(mtl_find)
        if (mtl_find(i) == 1)
            mtl_line = i;
        end
    end
    
    split_str(:,mtl_line) = [];
    split_str(:,mtl_line) = [];
    
    f_find = strfind(split_str, "f");
    
    f_find = strjoin(f_find);
    
    for i=1:length(f_find)
        if (f_find(i) == 1)
            f_line = i;
            break;
        end
    end
    
    for i=f_line:length(split_str)
        current_f_line = split_str(1,i);
        current_f_line = strjoin(current_f_line);
        current_f_line = strsplit(current_f_line," ");
        current_f_line(:,1) = [];
        for j=1:(length(current_f_line))
            current_polygon_point = current_f_line(1,j);
            current_polygon_point = strjoin(current_polygon_point);
            current_polygon_point = str2num(current_polygon_point);
            current_polygon_point = split_str(1,current_polygon_point);
            current_polygon_point = strjoin(current_polygon_point);
            current_polygon_point = strsplit(current_polygon_point, " ");
            current_polygon_point(:,1) = [];
            for k=1:length(current_polygon_point)
                point_thing = current_polygon_point(:,k);
                point_thing = strjoin(point_thing);
                point_thing = str2num(point_thing);
                polygon_temp(j,k,i - f_line + 1) = point_thing;
           end
        end
    end

    for i=1:size(polygon_temp, 3)
        polygon(end+1).points = polygon_temp(:,:,i);
        polygon(end).normal = cross(polygon(end).points(2,:) - polygon(end).points(1,:), polygon(end).points(3,:) - polygon(end).points(1,:));
        polygon(end).normal = polygon(end).normal/norm(polygon(end).normal);
        polygon(end).colour = colour;
    end     
end
