
%Parse the transitions file:

fullFileName = fullfile(pwd, 'potoroos_transition_matrix_original.txt')
transitions = readtable(fullFileName);
transitions = transitions(:,2:8);

%Convert data to numeric values

%Fox
HighF = 1;
LowF = 0;
F1 = 1; F2 = 2; F3 = 3; F4 = 4; F5 = 5; F6 = 6; F7 = 7; F8 = 8; F9 = 9;


%Species
LocExtSp = -1;
LowSp = 2;
HighSp = 3;
S1 = 1; S2 = 2; S3 = 3;

%Actions
do_nothing = 0; a1 =1; a2=2; a3 = 3; a4 = 4; a5 = 5;

%FOX

%Models
transitions.V2(strcmp(transitions.V2,'F1')) = {F1};
transitions.V2(strcmp(transitions.V2,'F2')) = {F2};
transitions.V2(strcmp(transitions.V2,'F3')) = {F3};
transitions.V2(strcmp(transitions.V2,'F4')) = {F4};
transitions.V2(strcmp(transitions.V2,'F5')) = {F5};
transitions.V2(strcmp(transitions.V2,'F6')) = {F6};
transitions.V2(strcmp(transitions.V2,'F7')) = {F7};
transitions.V2(strcmp(transitions.V2,'F8')) = {F8};
transitions.V2(strcmp(transitions.V2,'F9')) = {F9};

%Actions
transitions.V3(strcmp(transitions.V3,'do_nothing')) = {do_nothing};
transitions.V3(strcmp(transitions.V3,'a1')) = {a1};
transitions.V3(strcmp(transitions.V3,'a2')) = {a2};
transitions.V3(strcmp(transitions.V3,'a3')) = {a3};
transitions.V3(strcmp(transitions.V3,'a4')) = {a4};
transitions.V3(strcmp(transitions.V3,'a5')) = {a5};

%State valuyes
transitions.V4(strcmp(transitions.V4,'HighF')) = {HighF};
transitions.V4(strcmp(transitions.V4,'LowF')) = {LowF};

transitions.V5(strcmp(transitions.V5,'HighF')) = {HighF};
transitions.V5(strcmp(transitions.V5,'LowF')) = {LowF};


%Empty line
transitions(strcmp(transitions.V2, 'V2'), :) = [];

%SPECIES

%Models
transitions.V2(strcmp(transitions.V2,'S1')) = {S1};
transitions.V2(strcmp(transitions.V2,'S2')) = {S2};
transitions.V2(strcmp(transitions.V2,'S3')) = {S3};

%State values
transitions.V3(strcmp(transitions.V3,'HighF')) = {HighF};
transitions.V3(strcmp(transitions.V3,'LowF')) = {LowF};

transitions.V4(strcmp(transitions.V4,'LocExtSp')) = {LocExtSp};
transitions.V4(strcmp(transitions.V4,'LowSp')) = {LowSp};
transitions.V4(strcmp(transitions.V4,'HighSp')) = {HighSp};

transitions.V5(strcmp(transitions.V5,'LocExtSp')) = {LocExtSp};
transitions.V5(strcmp(transitions.V5,'LowSp')) = {LowSp};
transitions.V5(strcmp(transitions.V5,'HighSp')) = {HighSp};

%remove empty rows
idxs = find(strcmp(transitions{:,1}, ''));

transitions(idxs,:) = [];

%Convert table to cell for debugging purposes
fox_cell = table2cell(transitions(1:216,1:6));
species_cell = table2cell(transitions(217:270,:));

%Convert cells to matrices to operate with them
%t_fox contains the factored transition matrix for the foxes
%t_species contains the factored transition matrix for the species
t_fox = cell2mat(fox_cell);
t_sp = cell2mat(species_cell);

%Give a numeric value to states
Fox = [1, 0];
PrevFox = [0, 1];
Species = [-1, 2, 3];
PrevSpecies = [-1, 2, 3];

%Number of fully observable variables
NX = length(Fox)*length(PrevFox)*length(Species)*length(PrevSpecies);

%Fox models
Y_F = ["F1","F2","F3","F4","F5","F6","F7","F8","F9"];
%Species models
Y_S = ["S1","S2","S3"];

%Number of hidden models
NY = length(Y_F)*length(Y_S);

%Management actions
A = ["a0","a1","a2","a3","a4","a5"];
%Number of actions
NA = length(A);

Y = zeros(length(Y_F)*length(Y_S), 2);



y_index = 1;

for yf = 1:9
    for ys = 1:3
   
        Y(y_index,1) = yf;
        Y(y_index,2) = ys;
        y_index = y_index+1;
    end 
end




S = "Fox PrevFox Species PrevSpecies"


States = zeros(NX, 4);

s_index = 1;

%Generate all the possible fully observable states
for f = 1:length(Fox)
    for pf = 1:length(PrevFox)   
        for sp = 1:length(Species) 
            for psp = 1:length(PrevSpecies)   
                    %s = strcat(Fox(f), " ", PrevFox(pf), " ", Species(sp), " ", PrevSpecies(psp));
                    States(s_index, 1) = Fox(f);
                    States(s_index, 2) = PrevFox(pf);
                    States(s_index, 3) = Species(sp);
                    States(s_index, 4) = PrevSpecies(psp);
                    s_index = s_index + 1;
            end  
        end      
    end  
end



%S = Fox, PrevFox, SPecies, PrevSpecies
%Variable indices
Fox = 1;
PrevFox = 2;
Species = 3;
PrevSpecies = 4;


%Rewards:
%Parse the rewards file. NOTE: The rewards has been manually extracted from
%the pomdpx file
r_matrix = readmatrix('rewards.txt');
%Initialize the reward matrix R
R = zeros(NX, NA);

%Convert the parsed reward matrix to a plain matrix
for a_state = 1:length(States)
    for action = 1:NA
        for rm = 1:length(r_matrix)
            if action-1 == r_matrix(rm, 1) && States(a_state, Species) == r_matrix(rm, 2)
                 R(a_state, action) = r_matrix(rm, 3);
                 break; 
            end
        end  
    end
   
end

save('R.mat', 'R');


%P_Fox = zeros(length(Fox),length(Fox),length(Y_F),NA);
%P_Species = zeros(length(Species), length(Species),length(Y_S));

%Initialize the transition function matrix
P = zeros(NX,NX,NY,NA);


%Transition matrix fox: 
    %YF A PrevFox Fox P(Fox'= H| PrevFox, PrevFox, YF, A)
%Transition matrix species: 
    %YS Fox PrevSpecies SPecies P(Species'=Ext) P(Species=L) P(Species=H)

model_id = 1;

%Unfactorise the transition matrices

for yf = 1:length(Y_F) %YF  
    for ys = 1:length(Y_S) %YS
        for a = 0:length(A)-1 %a
            for s = 1:length(States) %s
                for sp = 1:length(States) %s'
                

                    %If PrevFox' = Fox, PrevSpecies' = Species, YF'=YF, YS'=YS
                    if States(sp, PrevFox) == States(s, Fox) && States(sp, PrevSpecies) == States(s, Species)

                        transition = strcat('From:', num2str(States(s,:)), ' to:  ', num2str(States(sp, :)) );
                        %transition
                        
                        %We have to search in the transition fox those
                        %entries where Fox = s(Fox), PrevFox = s(PrevFox)
                        %and apply P(Fox=sp(Fox)|s(Fox,), s(PrevFox))
                        prob_fox = 0;
                        for tf = 1:length(t_fox)
                            if t_fox(tf, 1) == yf && t_fox(tf, 2) == a && t_fox(tf, 3) == States(s, Fox) && t_fox(tf, 4) == States(s, PrevFox)
                                if States(sp, Fox) == 1
                                    prob_fox = t_fox(tf, 5);
                                else
                                    prob_fox = t_fox(tf, 6);
                                end
                                break;
                            end
                        end
                        
                        %prob_fox
                        
  
                        %We have to search in the transition species those
                        %entries where:
                        %Fox = s(Fox), Species = s(Species), PrevSpecies = s(PrevSpecies)
                        % and apply P(Species'=sp(Spcecies)|sp(Fox), sp(Species), sp(PrevSpecies))
                        prob_species = 0.0;
                        
                        for ts = 1:length(t_sp)
                            %t_sp(ts, :)
                            %States(s, :)
                            if t_sp(ts, 1) == ys && t_sp(ts, 2) == States(s, Fox) && t_sp(ts, 3) == States(s, Species) && t_sp(ts, 4) == States(s, PrevSpecies)
                               
                                
                                if States(sp, Species) == -1
                                    prob_species = t_sp(ts, 5);
                                elseif States(sp, Species) == 2
                                    prob_species = t_sp(ts, 6);
                                else
                                    prob_species = t_sp(ts, 7);
                                end
                                break;
                            end
                        end
                        
                        %prob_species
                        P(s, sp, model_id, a+1) = prob_fox*prob_species;
                        

                    end %endif
                    
                    
                end
            end
        end
        model_id = model_id + 1;  
    end
end



%Save the transition matrix
save('P.mat', 'P');









  
