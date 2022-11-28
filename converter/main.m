discount = 0.96;


%Load the data
P_struct = load('/problems/biocontrol/mat/T_100_4_42.mat');
R_struct = load('/problems/biocontrol/mat/R_100_4_42.mat');

P_cell = struct2cell(P_struct);
P = P_cell{14};

R_cell = struct2cell(R_struct);
R = R_cell{17};


%R = normalize(R, 'norm');

%R


%Given P, R, X0, b0 and discount, create the .pomdpx file for MOSARSOP
%filename = strcat('~/Dropbox/K-N-MOMDP/problems/test/original_biocontrol_agents_', num2str(size(P,1)), '_', num2str(size(P,3)), '_', num2str(size(P,4)), '.pomdpx');
filename = strcat('/problems/biocontrol/biocontrol_agents_', num2str(size(P,1)), '_', num2str(size(P,3)), '_', num2str(size(P,4)), '2.pomdpx');

filename
size_x = size(P,1);
x0 = zeros(size_x);
size_y = size(P,3);
b0= zeros(size_y);
x0(1) = 1;
b0 = b0/size_y;

%Create the .pomdpx file for the original problem
convertMOMDPtoPOMDPX(P, R, x0, b0, discount, filename);