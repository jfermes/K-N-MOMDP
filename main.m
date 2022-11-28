%Initialize parameters
addpath('preprocessing/')
addpath('parser')
addpath('converter')


have_license = license('test', 'optimization_toolbox');

if have_license == 0
    
    msg = 'Optimization Toolbox is required';
    error(msg);
        
end


precision_fast = 0.1;
precision_p = 0.1;
pression_prunning = 0.1;

N = [81];

%Get policy Gamma
policy_filename = 'problems/gouldian/gouldian4_alt.policy';
[Gamma, Gamma_attributes, Gamma_subsets_ids, Gamma_subsets] = parse_policy_file(policy_filename);


%Get belief space B
beliefs_filename = 'problems/gouldian/beliefs_gouldian4_alt_p12.txt';
[B] = parse_beliefs_file(beliefs_filename);
%[B_clean] = clean_beliefs(B);
B_clean = B;

[pruned_Gamma, pruned_Gamma_subsets, pruned_Gamma_attributes] = prune(Gamma, Gamma_subsets, Gamma_attributes, B_clean);
%pruned_Gamma = Gamma;
%pruned_Gamma_subsets = Gamma_subsets;
%pruned_Gamma_attributes = Gamma_attributes;

time_fast = zeros(length(N),1);
time_p = zeros(length(N),1);
time_pruning = zeros(length(N),1);


for i = 1:length(N)

n = N(i);

[Gamma_N_fast, epsilon_fast, epsilon_upper, time_fast(i)] = alpha_min_fast(pruned_Gamma, pruned_Gamma_subsets, pruned_Gamma_attributes, B_clean, precision_fast, n);

[Gamma_N_p, epsilon_p, g_ub, time_p(i)] = alpha_min_p(pruned_Gamma, pruned_Gamma_subsets, pruned_Gamma_attributes, B_clean, precision_p, n);

[Gamma_N, Gamma_N_subsets, d, time_pruning(i)] = alpha_min_prunning(pruned_Gamma, pruned_Gamma_subsets, pruned_Gamma_attributes, B_clean, pression_prunning, n);


end
