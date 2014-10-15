function [ positions,pnl,action ] = backtestEx( p,spread,beta,lambda )
%InSampleTest4StdPrice Summary of this function goes here
%   Detailed explanation goes here
%   In 
%   p,spread,beta,lambda
%       
%   Out 
%   positions,pnl,action 
%       
%%%%%%%%%
for i=1:length(p)
    if i>1
        pnl(i)=(exp(p(i,1))-exp(p(i-1,1)))*positions(i-1,1)...
                +(exp(p(i,2))-exp(p(i-1,2)))*positions(i-1,2);
        positions(i,1)=positions(i-1,1);
        positions(i,2)=positions(i-1,2);
    end
    if i==length(p)
        if currentposition==1
            action(i,2)=1;
        end
        if currentposition==-1
            action(i,1)=1;
        end
        currentposition=0;
        positions(i,1)=0;
        positions(i,2)=0;
    end
    if spread(i)>upperlimit & currentposition==0
        action(i,2)=1;
        currentposition=-1;
        positions(i,1)=-1;
        positions(i,2)=beta;
        continue;
    end
    if spread(i)<lowerlimit & currentposition==0
        action(i,1)=1;
        currentposition=1;
        positions(i,1)=1;
        positions(i,2)=-beta;
        continue;
    end
    if spread(i)<mean(spread) & currentposition==-1
        action(i,1)=1;
        currentposition=0;
        positions(i,1)=0;
        positions(i,2)=0;
        continue;        
    end
    if spread(i)>mean(spread) & currentposition==1
        action(i,2)=1;
        currentposition=0;
        positions(i,1)=0;
        positions(i,2)=0;
        continue;        
    end
end

