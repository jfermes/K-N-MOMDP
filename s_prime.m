function [value] = s_prime(alpha, beta, dot_products_subsets, subset)


%s'(alpha, beta) = alpha. beta(1) - beta(2)


%alpha . b - beta(2)

%max_b alpha . b - beta(2)


value =  beta(2) - dot_products_subsets{subset}(alpha, beta(1));


%value = beta(2) - max(dot_products_subsets{subset}(alpha, :));
%diff_value = dot_products_subsets{subset}(alpha, :) - beta(2);
%diff_value =  beta(2) - dot_products_subsets{subset}(alpha, :);
%value_max = max(diff_value);
%value = max(diff_value);
end