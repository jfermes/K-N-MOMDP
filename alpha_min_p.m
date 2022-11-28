function [Gamma_N, g_Delta, g_ub, time] = alpha_min_p(Gamma, Gamma_subsets, Gamma_attributes, B, precision, N)

    %Precompute dot products alpha.b
    [dot_products, dot_products_subsets] = alpha_b(Gamma, B, Gamma_subsets);


    %Initialize Delta as corners
    [Delta, Delta_subsets] = initialize_Delta(Gamma, Gamma_subsets, B, dot_products_subsets);


    d = Inf;
    g_ub = Inf;


tic;
    while d > precision/2

        %Return ids
       [Gamma_N_ids, Gamma_N_subsets_ids, g_Delta] = fast_beta(Gamma, Gamma_subsets, Gamma_attributes, Delta_subsets, precision/2, N, dot_products, dot_products_subsets);
       
        
        
      
       Gamma_N = zeros(length(Gamma_N_ids), size(Gamma,2));
       for gn = 1:length(Gamma_N_ids)
                alpha = Gamma_N_ids(gn);
                Gamma_N(gn,:) = Gamma(alpha,:);
           
       end
       
       Gamma_N_subsets = cell(size(Gamma_subsets,1),1);
                 
                 for gns = 1:length(Gamma_subsets)     
                     Gamma_N_subsets{gns} = [];
                 end
                 
                 for g = 1:length(Gamma_N_ids)
                      alpha = Gamma_N_ids(g);
                       full_obs_var = Gamma_attributes(alpha, 2)+1;
                        Gamma_N_subsets{full_obs_var} = [Gamma_N_subsets{full_obs_var}; Gamma_N(g,:)];

                  end
       
       
       
       
       
       [dot_products_N, dot_products_subsets_N] = alpha_b(Gamma_N, B, Gamma_N_subsets);
       
       Values = cell(size(Gamma_subsets,1), 1);
       Values_N = cell(size(Gamma_N_subsets,1), 1);
       
       for g = 1:length(Gamma_subsets)
            Values{g} = [];
            Values_N{g} = [];
       end
        
       for x = 1:length(dot_products_subsets)
           
           Values{x} = [max(dot_products_subsets{x}, [], 1)];
           Values_N{x} = [max(dot_products_subsets_N{x}, [], 1)];
           
       end

       
        %Now we compute b*

        %1)
        %\forall x \in X, b*_x = argmax_B (V(x,b) - V_{\Gamma_N}(x,b))
        
        
       B_stars = zeros(size(Gamma_subsets,1),1);

        for x = 1:size(Gamma_N_subsets,1)
            b_star_x = NaN;
            current_diff = -1000;
            
          
                
           UpdatedValues = Values{x}(:);
           UpdatedValues_N = Values_N{x}(:);
           
               
    for di = 1:length(Delta{x})
       
        UpdatedValues(Delta{x}(di)) = 0;
        UpdatedValues_N(Delta{x}(di)) = 0;

        
    end
    
    %  for deltas = 1:length(Delta{x})
                
     %           diff = Values{x}(Delta{x}(deltas)) - Values_N{x};
      %          [beta_diff, i] = max(diff);
                
       %         if beta_diff > current_diff
        %            current_diff = beta_diff;
         %           b_star_x = i;
          %      end
                
                
                
          %  end
           
                
            %diff2 = UpdatedValues - UpdatedValues_N;
            diff2 = Values{x} - Values_N{x};
           [max_diff, i] = max(diff2);
            B_stars(x) = i;
            
            
            
        end
        
        
        
        max_val = 0;
        min_val = 10000;
        for x = 1:size(Gamma_N_subsets,1)
            
                    diff = Values{x}(B_stars(x)) - Values_N{x}(B_stars(x));
                    if diff > max_val
                        max_val = diff;
                    end
                    %if diff < min_val
                    %   min_val = diff; 
                    %end
      
        end
        
        if g_ub < max_val
       %if g_ub < min_val
            g_ub = g_ub;
        else
            g_ub = max_val;
        end

       d =  g_ub - g_Delta;
       
       
        for x = 1:size(Gamma_N_subsets,1)

            
            beta = [B_stars(x), Values{x}(B_stars(x))];
            Delta_subsets{x} = [Delta_subsets{x}; beta];
            Delta{x} = [Delta{x}; B_stars(x)];
            
        end
        
        d
        
    end
    time = toc;
    
    %Once the policy has been reduced we store it into an xml file with format
%.policy

reduced_policy_filename = strcat('alpha_min_p_N_' ,num2str(N), '.policy');

belief_size = size(B, 2);
number_full_obs_vars = size(Gamma_subsets,1);

print_reduced_policy(Gamma_attributes, Gamma, Gamma_N_ids, belief_size, number_full_obs_vars, reduced_policy_filename);



end