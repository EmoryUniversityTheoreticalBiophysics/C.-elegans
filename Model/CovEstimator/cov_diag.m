function [sigmaout]=cov_diag(deltav)
% This function estimate the covariance matrix by assuming off-diag term = 0
% Input:
%   deltav -- speed profile - ugt*factor1val or upt ( time x number of paused worms)
% Output:
%   sigmaout -- covariance matirx of speed (time x time)


    tempcov = cov(deltav');
    sigmaout = diag(diag(tempcov,0));

end 