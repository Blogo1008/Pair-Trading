function [ positions,pnl,action ] = backtest( p,spread,beta,lambda )
%BACKTEST Summary of this function goes here
%   Detailed explanation goes here
positions=zeros(length(p),2);%�ֲ�
pnl=zeros(length(p),1);%ÿ������
action=zeros(length(p),2);%��������
action=action*NaN;
upperlimit=mean(spread)+std(spread,1)*lambda;%�Ͻ�
lowerlimit=mean(spread)-std(spread,1)*lambda;%�½�
currentposition=0;%��ǰ�ֲ� 0-�ղ� 1-��� (-1)-�ղ�
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

