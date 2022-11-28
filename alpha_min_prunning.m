function [Gamma_N, Gamma_N_subsets, d, time] = alpha_min_prunning(Gamma, Gamma_subsets, Gamma_attributes, beliefs, precision, N)


    %To complete: Implements a Gamma abstraction by prunning alpha vectors that are similar
    %given a metric
    %
    %Input:
    %
    %   Gamma: A set of alpha vectors such that Gamma = Ux Gamma_x
    %   AlphaVectorAttributes: action and fully observable variable associated
    %   to each alpha vector
    %   precision: precision parameter
    %   N: The desired number of alpha vectors
    %   %X: the total number of fully obs vars
    %
    %Output: 
    %
    %   GammaTilde: A reduced set of alpha vectors.
    %   time: Time to compute N alpha vectors (for information purposes)
    %


    num_alpha_vectors = length(Gamma);
    num_full_obs_vars = size(Gamma_subsets, 1);
    
    %Precompute dot products alpha.b
    [dot_products, dot_products_subsets] = alpha_b(Gamma, beliefs, Gamma_subsets);
    
    
    d_lower = 0;
    d_upper = 300; % This must be set to VMAX
    
    p = d_upper - d_lower;%To refine precision
    
    %To get the size of alpha vectors we just need to get the size of the first
    %alpha vector in Gamma
    alpha_vector_size = length(Gamma(1, :));
    
    %Initialize data structures------------------------------
    Gamma_N = [];
    Gamma_N_subsets = cell(num_full_obs_vars, 1);
    bindings_subsets = cell(num_full_obs_vars, 1);
    uniques = cell(num_full_obs_vars, 1);
    GammasIdx = cell(num_full_obs_vars,1);

    
    for gs = 1:length(Gamma_subsets)
       
        Gamma_N_subsets{gs} = [];
        bindings_subsets{gs} = {};
        uniques{gs} = {};
        GammasIdx{gs} = {};
    end
    
    
    for g = 1:length(Gamma)
    
        x = Gamma_attributes(g, 2)+1;
        action = Gamma_attributes(g, 1);
        GammasIdx{x} = [GammasIdx{x}; g];
    end
    %---------------------------------------------------------
    

    reduced_policy = [];
    
    tic;
    while p > precision
        
        
        p = d_upper - d_lower; %To refine precision  
        d = d_lower + (d_upper - d_lower)/2; %Binary search on d
        %d = 0.3;
        
        %Ceil alpha vectors and store the values in bindings
        for x = 1:size(Gamma_subsets, 1)
           for a = 1:size(Gamma_subsets{x},1)
               
               bindings_subsets{x} = [bindings_subsets{x}; ceil(Gamma_subsets{x}(a,:)/d)];            
           end
        end
        
        
         %Take the unique values. This will show those alpha-vectors that
         %belong to the same bucket---------------------------------
         for b = 1:size(bindings_subsets,1)
            
            M = cell2mat(bindings_subsets{b});
            [B, ia, ic] = unique(M, 'rows');
            
            uniques{b} = ic'; 
            
            clear M;
            clear B;
            clear ia;
            clear ic;

         end
         
         %------------------------------------------------------
         
         tmp_number_abstractions = 0;
         policy = [];
         
         
         %For those alpha-vectors that belong to the same bucket, we have
         %to consider those ones that: 
         %argmin_{alpha_x \in buckets; b \in B} (V(x,b) - \alpha_x. b)
         for u = 1:length(uniques)
             
           
               tmp_number_abstractions = tmp_number_abstractions + max(uniques{u});
               

               %indices of the equivalent alpha-vectors
              upsilon = group_repeated_indices(uniques{u});
              
               [best_policy] = best_alpha_vectors(Gamma, Gamma_subsets, upsilon, uniques{u}, u, beliefs, dot_products_subsets);
               
                    for bp = 1:length(best_policy)
                        policy = [policy; GammasIdx{u}{best_policy(bp)}];
                    end
  

         end
         

         if tmp_number_abstractions <= N
            number_abstractions = tmp_number_abstractions;
            reduced_policy = policy;
            d_upper = d;
        else
            d_lower = d;
            clear policy;
        end
        
       % clear bindings_subsets;
         %Ceil alpha vectors and store the values in bindings
        for x = 1:size(Gamma_subsets, 1)
               bindings_subsets{x} = {};            
        end
        clear uniques;
        

        
   end
    
    
    time = toc;
    
    
%Once the policy has been reduced we store it into an xml file with format
%.policy

reduced_policy_filename = strcat('alpha_min_prunning_N_' ,num2str(N), '.policy');

belief_size = size(beliefs, 2);

print_reduced_policy(Gamma_attributes, Gamma, reduced_policy, belief_size, num_full_obs_vars, reduced_policy_filename);


end