function base_positions = init_bp_position_grid(total_bases, box_width, box_height, radius)

min_dist = 2 * radius;
dx = min_dist * sqrt(3);
dy = min_dist * 1.5;

% 计算网格所需的最大列数和行数
max_cols = ceil(box_width / dx);
max_rows = ceil(box_height / dy);

% 存储粒子位置
base_positions = NaN(total_bases, 2);
count = total_bases + 1;  % 反向初始化（倒序填充）

% 设定起始点（中心）
center_x = box_width;
center_y = box_height;

% 逐步增加半径，从内向外填充
radius_step = min_dist;  % 每圈增加的半径
current_radius = 0;  % 当前位置半径
fill_order = [];  % 记录填充顺序

while count > 1
    num_layers = ceil(current_radius / min_dist);  % 计算当前圈的粒子层数
    
    for row = -num_layers:num_layers
        for col = -num_layers:num_layers
            if count <= 1
                break;
            end
            
            % 计算六边形网格坐标
            x = center_x + col * dx;
            y = center_y + row * dy;
            
            % 偶数行向右偏移 0.5dx
            if mod(row, 2) == 1
                x = x + dx / 2;
            end
            
            % **泊松盘式随机扰动**
            theta = 2 * pi * rand();  % 随机角度
            r_shift = (rand() * 0.6) * radius;  % 最大 0.6r 位移
            jitter_x = r_shift * cos(theta);
            jitter_y = r_shift * sin(theta);
            x = x + jitter_x;
            y = y + jitter_y;
            
            % **确保不会超出容器边界**
            if x < radius || x > box_width - radius || ...
                    y < radius || y > box_height - radius
                continue;
            end
            
            % **碰撞检测，确保 ≥ 2r**
            valid = true;
            for i = total_bases:-1:count
                if norm(base_positions(i, :) - [x, y]) < min_dist
                    valid = false;
                    break;
                end
            end
            
            % **如果该点合格，加入粒子列表**
            if valid
                count = count - 1;
                base_positions(count, :) = [x, y];
                fill_order = [count, fill_order];  % 记录填充顺序
            end
        end
    end
    
    % **半径扩大一圈**
    current_radius = current_radius + radius_step;
end

% **确保粒子索引顺序与泊松盘相似**
base_positions = base_positions(fill_order, :);

% **转置矩阵，加快索引访问**
base_positions = base_positions';
end
