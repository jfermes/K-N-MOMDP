function [value] = s_p(alpha, alphap, Delta_subset, dot_products, dot_products_subsets, subset)



%s'(alphap, beta) = alphap . b - alpha . beta(2)


%alpha . b - beta(2)

%max_b alpha . b - beta(2)



diff_value = dot_products_subsets{subset}(alphap, :) - dot_products_subsets{subset}(alpha, Delta_subset(:));
%diff_value =  beta(2) - dot_products_subsets{subset}(alpha, :);
value = max(diff_value);
%value = value_old;

end