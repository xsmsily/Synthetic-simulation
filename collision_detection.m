function [new_positions, occupied_grid] = collision_detection(new_positions, fixed_bases, occupied_grid)

global radius box_width box_height total_bases

relative = [
    [-1, -1]; [0, -1]; [1, -1];
    [-1,  0];          [1,  0];
    [-1,  1]; [0,  1]; [1,  1]
    ];

grid_size = ceil(box_width / radius);
max_move_distance = 10; 

for i = 1:total_bases
    if fixed_bases(i)
        continue;
    end
    
    % 计算粒子所在的网格位置
    gx = floor(new_positions(i, 1) / radius) + 1;
    gy = floor(new_positions(i, 2) / radius) + 1;
    
    % 如果当前位置的格子未被占用，则不做任何改变
    if ~occupied_grid(gy, gx)
        continue;
    else
        found_empty_spot = false;
        
        shuffled_relative = relative(randperm(size(relative, 1)), :);
        
        % 遍历相邻格子，检查是否有空位置
        for k = 1:size(shuffled_relative, 1)
            nx = gx + shuffled_relative(k, 1);
            ny = gy + shuffled_relative(k, 2);
            

            if nx >= 1 && nx <= grid_size && ny >= 1 && ny <= grid_size
                if ~occupied_grid(ny, nx)
                    found_empty_spot = true;
                    occupied_grid(ny, nx) = 1; 
                    new_positions(i, :) = [nx * radius + rand * radius, ny * radius + rand * radius];  % 给粒子分配新位置
                    break;
                end
            end
        end
        
        % 如果附近的格子都被占用，则重新生成新的随机位置
        if ~found_empty_spot
            angle = rand * 2 * pi; 
            move_distance = rand * max_move_distance;  
            new_positions(i, :) = new_positions(i, :) + [move_distance * cos(angle), move_distance * sin(angle)];
            

            new_positions(i, 1) = min(max(new_positions(i, 1), 0), box_width);
            new_positions(i, 2) = min(max(new_positions(i, 2), 0), box_height);
        end
    end
end
end
