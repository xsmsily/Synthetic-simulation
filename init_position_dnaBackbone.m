function positions = init_position_dnaBackbone(num_backbone,backbone_interval,box_width)

dna_backbone_x = 1:backbone_interval:1+(num_backbone-1)*backbone_interval;
dna_backbone_y = ones(size(dna_backbone_x)); 

if box_width < dna_backbone_x(end)
    error('Error: box_width is smaller than the last element of dna_backbone_x.');
end

positions = [dna_backbone_x', dna_backbone_y'];

end