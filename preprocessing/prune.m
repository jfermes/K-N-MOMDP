function[pruned_Gamma, pruned_Gamma_subsets, pruned_Gamma_Attributes] = prune(Gamma, Gamma_subsets, Gamma_Attributes, beliefs)

    %Alpha vectors from gamma are pruned if they don't dominate any other alpha
    %vectors. An alpha vector \alpha_1 dominates another one \alpha_2 if for all b \in B:
    %\alpha_1 . b >= \alpha_2 .b

    % pruned_Gamma_subsets = Gamma_subsets;

    %Precompute dot products alpha.b
    [dot_products, dot_products_subsets] = alpha_b(Gamma, beliefs, Gamma_subsets);



    %Pre-compute dominated subspace for each alpha vector regarding each other alpha vector
    [dominated_subspace, dominated_subspace_subsets] = subspace(Gamma, Gamma_subsets, beliefs, dot_products, dot_products_subsets);



    %if an alpha does not dominate any others, we prune that alpha-vector


    alphas_iterator = 1;
    for dss = 1:length(dominated_subspace_subsets)

        for a = 1:size(dominated_subspace_subsets{dss},1)
           
            
            [k] = find(dominated_subspace_subsets{dss}(a,:));
            
            %If there is no domination, we prune alpha a in subset dss
            if isempty(k)
            
                Gamma_subsets{dss}(a,:) = nan;
               % alphas_iterator
                Gamma(alphas_iterator, :) = nan;
                
            end
            
            alphas_iterator = alphas_iterator + 1;
        end

    end
    
    1+1
    %Create new pruned Gammas
    
    
    pruned_Gamma = [];
    pruned_Gamma_Attributes = [];
    pruned_Gamma_subsets = cell(length(Gamma_subsets), 1);
    
    for g = 1:length(Gamma_subsets)
        
       pruned_Gamma_subsets{g} = []; 
        
    end
    
    
    
    for a = 1:length(Gamma)
        
        if isnan(Gamma(a,:))
            continue;     
        end
        
        pruned_Gamma = [pruned_Gamma; Gamma(a,:)];
        pruned_Gamma_Attributes = [pruned_Gamma_Attributes; Gamma_Attributes(a,:)];
        
        
    end
    
    for gs = 1:length(Gamma_subsets)
       
        for ags = 1:length(Gamma_subsets{gs})
            
        if isnan(Gamma_subsets{gs}(ags,:))
            continue;     
        end
        
        pruned_Gamma_subsets{gs} = [pruned_Gamma_subsets{gs}; Gamma_subsets{gs}(ags,:)];
            
            
        end
        
        
    end
    
    


end