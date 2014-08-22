function [upt,sigmapt]=calc_pause_profile(speed_p)
% This function calculate the average and variance of speed profile  for go worms.
% Input:
%   speed_p -- speed profile of paused worms ( time x number of paused worms)
% Output:
%   sigmapt -- variance of the paused worm speed profile (1 x time)
%   upt -- speed profile template of paused worms (1 xtime)

    sigmapt= std(speed_p,0,2);
    upt = mean(speed_p,2);
end 