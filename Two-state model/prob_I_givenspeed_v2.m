
function [Prob]=prob_I_givenspeed_v2(predI,speed,sigmagt,ugt,sigmapt,upt,I0,I1,factor1,pscale) 
% Calculate probability of the laer power I given the speed profile and
% model data.
% Version 2: simplified the calculation
% Input:
%   speed -- speed profile of the worm (time x nworms)
%   predI -- laser power for prediction (1 x N)
%   sigmagt -- variance of the go worm speed profile (1 x time)
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
    log_1= pscale*(sum(-((speed-upt).^2)./(2*(sigmapt.^2)))...
        -sum(log(sigmapt))-1/2*log(2*pi)*T)*ones(1,N);    
    first_term=exp(log_1).*factor0val;
    
    log_2= pscale*(sum(-1/2*(speed*ones(1,N)-ugt*factor1val).^2./...
        (sigmagt.^2*ones(1,N)),1)-sum(log(sigmagt))-1/2*log(2*pi)*T);
    second_term=exp(log_2).*(1-factor0val);
    
    
    
    if sum(second_term == 0) == 0 
        % If there are no round off error on second term
        Prob=first_term+second_term;
        Prob=Prob./sum(sort(Prob));
        
    else
        % If there are round off error on second term
        
        % This function calculates the difference between 1 and the sum of probability normalized by Z =
        % exp(logz) when probabilities are too small to be added directly without normalization.
        diffsumprob = @(logz) abs(1-sum((exp(log_1+logz).*factor0val)+(exp(log_2+logz).*(1-factor0val))));
        % setting optimization parameters
        opts2 = optimset('UseParallel','always');
        
        %Search for initial value of logz. When logz is too small, diffsumprob = 1.
        %When logz is too large, diffsumprob = Int.
        logzinit = 1;
        counter = 1;
        while diffsumprob(logzinit) == 1 
            logzinit = logzinit + 1;
            counter = counter+1;
            if counter == 10000
                error('Unable to normalize probability in prob_I_givenspeed_v2.')
            end
        end
        %Search for logz value that normalize the probability.
        [logzval,fval] = fminsearch(@(logz)diffsumprob(logz),logzinit,opts2);
        
        Prob = (exp(log_1+logzval).*factor0val) + (exp(log_2+logzval).*(1-factor0val));
    end
end
