function [sigmaout]=autocov(speed)
% This function calculate the covariance matrix by assuming translational
% invariance. 
% Input:
%   speed -- speed profile ( time x number of paused worms)
% Output:
%   sigmaout -- covariance matirx of speed (time x time)
    timelen = size(speed,1);
    wormlen = size(speed,2);


%%%%%%Method 1

    autocov_t = zeros(2*timelen-1,wormlen);
    for i = 1:wormlen
        autocov_t(:,i) = xcov(speed(:,i));
    end
    autocov_mean = mean(autocov_t,2);
    
    %create the lower triangle matrix of the cov matrix
    sigmatril = zeros(timelen,timelen); 
    for i = 1:timelen
        sigmatril(i:timelen+1:end) = autocov_mean(timelen+1-i);
    end
    
    %create the cov matrix by sum of transpose of lower triangle and itself
    sigmaout = tril(sigmatril)' + tril(sigmatril,-1);
    
%%%%%%%%%%%%

end 