function [base_positions, original_indices] = init_bp_position_new(total_bases, box_width, box_height, radius)

min_dist = 2 * radius;
center_x = box_width;
center_y = box_height;

% 存储粒子位置
base_positions = NaN(total_bases, 2);
count = total_bases + 1; 

% **初始化参数**
radius_step = min_dist;  
current_radius = radius_step;  
fill_order = [];  

while count > 1
    % **扩大投放角度，让分布更广**
    theta_min = pi / 3; 
    theta_max = pi;      % **180°**
    
    num_particles = ceil(2 * pi * current_radius / min_dist);  
    angles = linspace(theta_min, theta_max, num_particles);  

    for i = 1:length(angles)
        if count <= 1
            break;
        end
        
        % **增加随机扰动**
        theta = angles(i) + (rand() - 0.5) * (pi / 4);  
        r_shift = current_radius + (rand() - 0.5) * radius_step;  

        x = center_x + r_shift * cos(theta);
        y = center_y - r_shift * sin(theta) + (rand() - 0.5) * radius_step; % **加入纵向扰动**
        
        % **确保不会超出边界**
        if x < radius || x > box_width - radius || y < radius || y > box_height - radius
            continue;
        end
        
        % **碰撞检测**
        valid = true;
        for j = total_bases:-1:count
            if norm(base_positions(j, :) - [x, y]) < min_dist
                valid = false;
                break;
            end
        end
        
        % **如果该点合格，加入粒子列表**
        if valid
            count = count - 1;
            base_positions(count, :) = [x, y];
            fill_order = [count, fill_order];
        end
    end
    
    % **半径扩大一圈**
    current_radius = current_radius + radius_step;
end

% **随机化顺序**
base_positions = base_positions(fill_order, :)';
shuffled_indices = randperm(total_bases);
base_positions = base_positions(:, shuffled_indices);
base_positions = base_positions';
end
