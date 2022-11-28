function [Values, Policies, PK, RK, S2K, K2S, time] = aStarKMOMDP_corners(K, precision, P, R, discount)

    %Given a MOMDP with transitions defined in P and Rewards defined in R, we
    %can obtain |Y|MDPs with transitions defined in P and rewards defined in R.
    %Note: Rewards will not change at each MDP as they depend on the actions and states.


    %1- Separate the MOMDP into |Y| MDPs.

    %P(X, X, Y, A)
    %R(X, A)

    N_A = size(P, 4);
    N_X = size(P, 1);
    N_Y = size(P, 3);
    
    %RO = R;

    % = normalize(R, 'range');
    
    
    %Eq1: forall MDP ceil(V(x)/d) = ceil(V(x')/d) and a*x = a*x'

    %Create a matrix to store the values of each state per each MDP

    Values = zeros(N_X, N_Y);
    Policies = zeros(N_X, N_Y);


    %2- Solve each MDP and computes its values and policies

    for y = 1:N_Y
        
        P_y = P(:,:,y,:);
        P_y = P_y(:,:,:);
        
        [Policy_y] = mdp_value_iteration(P_y,R,discount);
        
        %Value of applying PolicyK to the original MDP
        [V_y] = mdp_eval_policy_iterative(P_y, R, discount, Policy_y);
        
        Policies(:,y) = Policy_y;
        Values(:,y) = V_y*-1;
        
    end
    
    %3- Once we have all the values and policies, we can abstract the MDPs
    %using Eq1.
    
    
    tic;
    
    VMAX_row = max(Values);
    VMAX = max(VMAX_row);

    
    
    d_lower = 0;
    d_upper = VMAX;
    
    
    
    p = d_upper - d_lower; %To refine precision
    
    %Create a bindings structure 
    bindings = zeros(N_X, N_Y+N_Y);
    
    %Start the binary search
    
    number_abstractions = 0;
    
    
    while p > precision
        
      p = d_upper - d_lower; %To refine precision  
      d = d_lower + (d_upper - d_lower)/2; %Binary search on d
      
      
     
      for x = 1:N_X
         
          for y = 1:N_Y
             
              bindings(x,y) = ceil(Values(x,y)/d);              
          end
          
          for a = 1:N_Y
              bindings(x,N_Y+a) = Policies(x,a);
          end
      end
        
     [B,ia,ic] = unique(bindings, 'rows');
  
     tmp_number_abstractions = length(ia);
     
     
     %bindings
     
     
     
     if tmp_number_abstractions <= K
          %Here K must be the number of clusters in L. In this case is the size of ic;
          L= ic';
          number_abstractions = tmp_number_abstractions;
          d_upper = d;
      else
          d_lower = d;
      end

   
    end
    
    
    number_abstractions
    
     %Build the K-MOMDP with the abstracted state space
    
     PK = zeros(number_abstractions, number_abstractions, N_Y, N_A);
     
     
     for y = 1:N_Y
     
        %PK must be a matrix of the form PK(K, K, N_Y, N_A) 
        [PK_y,RK,S2K,K2S]=buildKMOMDP_R(P(:,:,y,:),R,L,N_A,N_X,number_abstractions); %Build the KMOMDP with k states and state space L
        
        PK(:,:,y,:) = PK_y;
        
        
     end
     
     %PK
     
     time = toc;
     


end