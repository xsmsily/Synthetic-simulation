function para2()
global num_cycles num_backbone backbone_interval total_bases
global box_width box_height radius dt lambda m dist_thresold sigma 
global k lambda_re r0 weight_template
global num_A num_T num_C num_G

num_A = 165;
num_T = 144;
num_C = 165;
num_G = 126;
total_bases = 600;
num_cycles = 30;
num_backbone = 50;
backbone_interval = 8;
box_width = 400;
box_height = 30; 
radius = 0.01;
m = 0.05;
dt = 0.1;
lambda = 5;
dist_thresold = 30;
sigma = 2;
r0 = 500;
k = 3;
lambda_re = 2*radius;
weight_template = [0.4, 0.2, 0.2, 0.1, 0.1];  
end