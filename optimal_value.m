function [value] = optimal_value(x, b, dot_product_subsets)

    
    value = max(dot_product_subsets{x}(:,b));




end