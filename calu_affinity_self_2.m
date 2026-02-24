function affinity = calu_affinity_self_2()

affinity = struct('AA', 1.073, 'AT', 1.333, 'AC', 1.085, 'AG', 1.212, ...
    'TA', 0.784, 'TT', 1.041, 'TC', 0.821, 'TG', 0.987, ...
    'CA', 0.944, 'CT', 1.114, 'CC', 0.991, 'CG', 1.153, ...
    'GA', 0.705, 'GT', 1.030, 'GC', 1.019, 'GG', 1.024);

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
