function force_attraction = force_attraction_calu(base_types,bone_positions,base_positions,dna_seq,total_bases,fixed_bases,affinity)
global lambda dist_thresold r0


dist_matrix = pdist2(base_positions, bone_positions);
[sorted_distances, sorted_indices] = sort(dist_matrix, 2);
force_attraction = zeros(total_bases,2);

for i = 1:total_bases
    if fixed_bases(i)
        continue;
    end
    
    base_i = base_types(i);
    nearest_indices = sorted_indices(i, 1:5);
    nearest_distances = sorted_distances(i, 1:5);
    valid_indices = [];
    valid_affinities = [];
    valid_directions = [];
    min_dist = nearest_distances(1);
    if min_dist > dist_thresold
        continue;
    end
    
    if ~isempty(dna_seq{nearest_indices(1)}) 
        
        for j = 1:length(nearest_indices)
            bone_idx = nearest_indices(j);
            
            prev_base = dna_seq{bone_idx}(end);
            pair_type = [prev_base, base_i];
            
%             if isfield(affinity, pair_type) && affinity.(pair_type) > 0.2
            if isfield(affinity, pair_type)
                valid_indices = [valid_indices, bone_idx];
                valid_affinities = [valid_affinities, affinity.(pair_type)];
                
                direction = bone_positions(bone_idx, :) - base_positions(i, :);
                direction = direction / norm(direction); % πÈ“ªªØ
                if isempty(valid_directions)
                    valid_directions = direction;
                else
                    valid_directions = [valid_directions; direction];
                end

            end
        end
    end
    
    if ~isempty(valid_affinities)
        weights = valid_affinities / sum(valid_affinities);
        
        weighted_direction = sum(valid_directions .* weights', 1);
        weighted_direction = weighted_direction / norm(weighted_direction);
        
        affinity_bias = sum(valid_affinities .* weights);
        attraction = lambda * affinity_bias * exp(-lambda * min_dist/r0) * weighted_direction;
    else
        attraction = [0, 0];
    end
    
    force_attraction(i, :) = attraction;
end

end
