function base_positions = init_bp_position_junyun(total_bases, box_width, box_height, radius)

    y_min = box_height * 0.65;
    y_max = box_height;

    x_positions = rand(total_bases, 1) * box_width;
    y_positions = y_min + rand(total_bases, 1) * (y_max - y_min);

    base_positions = [x_positions, y_positions];


    min_distance = 2 * radius; 
    max_attempts = 2000;
    attempts = 0;

    while attempts < max_attempts
        % 计算所有粒子之间的距离
        distances = squareform(pdist(base_positions));

        % 找到距离小于 `min_distance` 的粒子对
        [row_idx, ~] = find(triu(distances, 1) < min_distance);

        if isempty(row_idx)
            break;  % 没有碰撞，退出循环
        end

        % 重新随机化 **X 和 Y** 坐标以减少重叠
        for k = 1:length(row_idx)
            base_positions(row_idx(k), 1) = rand() * box_width;
            base_positions(row_idx(k), 2) = y_min + rand() * (y_max - y_min);
        end

        attempts = attempts + 1;
    end

%     if attempts == max_attempts
%         warning('Reached max attempts for collision-free initialization.');
%     end
end
