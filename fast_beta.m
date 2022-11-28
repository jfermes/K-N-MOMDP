function [Gamma_N, Gamma_N_subsets, g_Delta] = fast_beta(Gamma, Gamma_subsets, Gamma_attributes, Delta_subsets, precision, N, dot_products, dot_products_subsets)

    num_alpha_vectors = length(Gamma);
    num_full_obs_vars = length(Gamma_subsets);

    %LPFAST--------------------------------------------------------------------

    %VARIABLES----------------------------------------
    %There are as much variables as alpha-vectors
    %Variables have the following format: xXA, where X is the fully obs
    %variable and A is an alpha vector associated to that fully obs var X

    variables = {};

    for i = 1:num_alpha_vectors
       %variables = [variables; strcat('x', num2str(i))];
       variables = [variables; strcat('x', num2str(Gamma_attributes(i,2)), 'A' , num2str(i))];
    end

    for i = 1:num_alpha_vectors
       eval([variables{i}, '=', num2str(i), ';']);

    end


    %BOUNDS--------------------------------------------------------------------

    %Lower bounds

    lb = zeros(1, num_alpha_vectors);

    %Upper bounds

    ub = ones(1, num_alpha_vectors);


    %CONSTRAINTS---------------------------------------------------------------


    %Equality constraints------------------

    %Aeq = zeros(1, num_alpha_vectors);
    %beq = zeros(1,1);
    
    %Inequality constraints---------------


    % 1) \forall alpha' Sum_alpha c_a_ap x_alpha * (-1) <= -1
    % 2) Sum alphas x_alpha <= N
    % 3) \forall x, Sum alpha \in \Gamma_x X_x_alpha >= 1 -> \forall x, Sum
    % alpha \in \Gamma_x X-x_a * (-1) <= -1

    %number_ineq_constraints = num_alpha_vectors + num_full_obs_vars + 1;
    
    size_Delta = size(Delta_subsets,1) * size(Delta_subsets{1},1);
    
    num_ineq_constraints = size_Delta + num_full_obs_vars + 1;
    A = zeros(num_ineq_constraints, num_alpha_vectors); %Create matrix for inequality constraints
    b = zeros(num_ineq_constraints, 1); %Create vector for inequality constraints



   %Define 2nd inequality constraint

   %A(num_ineq_constraints, :) = 1;
   %b(num_ineq_constraints) = N;
   
   %Aeq = zeros(1, num_alpha_vectors);
   %beq = zeros(1,1);
   
   Aeq = ones(1, num_alpha_vectors);
   beq = ones(1,1);
   beq(1,1) = N;
   
   
   %Define third inequality constraint
   
      
       for at = 1:length(Gamma_attributes)
          
           A(size_Delta + 1 + Gamma_attributes(at, 2), at) = -1;
           b(size_Delta + 1 + Gamma_attributes(at, 2)) = -1;
              
       end
           
   %ITCON vector--------------------------------------------------------------
   intcon = ones(1, num_alpha_vectors);%Since it is a pure integer linear program, all variables are integer


    %OBJECTIVE FUNCTION--------------------------------------------------------

    c = ones(num_alpha_vectors, 1);


    %------------------------------------------------------------------------------

    epsilon_lower = 0;
    epsilon_upper = upper_bound(Gamma, dot_products);
        epsilon_upper = 100;

    d = epsilon_upper - epsilon_lower;
    %C = zeros(length(Gamma), size(Delta_subsets{1},1));
    C = zeros(size(Delta_subsets{1},1), length(Gamma));
    
    
    while d > precision
        
        d = epsilon_upper - epsilon_lower;  
        epsilon = epsilon_lower + (epsilon_upper - epsilon_lower)/2;

        
          lastalpha = 0;
          lastbeta = 0;
        
          for gx = 1:size(Gamma_subsets,1)

              for a = 1:size(Gamma_subsets{gx},1)

                  for beta = 1:size(Delta_subsets{gx},1)

                      
                     value =  s_prime(a, Delta_subsets{gx}(beta,:), dot_products_subsets, gx);
                    if value <= epsilon
                       
                       C(lastbeta + beta, lastalpha + a) = 1; 
                    else
                       C(lastbeta + beta, lastalpha + a) = 0;
                        
                    end
                      
                      
                  end

              end

              lastalpha = lastalpha + a;
              lastbeta = lastbeta + beta;

          end
          
          
        %Define 1st inequality constraint        
        for ineq = 1:size_Delta
           A(ineq,:) = C(ineq,:)*(-1);
           b(ineq) = -1;
        end
        
                 %Call integer linear program

        [x, objVal, exitflag] = intlinprog(c, intcon, A, b, Aeq, beq, lb, ub);

        if exitflag == 1
            
            epsilon_upper = epsilon;
            policy = [];
            %Print results
            for i = 1:num_alpha_vectors
                if x(i) == 1
                 fprintf('%s \t %20.4f\n', variables{i}, x(i))
                 var = strsplit(variables{i}, 'A');
                 
                 policy = [policy; str2num(var{2})];
                 Gamma_N = policy;
                 Gamma_N_subsets = cell(size(Gamma_subsets,1),1);
                 
                 for gns = 1:length(Gamma_subsets)     
                     Gamma_N_subsets{gns} = [];
                 end
                 
                  for g = 1:length(Gamma_N)
                      alpha = Gamma_N(g);
                       full_obs_var = Gamma_attributes(alpha, 2)+1;
                      %Gamma_subsets_ids{x} = [Gamma_subsets_ids{x}; g];
                        Gamma_N_subsets{full_obs_var} = [Gamma_N_subsets{full_obs_var}; Gamma_N(g,:)];

                  end
                 
                 
                 
                 
                end
            end
            
            g_Delta = epsilon;
        
        else
          
            epsilon_lower = epsilon;
            clear policy;
            
        end
          %cnt=sum(C(C==1))

end











end