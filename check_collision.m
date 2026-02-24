function is_collision = check_collision(new_pos, new_positions, exclude_indices, min_dist)
% main_simulation_bulang_new()中的函数

dists = vecnorm(new_positions - new_pos, 2, 2);

% 忽略当前正在调整的粒子（避免自己与自己比较）
dists(exclude_indices) = inf;

% 判断是否有其他粒子过于接近
is_collision = any(dists < min_dist);

end