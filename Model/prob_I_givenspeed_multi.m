
function [Prob]=prob_I_givenspeed_multi(predI,speed,sigmagt,ugt,sigmapt,upt,I0,I1,factor1,pscale) 
% Calculate probability of the laer power I given the speed profile and
% model data. For multivariate gaussian model.
% Version 2: simplified the calculation
% Input:
%   speed -- speed profile of the worm (time x nworms)
%   predI -- laser power for prediction (1 x N)
%   sigmagt -- variance of the go worm speed profile (time x time)
%   ugt -- speed profile template of go worms (1 xtime)
%   sigmapt -- variance of the paused worm speed profile (1 x time)
%   upt -- speed profile template of paused worms (1 xtime)
%   I0 -- parameters of the model (stop/go transition)
%   I1 -- parameters of the model (go velocity rescaling)
%   factor1 -- anonymous function defining the rescaling model for the go worms
%   pscale -- scaling factor
% 
% Output:
%   Prob -- Probbability of speed given I (1 x N)\
    
    factor1val = factor1(predI,I1); % go velocity rescaling
    factor0val = (1./(1+((predI/I0).^2))); %pause probability
    
    
    N=length(predI);
    T=size(speed,1);
    
    %   Correct the dimension of the data
    if size(ugt,2) > 1
        ugt = ugt';
    end
    if size(sigmagt,2) > 1
        sigmagt = sigmagt';
    end
    if size(upt,2) > 1
        upt = upt';
    end
    if size(sigmapt,2) > 1
        sigmapt = sigmapt';
    end
    
    
    Prob=zeros(size(predI));
    Prob_1 = mvnpdf(speed',upt',sigmapt)*ones(size(predI,2),1);
    first_term=Prob_1.*factor0val';
    
    Prob_2 = mvnpdf((speed*ones(1,size(factor1val,2)))',(ugt*factor1val)',sigmagt);
    second_term=Prob_2.*(1-factor0val)';
    
    
    Prob=first_term+second_term;
    Prob=Prob./sum(sort(Prob));
    
%     if sum(Prob_1 == 0) > 0 
%         error('Prob_1:zero', 'Probability of first term equals to zero')
%     end
%     if sum(Prob_2 == 0) > 0 
%         error('Prob_2o:zero', 'Probability of second term equals to zero')
%     end
%     if sum(Prob == 0) > 0 
%         error('Prob:zero', 'Probability equals to zero')
%     end
end
