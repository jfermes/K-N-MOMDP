function [value] = s(alpha, alpha_p, dot_products, dot_products_subsets, dominated_subspace_subsets, polytopes_subsets, subset, type)


    %s(\alpha, \alpha') = max_{b \in \hat{B}(\alpha)}(\alpha . b - \alpha' . b)
    
    
    
    
    polytopes = polytopes_subsets{subset}{alpha};
    
    diff = [];
    
    for p = 1:length(polytopes)
        
        %d = dot_products(alpha,polytopes(p)) - dot_products_subsets{subset}(alpha_p, polytopes(p));
        d = dot_products_subsets{subset}(alpha,polytopes(p)) - dot_products_subsets{subset}(alpha_p, polytopes(p));
        diff = [diff; d];
        
    end

value = max(diff);




end