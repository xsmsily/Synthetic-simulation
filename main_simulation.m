function dna_seq = main_simulation()


global num_cycles num_backbone backbone_interval
global box_width box_height radius sigma dt m
global num_A num_T num_C num_G total_bases

para2();

dna_seq = cell(num_backbone, 1);
bone_positions = init_position_dnaBackbone(num_backbone, backbone_interval, box_width);


base_types_list = ['A', 'T', 'C', 'G'];
alpha = 1;
binding_probabilities = [0.4, 0.6, 0.4, 0.6].^alpha;

%binding_probabilities = [0.4, 0.8, 0.4, 0.8];


grid_size_x = ceil(box_width / radius);
grid_size_y = ceil(box_height / radius);
affinity = calu_affinity();

for cycle = 1:num_cycles
    base_types = [repmat('A', 1, num_A), repmat('T', 1, num_T), ...
        repmat('C', 1, num_C), repmat('G', 1, num_G)];
    base_types = base_types(randperm(total_bases));
    occupied_grid = zeros(grid_size_y, grid_size_x);
    fixed_bases = false(total_bases, 1);
    occupied = false(num_backbone, 1);
    
    unoccupied_count = num_backbone;
    base_positions = init_bp_position_junyun(total_bases, box_width, box_height, radius);
    
    count = 1;
    
    while unoccupied_count > 0
        theta = 2 * pi * rand(total_bases, 1);
        brownian_magnitude = sigma * randn(total_bases, 1);
        brownian_velocity = [brownian_magnitude .* cos(theta), brownian_magnitude .* sin(theta)];
        %         v_x = -0.5;
        %         v_y = -1;
        %         drift_velocity = [v_x, v_y];
        %         brownian_velocity = brownian_velocity + drift_velocity;
        %         brownian_velocity
        

        new_positions = base_positions;
        
        if cycle == 1
            new_positions(~fixed_bases, :) = base_positions(~fixed_bases, :) + brownian_velocity(~fixed_bases, :) * dt;
        else
            force = force_attraction_calu1(base_types,bone_positions,base_positions,dna_seq,total_bases,fixed_bases,affinity,occupied);
            new_positions(~fixed_bases, :) = base_positions(~fixed_bases, :) + brownian_velocity(~fixed_bases, :) * dt + ...
                (force(~fixed_bases, :) / (2 * m)) * dt^2 ;
        end
        
        for i = 1:total_bases
            if fixed_bases(i)
                continue;
            end
 
            if new_positions(i,1) > box_width
                new_positions(i,1) = box_width - (new_positions(i,1) - box_width);
            end

            if new_positions(i,1) < 0
                new_positions(i,1) = -new_positions(i,1);
            end
            
            new_positions(:,2) = mod(new_positions(:,2), box_height);
        end
        
        [new_positions, occupied_grid] = collision_detection(new_positions, fixed_bases, occupied_grid);
        
        base_positions = new_positions;
        
        if count >= 900
            for i = 1:num_backbone
                if ~occupied(i)
                    distances = vecnorm(base_positions - bone_positions(i,:), 2, 2);
                    candidate_idx = find(distances < 7.5 & ~fixed_bases);

                    if isempty(candidate_idx)
                        continue;
                    end
                    
                    % 提取候选碱基类型及其对应结合概率
                    candidate_types = base_types(candidate_idx);
%                     candidate_types 
                    prob_vector = zeros(size(candidate_idx));

                    for k = 1:length(candidate_idx)
                        type = candidate_types(k);
                        prob_vector(k) = binding_probabilities(base_types_list == type);
                    end
                    
                    % 概率归一化（避免 all-zero）
                    prob_vector = prob_vector / sum(prob_vector);
                    

                    selected_local_idx = randsample(1:length(candidate_idx), 1, true, prob_vector);
                    selected_idx = candidate_idx(selected_local_idx);
                    
                    % 进行结合
                    base_type = base_types(selected_idx);
                    dna_seq{i} = [dna_seq{i}, base_type];
                    occupied(i) = true;
                    fixed_bases(selected_idx) = true;
                    unoccupied_count = unoccupied_count - 1;
                end
            end
        end
        
        
        
        count = count + 1;
        
    end
    
%     count
    bone_positions = position_of_dnaBackbone(bone_positions);
end

save('brownian_simulation.mat', 'dna_seq', '-v7.3');

end