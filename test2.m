p=csvread('shareprice.csv',1,1);
p=p(251:500,:);   %getting close price from day 251-day 500
p=log(p);
xplot=[1:length(p)];
figure(1);
title('CIB and CMB stock price');
plot(xplot,p(:,1),xplot,p(:,2));
legend('CIB','CMB');
X=[ones(length(p),1) p(:,2)];
[b,se_b,mse,S] = lscov(X,p(:,1));
res=p(:,1)-b(1)-p(:,2)*b(2);
h=adftest(res);
if h==1
    disp('CIB and CMB are cointegrated');
    spread=p(:,1)-p(:,2)*b(2);
    figure(2);
    title('Spread of Log Price');
    plot(xplot,res);
    [ postions,pnl,action,OptLambda] = LinearSearch(p,spread,b(2),0.05,0.1,4); 
%    [ postions,pnl,action ] = backtest( p,spread,b(2),1 );
    figure(2);
    hold on
    plot(xplot,action(:,1).*res,'r^');
    plot(xplot,action(:,2).*res,'gv');
    hold off
    cost=(exp(p(1,1))+exp(p(1,2)))/2
    netvalue=ones(length(p),1);
    cumpnl=cumsum(pnl);
    cumpnl=cumpnl+cost;
    netvalue=cumpnl/cost;
    figure(3);
    title('Net Value');
    plot(xplot,netvalue);
    text=sprintf('Return=%f%%',(netvalue(end)-1)*100);
    disp(text);
else
    disp('CIB and CMB are not cointegrated');
end