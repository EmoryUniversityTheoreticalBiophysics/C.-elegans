function [mlogP,mlogPlist,sigmagt]=Prob_calc_go_multi(I1,I_go,speed_go,factor1) 
% Function calculates the part of the probability of the data given the model
% for the data that involves the go worms only. For multivariate gaussian
% model.
% Input:
%   I1 -- parameters of the model (2 parameters)
%   I_go -- laser power of go worm (1 x Nworms)
%   speed_go -- worm velocity of go worms(times x wNorms)
%   factor1 -- anonymous function defining the rescaling model
% Output:
%   mlogP -- minus the log-probability of the go-worm trajectories; the terms like
%       sqrt(2pi) are neglected here, only the exponent of the probability
%       is returned
%
%(c) George Leung and Ilya Nemenman


%number of worms
Nworms=size(speed_go,2);

%calculate u(t), the rescaled velocity and std of it
[ugt,sigmagt,shrinkage]=calc_go_profile_multi(I_go,speed_go,factor1,I1);

factor1val = factor1(I_go,I1);  % the rescaling factor (1 x worms)

diff_vel= speed_go -ugt*factor1val;  % time x worms, difference between the actual velocity and the apropriately rescaled  template

logprob = logmvnpdf(diff_vel',0,sigmagt);
% if min(Prob) == 0
%      disp(['I1 =' num2str(I1)] );
%      error('Prob_go:zero', 'Some of the probability of go worms equals to zero')
% end

mlogP = -sum(logprob);

%Debug
mlogPlist = -logprob';

end

    
    
    
        