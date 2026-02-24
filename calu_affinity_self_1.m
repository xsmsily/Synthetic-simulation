function affinity = calu_affinity_self_1()

affinity = struct('AA', 1.071, 'AT', 1.236, 'AC', 1.095, 'AG', 0.993, ...
                 'TA', 0.832, 'TT', 1.045, 'TC', 0.886, 'TG', 0.867, ...
                 'CA', 0.926, 'CT', 1.036, 'CC', 1.006, 'CG', 0.930, ...
                 'GA', 0.819, 'GT', 1.155, 'GC', 1.208, 'GG', 1.024);

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
