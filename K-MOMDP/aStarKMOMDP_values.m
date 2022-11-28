function [Values, Policies, PK, RK, S2K, K2S, time] = aStarKMOMDP_values(K, precision, Gamma, Beliefs, P, R, GammaAttributes, num_full_obs_vars)



 %Given a the set of alpha-vectors Gamma and the Belief space,
 %aStarKMOMDP_values compute and state abstraction on the fully observable
 %state space
 
 
    N_A = size(P, 4);
    N_X = size(P, 1);
    N_Y = size(P, 3);

    %R = normalize(R, 'range');
 
  
  Gammas = cell(num_full_obs_vars, 1);
  GammasActions = cell(num_full_obs_vars, 1);
  Values = zeros(num_full_obs_vars, length(Beliefs));
  Policies = zeros(num_full_obs_vars, length(Beliefs));
    
   for gs = 1:num_full_obs_vars
      Gammas{gs} = {};
      GammasActions{gs} = {};
   end

   for g = 1:length(Gamma)

      x = GammaAttributes(g, 2)+1;
      Gammas{x} = [Gammas{x}; Gamma(g,:)*-1];
      %Gammas{x} = [Gammas{x}; Gamma(g,:)];
      GammasActions{x} = [GammasActions{x}; GammaAttributes(g,1)];
   end

   
   
   for x = 1:num_full_obs_vars
       
       max_val = -10000;
       
       for b = 1:length(Beliefs)
       max_val = -10000;
           
            for a = 1:length(Gammas{x})
                
                tmp_val = dot(Gammas{x}{a}, Beliefs(b, :));
               
                                
                if tmp_val > max_val
                    max_val = tmp_val;
                    Values(x,b) = max_val;
                    Optimal_actions(x,b) =  GammasActions{x}{a};
                end

            end
            
       end
       
       
   end
   
   %Once we have all the possible Values for pairs x,b, we abstract them
   
   
   VMAX_row = max(Values);
   VMAX = max(VMAX_row);
   
   number_abstractions = 0;

   
   d_lower = 0;
   d_upper = VMAX;
   p = d_upper - d_lower;
   
  % bindings = zeros(num_full_obs_vars, length(Beliefs));
   bindings = zeros(num_full_obs_vars, length(Beliefs) + length(Beliefs));
   
   
   
   tic;
   
   while p > precision
       
       
      p = d_upper - d_lower; %To refine precision  
      d = d_lower + (d_upper - d_lower)/2; %Binary search on d
      
      for x = 1:num_full_obs_vars
         
          for b = 1:length(Beliefs)
              
             bindings(x,b) = ceil(Values(x,b)/d); 
             bindings(x, length(Beliefs)+b) = Optimal_actions(x,b);
              
          end
          
      end
      
      
      
      
      
      [B,ia,ic] = unique(bindings,'rows');
      tmp_number_abstractions = length(ia);
      
      tmp_number_abstractions
      
      if tmp_number_abstractions <= K
          %Here K must be the number of clusters in L. In this case is the size of ic;
          L= ic';
          number_abstractions = tmp_number_abstractions;
          d_upper = d;
      else
          d_lower = d;
      end
       
       
       
   end
   
    %Build the K-MOMDP with the abstracted state space
    
     PK = zeros(number_abstractions, number_abstractions, N_Y, N_A);
     
     %L
     
     number_abstractions
    
     for y = 1:N_Y
     
        %PK must be a matrix of the form PK(K, K, N_Y, N_A) 
        [PK_y,RK,S2K,K2S]=buildKMOMDP_R(P(:,:,y,:),R,L,N_A,N_X,number_abstractions); %Build the KMOMDP with k states and state space L
        
        PK(:,:,y,:) = PK_y;
        
        
     end
     
     time = toc;
   
   
   
  

end
