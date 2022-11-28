function [upsilon] = group_repeated_indices(A)

    [N, E] = histcounts(A, unique(A));
    value  = E(N > 1);
    
    upsilon  = cell(1, numel(value));
    
   
        
%A=[1,1,2,2,2,2,3];
un = unique(A);



[N, E] = histcounts(A, un);
value  = E(N > 1);

%upsilon  = cell(1, numel(E));
%for k = 1:numel(E)
%  upsilon{k} = find(A == E(k));
%end
upsilon  = cell(1, numel(value));
for k = 1:numel(value)
  upsilon{k} = find(A == value(k));
end
    
        
   %ll =  find(A == value);
   
      
   % if isempty(ll) == 0
    
    
   %     for k = 1:numel(value)
   %         upsilon{k} = find(A == value(k));
   %     end

        if k <= 1
            k = 0;
        end

        A = [1:length(A)];

        inbuckets = [];
        for u = 1:size(upsilon,2)
            inbuckets = [inbuckets upsilon{u}];
        end

        C = setdiff(A, inbuckets);

        for u = 1:length(C)
            k = k+1;
           upsilon{k} = C(u); 
        end
        
   % else
        
  %     upsilon{1} = [1:length(A)]; 
        
  %  end



end