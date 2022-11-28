function [dot_products, dot_products_subsets] = alpha_b(Gamma, beliefs, Gamma_subsets)

%This function pre-computes all products \alpha.b
%The output is a matrix |Gamma| x |B|


dot_products = zeros(length(Gamma), length(beliefs));
dot_products_subsets = cell(length(Gamma_subsets), 1);


for g = 1:length(Gamma_subsets)
   
    dot_products_subsets{g} = [];
    
end


for gs = 1:size(Gamma_subsets,1)
       
    for av = 1:size(Gamma_subsets{gs},1)
    
        product = [];
        
       
        
        for b = 1:length(beliefs)
          
            product = [product; dot(Gamma_subsets{gs}(av,:), beliefs(b,:));];
            
        end
        
        dot_products_subsets{gs} = [dot_products_subsets{gs}; product'];
        

    end
    
    
end




    for av = 1:size(Gamma,1) 
        for b = 1:size(beliefs,1)
           dot_products(av,b) = dot(Gamma(av,:), beliefs(b,:));    
        end
    end
    



end