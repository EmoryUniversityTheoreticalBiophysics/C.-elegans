function [upt,sigmapt]=calc_pause_profile_multi(speed_p)
% This function calculate the average and variance of speed profile  for go
% worms. For multivariate gaussian model.
% Input:
%   speed_p -- speed profile of paused worms ( time x number of paused worms)
% Output:
%   sigmapt -- variance of the paused worm speed profile (time x time)
%   upt -- speed profile template of paused worms (1 xtime)

    sigmapt= cov_estimate(speed_p);
    upt = mean(speed_p,2);
end 