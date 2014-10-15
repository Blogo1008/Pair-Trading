function [Ret,  positions,netvalue,pnl,action,OptLambda] = OutSampleTest4StdPrice(p,StdP,Step,Start,End,Mid,SI)
%InSampleTest4StdPrice Summary of this function goes here
%   Detailed explanation goes here
%   In 
%   p,spread,Step,Start,End
%       
%   Out 
%   postions,netvalue,pnl,action,OptLambda
%       
%%%%%%%%%

xplot=[(Mid+1):length(p)];
figure(1);
title('CIB and CMB stock price');
plot(xplot,p(Mid+1:end,SI(1,1)),xplot,p(Mid+1:end,SI(1,2)));
legend('CIB','CMB');


StdDev = std(p(1:Mid,:));
Beta = StdDev(1,SI(1,1))/StdDev(1,SI(1,2));
res=StdP(:,SI(1,1))-StdP(:,SI(1,2));
h=adftest(res);
if h==1
    disp('CIB and CMB are cointegrated');
    spread=res;
    figure(2);
    title('Spread of Log Price');
    plot(xplot,res(Mid+1:end));
    [ positionspp,pnlpp,actionpp,OptLambda] = LinearSearch(p(1:Mid,SI),spread(1:Mid,:),Beta,Step,Start,End); 
    [ positions,pnl,action ] = backtest( p(1+Mid:end,SI),spread(1+Mid:end,:),Beta,OptLambda );
    figure(2);
    hold on
    plot(xplot,action(:,1).*res(Mid+1:end,1),'r^');
    plot(xplot,action(:,2).*res(Mid+1:end,1),'gv');
    hold off
    cost=(exp(p(1+Mid,SI(1,1)))+exp(p(1+Mid,SI(1,2))))/2
    netvalue=ones(length(p)-Mid,1);
    cumpnl=cumsum(pnl);
    cumpnl=cumpnl+cost;
    netvalue=cumpnl/cost;
    figure(3);
    title('Net Value');
    plot(xplot,netvalue);
    Ret =(netvalue(end)-1)/(length(p)-1)*252;

else
    disp('CIB and CMB are not cointegrated');
end