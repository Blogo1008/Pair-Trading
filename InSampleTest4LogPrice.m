function [Ret, positions,netvalue,pnl,action,OptLambda] = InSampleTest4LogPrice(p,Step,Start,End,SI)
%InSampleTest4LogPrice Summary of this function goes here
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
temp = p(:,SI(1,1));


plot(xplot,p(:,SI(1,1)),xplot,p(:,SI(1,2)) );
legend('CIB','CMB');
X=[ones(length(p),1) p(:,SI(2))];
[b,se_b,mse,S] = lscov(X,p(:,SI(1)));
res=p(:,SI(1))-b(1)-p(:,SI(2))*b(2);
h=adftest(res);
if h==1
    disp('CIB and CMB are cointegrated');
    spread=p(:,SI(1))-p(:,SI(2))*b(2);
    figure(2);
    title('Spread of Log Price');
    plot(xplot,res);
    [ positions,pnl,action,OptLambda] = LinearSearch(p(:,SI),spread,b(2),Step,Start,End); 
%    [ postions,pnl,action ] = backtest( p,spread,b(2),1 );
    figure(2);
    hold on
    plot(xplot,action(:,1).*res,'r^');
    plot(xplot,action(:,2).*res,'gv');
    hold off
    cost=(exp(p(1,SI(1)))+exp(p(1,SI(2))))/2
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