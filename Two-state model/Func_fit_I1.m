
function [I1, fval]=Func_fit_I1(speed_go,I_go,factor1,init_val) 
% This function fits parameters of the model to the data
% Input:
%   speed_go -- velocity data of go worms to be used (times x worms); 
%       note that at this point the time slices not used in the 
%       optimization and all the paused worms must have
%       already been removed (time x Nworms)
%   I_go -- laser power for the go worms (1 x Nworms)
%   factor1 -- the model that should collapse the data
%   init_val -- initial values of the parameters for the optimization
% Output:
%   I1 -- best fitted parameter values I1 for the model
%   fval -- the minimized function value
%
%(c) George Leung and Ilya Nemenman

% Verified 06/12/2014


% setting optimization parameters
opts2 = optimset('UseParallel','always');



% finding the best parameter values 
[I1,fval] = fminsearch(@(I1)Prob_calc_go(I1,I_go,speed_go,factor1),init_val,opts2);
end