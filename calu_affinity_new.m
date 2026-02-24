function affinity = calu_affinity_new()

%第二批数据我们定义的公式计算出的亲和性矩阵
 
affinity = struct('AA', 1.052, 'AT', 1.116, 'AC', 0.722, 'AG', 0.833, ...
    'TA', 0.874, 'TT', 1.043, 'TC', 0.678, 'TG', 0.757, ...
    'CA', 1.399, 'CT', 1.398, 'CC', 1.071, 'CG', 1.126, ...
    'GA', 1.090, 'GT', 1.307, 'GC', 0.845, 'GG', 1.074);

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
