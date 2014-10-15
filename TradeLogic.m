function [ spositions,spnl,saction,currentposition ]= TradeLogic( i,p,spread,beta,UpLimt,LowLimt,positions,currentposition,action ,pnl)
%InSampleTest4StdPrice Summary of this function goes here
%   Detailed explanation goes here
%   In 
%   p,spread,beta,lambda
%       
%   Out 
%   positions,pnl,action 
%       
%%%%%%%%%
positions=zeros(length(p),2);%持仓
spnl=zeros(length(p),1);%每日损益
action=zeros(length(p),2);%买卖操作
action=action*NaN;
    
    if i>1
        pnl(i)=(exp(p(i,1))-exp(p(i-1,1)))*positions(i-1,1)...
                +(exp(p(i,2))-exp(p(i-1,2)))*positions(i-1,2);
        positions(i,1)=positions(i-1,1);
        positions(i,2)=positions(i-1,2);
        spositions = positions;
        spnl = pnl;

    end
    if i==length(p)
        if currentposition==1
            action(1,2)=1;
        end
        if currentposition==-1
            action(i,1)=1;
        end
        currentposition=0;
        positions(i,1)=0;
        positions(i,2)=0;
        spositions = positions;
        saction = action;
        spnl = pnl; 
    end
    if spread(i)>UpLimt & currentposition==0
        action(i,2)=1;
        currentposition=-1;
        positions(i,1)=-1;
        positions(i,2)=beta;
        spositions = positions;
        saction = action;
        spnl = pnl; 
        return;
    end
    if spread(i)<LowLimt & currentposition==0
        action(i,1)=1;
        currentposition=1;
        positions(i,1)=1;
        positions(i,2)=-beta;
        spositions = positions;
        saction =action;
        spnl = pnl;
        return;
    end
    if spread(i)<mean(spread) & currentposition==-1
        action(i,1)=1;
        currentposition=0;
        positions(i,1)=0;
        positions(i,2)=0;
        spositions = positions;
        saction =action;
        spnl = pnl;        
        return;        
    end
    if spread(i)>mean(spread) & currentposition==1
        action(i,2)=1;
        currentposition=0;
        positions(i,1)=0;
        positions(i,2)=0;
        spositions = positions;
        saction =action;
        spnl = pnl;        
        return;        
    end