function [Gamma, Gamma_attributes, Gamma_subsets_ids, Gamma_subsets] = parse_policy_file(XMLfile)

%PARSE POLICY FILE---------------------------------------------------------


promptXML = 'Policy filename between simple comas (<path/filename>.policy):';
%XMLfile = input(promptXML);

type('parseXML.m')
xml = parseXML(XMLfile);


alphaVectors = xml.Children(2);


belief_size = str2num(alphaVectors.Attributes(3).Value);%Size of the alpha-vectors
X_size = str2num(alphaVectors.Attributes(1).Value);%Number of fully observable states
Gamma_size = str2num(alphaVectors.Attributes(2).Value);%Number of alpha vectors


Vectors = alphaVectors.Children;

Gamma_attributes = zeros(Gamma_size, 2);% (alpha-vector-id: (action, x))
Gamma = zeros(Gamma_size, belief_size);


for v = 1:size(Vectors,2)
   
  if strcmp(Vectors(v).Name, 'Vector')
      %Store alpha vector attributes (action, x) per each alpha vector      
      Gamma_attributes(v/2, 1) = str2num(Vectors(v).Attributes(1).Value);
      Gamma_attributes(v/2, 2) = str2num(Vectors(v).Attributes(2).Value);
      
      %Store the alpha vector
      Gamma(v/2,:) = str2num(Vectors(v).Children.Data);
 
      %Note: We divide by 2 because for some reason xml parser duplicates
      %the entries with empty text.
      
  end
        
    
end


%Gamma_subsets: \Gamma_x

Gamma_subsets_ids = cell(X_size, 1);
Gamma_subsets = cell(X_size, 1);

    
    for gs = 1:X_size
       Gamma_subsets_ids{gs} = [];
       Gamma_subsets{gs} = [];
    end

    for g = 1:length(Gamma)
       x = Gamma_attributes(g, 2)+1;
       Gamma_subsets_ids{x} = [Gamma_subsets_ids{x}; g];
       Gamma_subsets{x} = [Gamma_subsets{x}; Gamma(g,:)];

    end


end