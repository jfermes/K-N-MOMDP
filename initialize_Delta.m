function [Delta, Delta_subsets] = initialize_Delta(Gamma, Gamma_subsets, beliefs, dot_product_subsets)


    Delta = {};
    Delta_subsets = cell(length(Gamma_subsets),1);

    for gs = 1:length(Gamma_subsets)
        Delta_subsets{gs} = [];
        Delta{gs} = [];
    end


    [M, corners] = max(beliefs);


    %For Gamma_x
    for x = 1:size(Gamma_subsets,1)
        
        for c = 1:length(corners)
              
            product = [];
            
            %For alpha \in Gamma_X
            for a = 1:size(Gamma_subsets{x},1)
                %dot_product_subsets{x}(a, corners(c))
               product = [product; dot_product_subsets{x}(a, corners(c))]; 
            end
            
            %Take value as V(x, corner) = max_a (a\lpha . b)
            v = max(product);
            
            beta = [corners(c), v];
            
            Delta{x} = [Delta{x}; corners(c)];
            Delta_subsets{x} = [Delta_subsets{x}; beta];

        end

    end
    
       

end