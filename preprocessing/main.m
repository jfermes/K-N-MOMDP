%PARSE BELIEFs FILE----------------------------------------------------------------


%Parse the beliefs from the evaluation output.
%We have as many beliefs as: #steps * #simulations

promptBelief = 'Beliefs filename between simple comas (<path/filename>.policy):';
%beliefFilename = input(promptBelief);
beliefFilename = 'beliefs.txt';
beliefs = readmatrix(beliefFilename);
beliefs(:,size(beliefs,2)) = [];

cleaned_beliefs = clean_beliefs(beliefs);

%Parse policy file
[Gamma, Gamma_attributes, Gamma_subsets] = parse_policy_file();


%Prune alpha-vectors if required
[prunned_Gamma_ids, prunnes_Gamma] = prune(Gamma, Gamma_subsets, cleaned_beliefs); 
