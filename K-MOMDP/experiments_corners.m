discount = 0.96;
precision = 0.000000000001;
K = 16;


%Load the data
P_struct = load('~/Dropbox/K-N-MOMDP/Code/mat/T_500_4_4.mat');
R_struct = load('~/Dropbox/K-N-MOMDP/Code/mat/R_500_4_4.mat');

P_cell = struct2cell(P_struct);
P = P_cell{14};

R_cell = struct2cell(R_struct);
R = R_cell{17};

%Given P, R, X0, b0 and discount, create the .pomdpx file for MOSARSOP
filename = strcat('~/Dropbox/K-N-MOMDP/problems/original_biocontrol_agents_', num2str(size(P,1)), '_', num2str(size(P,3)), '_', num2str(size(P,4)),'.pomdpx');
size_x = size(P,1);
x0 = zeros(size_x);
size_y = size(P,3);
b0= zeros(size_y);
x0(1) = 1;
b0 = b0/size_y;

%Create the .pomdpx file for the original problem
%convertMOMDPtoPOMDPX(P, R, x0, b0, discount, filename);


%Create the K-MOMDP using the corners state abstraction
[Values, Policies, PK, RK, S2K, K2S, time] = aStarKMOMDP_corners(K, precision, P, R, discount);


%Given PK, RK, X0K, b0 and discount, create the .pomdpx file for MOSARSOP

%filename_reduced = strcat('~/Dropbox/K-N-MOMDP/problems/test/reduced_biocontrol_agents_', num2str(size(P,1)), '_', num2str(size(P,3)), '_', num2str(size(P,4)), '_to_', num2str(size(PK,1)), '_', num2str(size(PK,3)), '_', num2str(size(PK,4)),'.pomdpx');
filename_reduced = 'corners_biocontrol_16_KMOMDP.pomdpx';

size_reduced_x = size(PK,1);
reduced_x0 = zeros(size_reduced_x);
reduced_x0(1) = 1;
b0 = b0/size_y;

convertMOMDPtoPOMDPX(PK, RK, reduced_x0, b0, discount, filename_reduced);

%Once we have both K-MOMDPs, is time to solve them using MOSARSOP and
%evaluate the performance.




