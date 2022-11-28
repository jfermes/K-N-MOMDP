function [] = convertMOMDPtoPOMDPX(P, R, X0, b0, discount, filename)

%Input
%
%P(X,X,Y,A)
%R(X,A) or TODO: R(X,X',A) or TODO: R(X,Y',A)
%Initial X X0(|X|)
%Initial belief b0(|Y|)
%discount factor
%filename to store the pomdpx file

%Output:
%fid: .pomdpx file

%filename = 'test.pomdpx';

%P = T_X;

fid = fopen(filename, 'w+');

    N_A = size(P, 4);
    N_X = size(P, 1);
    N_Y = size(P, 3);
    
        
    %R = normalize(R, 'range');
    
    
    header = '<?xml version="1.0" encoding="ISO-8859-1"?>';
    pomdpx = '<pomdpx version="0.1" id="adaptiveMgmt" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="pomdpx.xsd"> ';
    description = '<Description> This file has been generated using the MDPToolboxToPOMDPX converter </Description>';
    discount = '<Discount> 0.9 </Discount>';
    
    fprintf(fid, '%s\n', header);
    fprintf(fid, '%s\n', pomdpx);
    fprintf(fid, '%s\n', description);
    fprintf(fid, '%s\n', discount);
    
    %Variable
    fprintf(fid, '%s\n', '<Variable>');
    
    fprintf(fid, '\n');
    
    %StateVar
    %Fully obs
    fprintf(fid, '%s\n', '<StateVar vnamePrev= "x_0" vnameCurr= "x_1" fullyObs= "true">');
    fprintf(fid, '%s ', '<ValueEnum>');
    for x =1:N_X
        fprintf(fid, '%s ', strcat('x', num2str(x))); 
    end
    fprintf(fid, '%s\n', '</ValueEnum>');
    fprintf(fid, '%s\n', '</StateVar>');

    fprintf(fid, '\n');
    
    %StateVar
    %Hidden
    fprintf(fid, '%s\n', '<StateVar vnamePrev= "y_0" vnameCurr= "y_1" fullyObs= "false">');
    fprintf(fid, '%s ', '<ValueEnum>');
    for y =1:N_Y
        fprintf(fid, '%s ', strcat('y', num2str(y))); 
    end
    fprintf(fid, '%s\n', '</ValueEnum>');
    fprintf(fid, '%s\n', '</StateVar>');
    
    fprintf(fid, '\n');
    
    %Observations
    
     fprintf(fid, '%s\n', '<ObsVar vname= "obs_x">');
     fprintf(fid, '%s ', '<ValueEnum>');
     for x =1:N_X
        fprintf(fid, '%s ', strcat('ox', num2str(x))); 
     end
     fprintf(fid, '%s ', '</ValueEnum>');
	 fprintf(fid, '%s\n', '</ObsVar>');
    
    fprintf(fid, '\n');
    
    %Actions
    fprintf(fid, '%s\n', '<ActionVar vname= "actionsList">');
    fprintf(fid, '%s ', '<ValueEnum>');
    for a = 1:N_A
       fprintf(fid, '%s ', strcat('a', num2str(a))); 
    end
    fprintf(fid, '%s\n', '</ValueEnum>');
    fprintf(fid, '%s\n', '</ActionVar>');
    
    %Reward
    fprintf(fid, '%s\n', '<RewardVar vname= "reward_sp"/>');
    
    %Variable closure
    fprintf(fid, '%s\n', '</Variable>');
    
    fprintf(fid, '\n');
    
    %Initial belief
    
    fprintf(fid, '%s\n',  ' <InitialStateBelief>');
    fprintf(fid, '\n');
    
    %Initial belief fully obs var
    fprintf(fid, '%s\n', '<CondProb>');
    fprintf(fid, '%s\n', '<Var>x_0</Var>');
    fprintf(fid, '%s\n', '<Parent> null </Parent>');
    fprintf(fid, '%s\n', '<Parameter type= "TBL">');
    fprintf(fid, '%s\n', '<Entry>');
    fprintf(fid, '%s\n', '<Instance> - </Instance> ');
    
    fprintf(fid, '%s ', '<ProbTable> 1');
    for x_prob = 1:N_X-1
        fprintf(fid, '%s ', num2str(0));
    end
    fprintf(fid, '%s\n', '</ProbTable>');
    
    fprintf(fid, '%s\n', '</Entry>');
    fprintf(fid, '%s\n', '</Parameter>');
    fprintf(fid, '%s\n', '</CondProb>');
    
    fprintf(fid, '\n');
    
    %Initial belief for hidden model
    fprintf(fid, '%s\n', '<CondProb>');
    fprintf(fid, '%s\n', '<Var>y_0</Var>');
    fprintf(fid, '%s\n', '<Parent> null </Parent>');
    fprintf(fid, '%s\n', '<Parameter type= "TBL">');
    fprintf(fid, '%s\n', '<Entry>');
    fprintf(fid, '%s\n', '<Instance> - </Instance> ');
    
    fprintf(fid, '%s ', '<ProbTable>');
    for x_prob = 1:N_Y
         nearestValue = 0.0001;
         prob = round((1/N_Y)/nearestValue)*nearestValue;
         fprintf(fid, '%s ', num2str(prob));
        %prob = vpa(1/N_Y, 6);
        %fprintf(fid, '%s ', prob);
    end
    fprintf(fid, '%s\n', '</ProbTable>');
    
    fprintf(fid, '%s\n', '</Entry>');
    fprintf(fid, '%s\n', '</Parameter>');
    fprintf(fid, '%s\n', '</CondProb>');
    
    fprintf(fid, '%s\n',  ' </InitialStateBelief>');

    fprintf(fid, '\n');
    
    %State Transition Function
    
    fprintf(fid, '%s\n', '<StateTransitionFunction>');
    
    fprintf(fid, '\n');
    
    fprintf(fid, '%s\n', '<CondProb>');
    fprintf(fid, '%s\n', '<Var>x_1</Var>');
    fprintf(fid, '%s\n', '<Parent> y_0 actionsList x_0 </Parent>');
    fprintf(fid, '%s\n', '<Parameter type= "TBL">');
    
    
    
    for y = 1:N_Y
    
        for a = 1:N_A
       
            for x = 1:N_X
               fprintf(fid, '%s\n', '<Entry>'); 
               fprintf(fid, '%s\n', strcat('<Instance> y', num2str(y), ' a', num2str(a),' x', num2str(x),' - </Instance>'));
               fprintf(fid, '%s ', '<ProbTable>');
               for xp = 1:N_X
                   nearestValue = 0.00001;
                   prob = round(P(x,xp,y,a)/nearestValue)*nearestValue;
                   fprintf(fid, '%s ', num2str(prob));
               end
               fprintf(fid, '%s ', '</ProbTable> ');
               fprintf(fid, '\n');
               fprintf(fid, '%s\n', '</Entry>');

            end
            
        end
        
    end
    
    
    fprintf(fid, '%s\n', '</Parameter>');
    fprintf(fid, '\n');
    fprintf(fid, '%s\n', '</CondProb>');
    fprintf(fid, '\n');
    
    %Hidden state transition function
    fprintf(fid, '%s\n', '<CondProb>');
    fprintf(fid, '%s\n', '<Var>y_1</Var>');
    fprintf(fid, '%s\n', '<Parent>y_0</Parent>');
    fprintf(fid, '%s\n', '<Parameter type= "TBL">');
    fprintf(fid, '%s\n', '<Entry>');
    fprintf(fid, '%s\n', '<Instance>- - </Instance>');
    fprintf(fid, '%s\n', '<ProbTable>identity</ProbTable>');
    fprintf(fid, '%s\n', '</Entry>');
    fprintf(fid, '%s\n', '</Parameter>');
    fprintf(fid, '\n');
    fprintf(fid, '%s\n', '</CondProb>');
    fprintf(fid, '\n');
    fprintf(fid, '%s\n', '</StateTransitionFunction>');
    
    %Observation Function
    
    fprintf(fid, '%s\n', '<ObsFunction>');
    fprintf(fid, '%s\n', '<CondProb>');
    fprintf(fid, '%s\n', '<Var>obs_x</Var>');
    fprintf(fid, '%s\n', '<Parent>x_1</Parent>');
    fprintf(fid, '%s\n', '<Parameter type= "TBL">');
    
    fprintf(fid, '%s\n', '<Entry>');
    fprintf(fid, '%s\n', '<Instance>- -</Instance>');
    fprintf(fid, '%s\n', '<ProbTable>');
    
    for o = 1:N_X
       obs_v([1:N_X]) = 0;
       obs_v([o]) = 1;
       fprintf(fid, '%s ', num2str(obs_v));
       fprintf(fid, '\n');
    end
    fprintf(fid, '%s\n', '</ProbTable>');

              fprintf(fid, '\n');

    
    
   fprintf(fid, '%s\n', '</Entry>');
   
   fprintf(fid, '%s\n', '</Parameter>');
   fprintf(fid, '%s\n', '</CondProb>');
   fprintf(fid, '%s\n', '</ObsFunction>');
   
          fprintf(fid, '\n');

   
   
   %Reward Function
   
   fprintf(fid, '%s\n', '<RewardFunction>');
   
   fprintf(fid, '%s\n', '<Func>');
   
   fprintf(fid, '%s\n', '<Var>reward_sp</Var>');
    
   fprintf(fid, '%s\n', '<Parent> actionsList x_1 </Parent> ');
    
   fprintf(fid, '%s\n', ' <Parameter type= "TBL">');
    
    
    
   for a = 1:N_A
   
    fprintf(fid, '%s\n', '<Entry>');
    

        fprintf(fid, '%s\n', strcat('<Instance> a', num2str(a), ' - </Instance>'));
     
        fprintf(fid, '%s ', strcat('<ValueTable> ',  num2str(R(:, a)') , '</ValueTable>'));
        
         fprintf(fid, '\n');

   
   
    fprintf(fid, '%s\n', '</Entry>');
    
   end
   
      fprintf(fid, '%s\n', '</Parameter>');


   
   fprintf(fid, '%s\n', '</Func>');
   
   fprintf(fid, '%s\n', '</RewardFunction>');
   
   fprintf(fid, '%s\n', '</pomdpx>');

   
   
end