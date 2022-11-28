function [dominated_subspace, dominated_subspace_subsets] = subspace(Gamma, Gamma_subsets, beliefs, dot_products, dot_products_subsets)

%This function returns, per each alpha-vector, the ids of the beliefs it
%dominates


dominated_subspace = cell(length(dot_products),1);
dominated_subspace_subsets = cell(length(dot_products_subsets),1);


for g = 1:length(dot_products_subsets)
   
    dominated_subspace_subsets{g} = []; %[zeros(size(dot_products_subsets{g},1), 1)];
    
    
end


for gs = 1:length(dot_products_subsets)
   
    the_max = zeros(size(dot_products_subsets{gs},1), length(beliefs));
    
    for b = 1:length(beliefs)
       
        [val, alpha_idx] = max(dot_products_subsets{gs}(:,b));
        the_max(alpha_idx, b) = 1;
        
    end
    
      dominated_subspace_subsets{gs} = [dominated_subspace_subsets{gs}; the_max]; 
       
            
end



end