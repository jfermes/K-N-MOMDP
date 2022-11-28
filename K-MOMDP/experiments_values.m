discount = 0.96;
precision = 0.000000001;
K = 10;


%PARSE POLICY FILE---------------------------------------------------------

promptXML = 'Policy filename between simple comas (<path/filename>.policy):';
XMLfile = '../../problems/biocontrol/biocontrol_100.policy';
%XMLfile = input(promptXML);

type('parseXML.m')
xml = parseXML(XMLfile);


alphaVectors = xml.Children(2);


belief_size = str2num(alphaVectors.Attributes(3).Value);%Size of the alpha-vectors
number_full_obs_vars = str2num(alphaVectors.Attributes(1).Value);%Number of fully observable states
number_alpha_vectors = str2num(alphaVectors.Attributes(2).Value);%Number of alpha vectors


Vectors = alphaVectors.Children;

GammaAttributes = zeros(number_alpha_vectors, 2);%action, fully observable state
Gamma = zeros(number_alpha_vectors, belief_size);


for v = 1:size(Vectors,2)
   
  if strcmp(Vectors(v).Name, 'Vector')
      %Store alpha vector attributes (action, x) per each alpha vector      
      GammaAttributes(v/2, 1) = str2num(Vectors(v).Attributes(1).Value);
      GammaAttributes(v/2, 2) = str2num(Vectors(v).Attributes(2).Value);
      
      %Store the alpha vector
      Gamma(v/2,:) = str2num(Vectors(v).Children.Data);
 
      %Note: We divide by 2 because for some reason xml parser duplicates
      %the entries with empty text.
      
  end
       
    
end


%----------------------------------------------------------------------------------


%PARSE BELIEFs FILE----------------------------------------------------------------


%Parse the beliefs from the evaluation output.
%We have as many beliefs as: #steps * #simulations

beliefs = readmatrix('../../biocontrol/beliefs_biocontrols_100.txt');
beliefs(:,belief_size+1) = [];


%---------------------------------------------------------------------------------

%IMPORTANT:
%
%We need P and R to create the K-MOMDP.
%We have to be sure that P and R are related to the policy and beliefs
%

%Load the data
P_struct = load('~/Dropbox/K-N-MOMDP/problems/biocontrol/T_100_4_4.mat');
R_struct = load('~/Dropbox/K-N-MOMDP/problems/biocontrol/R_100_4_4.mat');

P_cell = struct2cell(P_struct);
P = P_cell{14};

R_cell = struct2cell(R_struct);
R = R_cell{17};


%We need to add P and R if we want to create the file in POMDPX format
%after the state abstraction
[Values, Policies, PK, RK, S2K, K2S, time] = aStarKMOMDP_values(K, precision, Gamma, beliefs, P, R, GammaAttributes, number_full_obs_vars);



%Given PK, RK, X0K, b0 and discount, create the .pomdpx file for MOSARSOP


%filename_reduced = strcat('~/Dropbox/K-N-MOMDP/problems/values_reduced_biocontrol_agents_', num2str(size(P,1)), '_', num2str(size(P,3)), '_', num2str(size(P,4)), '_to_', num2str(size(PK,1)), '_', num2str(size(PK,3)), '_', num2str(size(PK,4)),'.pomdpx');
filename_reduced = 'values_biocontrol_10_KMOMDP.pomdpx';

size_y = size(P,3);
b0= zeros(size_y);



size_reduced_x = size(PK,1);
reduced_x0 = zeros(size_reduced_x);
reduced_x0(1) = 1;
b0 = b0/size_y;

convertMOMDPtoPOMDPX(PK, RK, reduced_x0, b0, discount, filename_reduced);



