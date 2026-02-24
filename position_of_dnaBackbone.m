function positions = position_of_dnaBackbone(position_backbone)

positions = position_backbone;
positions(:, 2) = positions(:, 2) + 1;

end