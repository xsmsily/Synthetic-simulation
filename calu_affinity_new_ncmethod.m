function affinity = calu_affinity_new_ncmethod()

%第二批数据我们定义的公式计算出的亲和性矩阵
 
affinity = struct('AA', 0.00000818288, 'AT', 0.00000777577, 'AC', 0.00000749693, 'AG', 0.00000754796, ...
'TA', 0.00000754199, 'TT', 0.00000807105, 'TC', 0.00000783553, 'TG', 0.00000762073, ...
'CA', 0.00000810312, 'CT', 0.00000726151, 'CC', 0.00000831016, 'CG', 0.00000759942, ...
'GA', 0.00000731344, 'GT', 0.00000784780, 'GC', 0.00000756453, 'GG', 0.00000839550);

values = struct2array(affinity);

min_val = min(values);
max_val = max(values);

fields = fieldnames(affinity);
for i = 1:length(fields)
    key = fields{i};
    
%     affinity.(key) = 0.4 * (affinity.(key) - min_val) / (max_val - min_val);
    affinity.(key) = 0.6 *(affinity.(key) - min_val) / (max_val - min_val);
    
end
end
