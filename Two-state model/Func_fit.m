
function [best_params, fval]=Func_fit(speed,I,S,factor1, init_val) 
% The function fits parameters of the model to the data
% Input:
%   speed -- velocity data to be used (times x worms); note that at this
%       point the time slices not used in the optimization must have
%       already been removed
%   I -- laser power (1 x worms)
%   S -- indeces of go/nogo worms; 0=go; 1=paused; (1 x worms)
%   factor1 -- the model that should collapse the data
%   init_val -- initial values of the parameters for the optimization
% Output:
%   best_params -- best fitted parameter values
%   fval -- the minimized function value

% selecting only the go worms
speed_input = speed(:,~S);
I_input = I(~S);

% setting optimization parameters
opts2 = optimset('UseParallel','always');

% finding the best parameter values 
[best_params,fval,~,~] = fminsearch(@(I1)Prob_calc_go(I1,I_input,speed_input,factor1),init_val,opts2);
end