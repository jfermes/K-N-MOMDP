%Variables

%Fox = ["H", "L"];
%PrevFox = ["H", "L"];
%Species = ["Ext","L", "H"];
%PrevSpecies = ["Ext","L", "H"];

Fox = [1, 0];
PrevFox = [0, 1];
Species = [-1, 2, 3];
PrevSpecies = [-1, 2, 3];


NX = length(Fox)*length(PrevFox)*length(Species)*length(PrevSpecies);

Y_F = ["F1","F2","F3","F4","F5","F6","F7","F8","F9"];
Y_S = ["S1","S2","S3"];


NY = length(Y_F)*length(Y_S);


A = ["a0","a1","a2","a3","a4","a5"];
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

%Fox = {L = 0, H = 1};
%Species = {Ext = -1, L = 2, H = 3};

States = zeros(NX, 4);

s_index = 1;

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

r_matrix = readmatrix('rewards.txt');
R = zeros(NX, NA);


for a_state = 1:length(States)
   
    for action = 1:NA
        action
        
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

t_fox = readmatrix('potoroos_transition_matrices_fox.txt');
t_sp = readmatrix('potoroos_transition_matrices_species.txt');

P = zeros(NX,NX,NY,NA);


%Transition matrix fox: 
    %YF A PrevFox Fox P(Fox'= H| PrevFox, PrevFox, YF, A)
%Transition matrix species: 
    %YS Fox PrevSpecies SPecies P(Species'=Ext) P(Species=L) P(Species=H)

model_id = 1;

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




save('P.mat', 'P');













