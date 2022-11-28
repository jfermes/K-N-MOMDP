function [polytopes, polytopes_subsets] = compute_polytopes(dominated_subspace, dominated_subspace_subsets, dot_products, dot_products_subsets, beliefs)



%Polytopes are the corners of the beliefs. \hat{B}(\alpha) are the
%polytopes of the dominated subspace

%A dominated_subspace_subset is of the form:

%
%
% \Gamma_x1 { \aplha_1: b1, b2, b5, b7; alpha_2: b3, b4
%
% \Gamma_x2 { \alpha_2: b2, b3, b6; \alpha_2: b1, b4, b5
%
%


%1- Get he dominated subspace of each alpha vector B(\alpha) in each \Gamma_x
%2- Get the corners of this dominated subspace \hat{B}(\alpha)
%3- The corners of a dominated subspace B(\alpha) are those ones: b1(1, 0,
%0, 0); b2(0,1,0,0), ...


polytopes = [];
polytopes_subsets = cell(length(dominated_subspace_subsets), 1);

for g = 1:length(dot_products_subsets)
   
    polytopes_subsets{g} = cell(size(dot_products_subsets{g},1),1);%[zeros(size(dot_products_subsets{g},1), 4)];
      
end

for dss = 1:length(dominated_subspace_subsets)
    
   
    for a = 1:size(dominated_subspace_subsets{dss},1)
   
        
        %For each subset \Gamma_x, check what beliefs the \alpha_x \in
        %\Gamma_x dominates, and then get the corners
        k = find(dominated_subspace_subsets{dss}(a,:));
        
        if length(k) == 1
           polytopes_subsets{dss}{a} = [polytopes_subsets{dss}{a}; k(1)];
           continue;
        end
        
        
        %K contains the indices of the dominated subspace. To check the
        %corners we have to 
        
        dominated_beliefs = zeros(length(k), size(beliefs,2));
        for d = 1:length(k)
           dominated_beliefs(d,:) = beliefs(k(d),:); 
        end
        
        [M, maximums] = max(dominated_beliefs);
        
        [maximums] = unique(maximums);
        
        for m = 1:length(maximums)
           
            corner_id = k(maximums(m));
            polytopes_subsets{dss}{a} = [polytopes_subsets{dss}{a}; corner_id];
        end
        
        
    end
    
    
    
    
end




end