function [sigmaout]=autocov2(deltav)
% This function calculate the covariance matrix by assuming translational
% invariance. Method 2.
% Input:
%   deltav -- speed profile - ugt*factor1val or upt ( time x number of paused worms)
% Output:
%   sigmaout -- covariance matirx of speed (time x time)
    timelen = size(deltav,1);
    wormlen = size(deltav,2);



%%%Method 3

    tempcov = cov(deltav');
    sigmatril = zeros(timelen,timelen); 
    sigmaout = zeros(timelen,timelen); 
    for i = 1:timelen
        sigmatril(i:timelen+1:end) = mean(diag(tempcov,i-1));
    end
    
    %create the cov matrix by sum of transpose of lower triangle and itself
    sigmaout = tril(sigmatril)' + tril(sigmatril,-1);
%%%%%%%%%%%%


% %%%Method 4 - diag term not averaged
% 
%     tempcov = cov(deltav');
%     sigmatril = zeros(timelen,timelen); 
%     sigmaout = zeros(timelen,timelen); 
%     for i = 2:timelen
%         sigmatril(i:timelen+1:end) = mean(diag(tempcov,i-1));
%     end
%     
%     diagterm = diag(diag(tempcov,0));
%     %create the cov matrix by sum of transpose of lower triangle and itself
%     sigmaout = tril(sigmatril)' + tril(sigmatril,-1)+ diagterm;
% %%%%%%%%%%%%

end 