function [best_policy] = best_alpha_vectors(Gamma, Gamma_subsets, upsilon, uniques, subset, beliefs, dot_products_subsets)

    %For those alpha-vectors that belong to the same bucket, we have to consider those ones that: 
    %argmin_{alpha_x \in buckets; b \in B} (V(x,b) - \alpha_x. b)

    best_policy = [];


    max_diffs = cell(size(upsilon, 1), 1);
    
              %1,2,3,4,5,6
    uniques = [4,4,4,4,4,1];
   
    
   upsilon = group_repeated_indices(uniques);
   
   %subset
  % uniques
   %upsilon
   

    for i = 1:size(upsilon,2)
        max_diffs{i} = [];
    end


        for r = 1:size(upsilon, 2)
            
            for a = 1:length(upsilon{r})
                
                 diff = [];
                %Take the alpha that minimizes the maximum gap?
                for b = 1:size(beliefs,1)

                     value = max(dot_products_subsets{subset}(:,b));
                     ab = dot_products_subsets{subset}(upsilon{r}(a), b);
                     diff = [diff; value - ab];
                
                end  
                
                    max_diffs{r} = [max_diffs{r}; max(diff)];
            end
            
            [minval, alpha_star] = min(max_diffs{r});
            
            best_policy = [best_policy upsilon{r}(alpha_star)];
            
            
        end





end