function [PK,RK,SK,row]=buildKMOMDP_R(P,R,L,na,ns,K)

SK=zeros(ns,2); %The new abstract state space Sk
PK=zeros(K,K,na); % P(SxSxA) = abstract transition probability matrix
RK=zeros(K,na); % R(SxA) = abstract reward matrix
RSA=zeros(ns,na);


%SK done: Abstracted state space Sk
SK(:,1)=[1:ns];
SK(:,2)=L;




% turn R into R(s,a)
for a=1:na
    for s=1:ns
        RSA(s,a)=sum(P(s,:,a)*R(s,a));
    end
end


%Compute, for every original state s, w(s)
ws=zeros(1,ns);
for i=1:K % for all k starting states
    % find the number of ground states represented by i
    [row{i},col,val]=find(SK(:,2)==i); % states == k are in vector row
    ng(i)=length(row{i}); % number of ground states
    ws(row{i})=1/ng(i); %ws(distribution)
end

%Compute the new weighted abstract reward function
for a=1:na
    for i=1:K
        RK(i,a)=1/ng(i)*sum(RSA(row{i},a),1);
    end
end


%Compute the new weighted abstract transition function
for i=1:K
    for j=1:K % for all k s' states
        for a=1:na
            %sum over the s'
            Snext=row{j};
            S=row{i};
            aux=0;
            for x=1:length(S)
                for y=1:length(Snext)
                    aux=aux+P(S(x),Snext(y),a)*ws(S(x));
                end
            end
            PK(i,j,a)=aux;
        end
    end
end


