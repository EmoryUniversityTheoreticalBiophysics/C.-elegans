
function [p_all_boot] = Model_prediction_bootstrap_multi(pred_I,pred_speed,model_name,pred_I_range)
% This function read in the bootstrapped model data and generate predicted
% laser power according to speed input.
%Input:
%  I -- laser power of the worms. Read from file fname if input argument equals to []. (1 x Nworms)
%  speed -- speed profile of the worm for calculation of model (time x worms)
%  model_name -- name of the file of the bootstrapped model

%Output:
% (c) George Laung and Ilya Nemenman

%load the model from model_name
load(model_name);


% anonymous function defining the rescaling model
factor1 = @(I,I1) I1(1)+((I)./(1+(I/I1(2)))); 

% the hack to deal with corelations in the data; should be about equal
% to the data correlation time
pscale = 1;

numboot = size(ugt_full,1); %size of bootstrap
predIval = pred_I_range(1):pred_I_range(2);
pred_nworms = size(pred_speed,2);                   % number of different worms in the data set 


%calculate the prior distribution P(I)
range_I  = pred_I_range(2)-pred_I_range(1)+1;
[~ ,phi ,~] = bcsn(pred_I,range_I,[],range_I);
p_I = exp(-phi)/range_I;
    

        
for k = 1:numboot %number of bootstraping
    predp_all = zeros(length(predIval),pred_nworms);
    for i=1:pred_nworms
        
        % calculate the likelihood of the I in the range predI 
        % that could have caused the response velocity speed given the 
        % model defined by the rescaling function, I0, I1,  and average and variance of the worm speed profile
        p_v_given_I = prob_I_givenspeed_multi(predIval,pred_speed(:,i),sigmagt_full{k},ugt_full(k,:),sigmapt_full{k},upt_full(k,:),I0(k),I1(k,:),factor1,pscale); 
        p_I_given_v = p_v_given_I.*p_I;
        %         p_I_given_v = p_v_given_I;
        p_I_given_v = p_I_given_v./sum(p_I_given_v); %Normalize the probability distribution
        predp_all(:,i) = p_I_given_v';
    end
    k
    p_all_boot{k} = predp_all;
end

end

    
