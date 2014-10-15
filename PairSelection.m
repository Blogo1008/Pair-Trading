function [SelectedInd] = PairSelection(CoMatx,Threshold)
%PairSelection Summary of this function goes here
%   Detailed explanation goes here
%   In 
%   CoMatx
%       
%   Out 
%   SelectedInd
%       
%%%%%%%%%

TriuCo = triu(CoMatx);
[A,B] =  find(TriuCo>Threshold & TriuCo~=1);
SelectedInd = [A,B];



