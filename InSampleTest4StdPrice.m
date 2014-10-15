function [Ret,  positions,netvalue,pnl,action,OptLambda] = InSampleTest4StdPrice(p,StdP,Step,Start,End,SI)
%InSampleTest4StdPrice Summary of this function goes here
%   Detailed explanation goes here
%   In 
%   p,spread,Step,Start,End
%       
%   Out 
%   postions,netvalue,pnl,action,OptLambda
%       
%%%%%%%%%

xplot=[1:length(p)];
figure(1);
title('CIB and CMB stock price');
plot(xplot,p(:,1),xplot,p(:,2));
legend('CIB','CMB');


StdDev = std(p);
Beta = StdDev(1,SI(1,1))/StdDev(1,SI(1,2));
res=StdP(:,SI(1,1))-StdP(:,SI(1,2));
h=adftest(res);
if h==1
    disp('CIB and CMB are cointegrated');
    spread=res;
    figure(2);
    title('Spread of Log Price');
    plot(xplot,res);
    [ positions,pnl,action,OptLambda] = LinearSearch(p(:,SI),spread,Beta,Step,Start,End); 
%    [ postions,pnl,action ] = backtest( p,spread,b(2),1 );
    figure(2);
    hold on
    plot(xplot,action(:,1).*res,'r^');
    plot(xplot,action(:,2).*res,'gv');
    hold off
    cost=(exp(p(1,SI(1,1)))+exp(p(1,SI(1,2))))/2
    netvalue=ones(length(p),1);
    cumpnl=cumsum(pnl);
    cumpnl=cumpnl+cost;
    netvalue=cumpnl/cost;
    figure(3);
    title('Net Value');
    plot(xplot,netvalue);
    Ret =(netvalue(end)-1)/length(p)*252;

else
    disp('CIB and CMB are not cointegrated');
end