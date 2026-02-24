function affinity = calu_affinity()

affinity = struct('AA', 0.555, 'AT', 0.002, 'AC', 0.112, 'AG', -0.425, ...
                 'TA', 0.265, 'TT', 0.189, 'TC', -0.004, 'TG', -0.3, ...
                 'CA', 0.8, 'CT', -0.237, 'CC', -0.325, 'CG', -0.118, ...
                 'GA', -0.1, 'GT', -0.0126, 'GC', 0.13, 'GG', 0.01);

% values = struct2array(affinity);
values = cell2mat(struct2cell(affinity));  

min_val = min(values);
max_val = max(values);

fields = fieldnames(affinity);
for i = 1:length(fields)
    key = fields{i};
    
%     affinity.(key) = 0.4 * (affinity.(key) - min_val) / (max_val - min_val);
    affinity.(key) = (affinity.(key) - min_val) / (max_val - min_val);
    
end
end
