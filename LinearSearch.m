function [ OptPositions,OptPnl,OptAction,OptLambda] = LinearSearch(p,spread,beta,Step,Start,End)
%LinearSearch Summary of this function goes here
%   Detailed explanation goes here
%   In 
%   p,spread,beta,Step,Start,End
%       
%   Out 
%   OptPositions,OptPnl,OptAction,OptLambda
%       
%%%%%%%%%
OptLambda = -1;
OptNV = 1;

for i=Start:Step:End
    [ positions,pnl,action ] = backtest( p,spread,beta,i);
    cost=(exp(p(1,1))+exp(p(1,2)))/2;
    netvalue=ones(length(p),1);
    cumpnl=cumsum(pnl);
    cumpnl=cumpnl+cost;
    netvalue=cumpnl/cost;
    NV =  netvalue(end);
    if(OptNV <  NV)
        OptLambda = i;
        OptPositions = positions;
        OptPnl = pnl; 
        OptAction = action;
        OptNV = netvalue(end);
    end
end

