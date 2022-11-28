function [Gamma_N, epsilon, epsilon_upper, time] = alpha_min_fast(Gamma, Gamma_subsets, Gamma_attributes, B, precision, N)

Gamma_N = [];
epsilon = 0.1;


number_alpha_vectors = length(Gamma);
number_full_obs_vars = length(Gamma_subsets);


%Precompute dot products alpha.b
[dot_products, dot_products_subsets] = alpha_b(Gamma, B, Gamma_subsets);


%Pre-compute dominated subspace for each alpha vector regarding each other alpha vector
[dominated_subspace, dominated_subspace_subsets] = subspace(Gamma, Gamma_subsets, B, dot_products, dot_products_subsets)


%Pre-comoute polytopes of the subspace B(\alpha) (corners)
[polytopes, polytopes_subsets] = compute_polytopes(dominated_subspace, dominated_subspace_subsets, dot_products, dot_products_subsets, B);



%LPFAST--------------------------------------------------------------------

%VARIABLES----------------------------------------
%There are as much variables as alpha-vectors
%Variables have the following format: xXA, where X is the fully obs
%variable and A is an alpha vector associated to that fully obs var X

variables = {};

for i = 1:number_alpha_vectors
   %variables = [variables; strcat('x', num2str(i))];
   variables = [variables; strcat('x', num2str(Gamma_attributes(i,2)), 'A' , num2str(i))];
end

for i = 1:number_alpha_vectors
   eval([variables{i}, '=', num2str(i), ';']);
    
end


%BOUNDS--------------------------------------------------------------------

%Lower bounds

lb = zeros(1, number_alpha_vectors);

%Upper bounds

ub = ones(1, number_alpha_vectors);


%CONSTRAINTS---------------------------------------------------------------


%Equality constraints------------------


%No equality constraints

Aeq = zeros(1, number_alpha_vectors);
beq = zeros(1,1);



%Inequality constraints---------------


% 1) \forall alpha' Sum_alpha c_a_ap x_alpha * (-1) <= -1
% 2) Sum alphas x_alpha <= N
% 3) \forall x, Sum alpha \in \Gamma_x X_x_alpha >= 1 -> \forall x, Sum
% alpha \in \Gamma_x X-x_a * (-1) <= -1

number_ineq_constraints = number_alpha_vectors + number_full_obs_vars + 1;
A = zeros(number_ineq_constraints, number_alpha_vectors); %Create matrix for inequality constraints
b = zeros(number_ineq_constraints, 1); %Create vector for inequality constraints



   %Define 2nd inequality constraint

   %A(number_ineq_constraints, :) = 1;
   %b(number_ineq_constraints) = N;
   
   Aeq = ones(1, number_alpha_vectors);
   beq = ones(1,1);
   beq(1,1) = N;
   
   
   %Define third inequality constraint
   
      
       for at = 1:length(Gamma_attributes)
          
           A(number_alpha_vectors + 1 + Gamma_attributes(at, 2), at) = -1;
           b(number_alpha_vectors + 1 + Gamma_attributes(at, 2)) = -1;
              
       end
           
   %ITCON vector--------------------------------------------------------------
   intcon = ones(1, number_alpha_vectors);%Since it is a pure integer linear program, all variables are integer


    %OBJECTIVE FUNCTION--------------------------------------------------------

    c = ones(number_alpha_vectors, 1);

%------------------------------------------------------------------------------



%START algorithm alpha-min fast***********************************************************************************

%set up the bounds

epsilon_lower = 0;
epsilon_upper = upper_bound(Gamma, dot_products);%VMAX
delta = epsilon_upper - epsilon_lower;
C = zeros(length(Gamma), length(Gamma));

tic;
while delta > precision
    
    
  delta = epsilon_upper - epsilon_lower;  
  epsilon = epsilon_lower + (epsilon_upper - epsilon_lower)/2;
  
  lastalpha1 = 0;
  lastalpha2 = 0;
  
  for gx = 1:size(Gamma_subsets,1)
      
      for a = 1:size(Gamma_subsets{gx},1)
          
          for ap = 1:size(Gamma_subsets{gx},1)

             if s(a, ap, dot_products, dot_products_subsets, dominated_subspace_subsets, polytopes_subsets, gx, 'polytopes') <= epsilon
                 C(lastalpha1 + a, lastalpha2 + ap) = 1;
             else
                 C(lastalpha1 + a, lastalpha2 + ap) = 0;
             end
                
              
          end
          
      end
      
      lastalpha1 = lastalpha1 + a;
      lastalpha2 = lastalpha2 + ap;
      
  end
  
  
    %Define 1st inequality constraint

        for ineq = 1:number_alpha_vectors

           A(ineq,:) = C(ineq,:)*(-1);
           b(ineq) = -1;

        end
        
    
        %Call integer linear program

        [x, objVal, exitflag] = intlinprog(c, intcon, A, b, Aeq, beq, lb, ub);

        if exitflag == 1
            
            epsilon_upper = epsilon;
            policy = [];
            %Print results
            for i = 1:number_alpha_vectors
                if x(i) == 1
                 fprintf('%s \t %20.4f\n', variables{i}, x(i))
                 var = strsplit(variables{i}, 'A');
                 
                 policy = [policy; str2num(var{2})];
                 reduced_policy = policy;
                end
            end
            
            gap = epsilon;
        
        else
          
            epsilon_lower = epsilon;
            clear policy;
            
        end
      
    
end

time = toc;



%Once the policy has been reduced we store it into an xml file with format
%.policy

reduced_policy_filename = strcat('alpha_min_fast_polytopes_N_' ,num2str(N), '.policy');

belief_size = size(B, 2);

print_reduced_policy(Gamma_attributes, Gamma, reduced_policy, belief_size, number_full_obs_vars, reduced_policy_filename);


end