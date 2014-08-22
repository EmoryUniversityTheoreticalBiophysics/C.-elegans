function [I0_best]=Func_fit_I0(I,S) 
% finding the best parameter I0 that controls the onset of "go" with the 
% increased laser power
% Input:
%   I -- laser powers, 1 x worms
%   S -- is the worm moving (S=0) or paused (S=1), 1 x worms
% Output:
%   I0_best -- the optimal value of I0
%
%(c) George Leung and Ilya Nemenman

%verified 06/12/14

    opts = optimset('UseParallel','always');
    [I0_best] = fminsearch(@(I0)Func_I0(I0,I,S),10,opts);
 
end