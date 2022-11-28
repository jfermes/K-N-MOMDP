function [value] = upper_bound(Gamma, dot_products)

%This function computes a first upper bound epsilon_upper

%Choose a random alpha-vector
random_alpha = randi([1 length(Gamma)]);


candidates = [];


for a = 1:length(Gamma)
    
    
    diff = abs( dot_products(random_alpha, :)  - dot_products(a, :));
    
    max_diff = max(diff);
    
    candidates = [candidates; max_diff];

end

value = max(candidates);

end