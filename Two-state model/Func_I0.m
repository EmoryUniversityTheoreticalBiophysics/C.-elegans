function [nprob]=Func_I0(I0,I,S) 
% Outputs the likelihood of the data (go/stop worms assignment) given the
% model of the stop-go transition.
% Input:
%   I -- laser power, 1 x worms
%   S -- stop (1) / go (0) assignment, 1 x worms
% Output:
%   nprob -- negative likelihood of the data
% The model used is that P(go) = 1/(1+ (I/I0)^2)
%
%(c) George Leung and Ilya Nemenman

% verified 06/12/14

    power = 2;      % parameter of the model
    
    x=(I/I0).^power; % rescaled laser power
    nprob = -prod (S./(1+x)+(1-S).*x./(1+x));
  end