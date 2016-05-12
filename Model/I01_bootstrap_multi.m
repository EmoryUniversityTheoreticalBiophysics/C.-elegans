

function [p_all,I0,I1,ugt,sigmagt,upt,sigmapt,likelihood] = I01_bootstrap_multi(model_I,model_S,model_speed,upt,sigmapt,pred_I_range,pred_speed,factor1,init_val,pscale)
% This function read in speed profile, laser power from data fname,
% calculate optimal parameters I0 and I1 for the model and calcualte the
% probability distribution of laser pwoer given the model and speed
% profile. The model is based on multivariate gaussian distribution.
% No probabilities are caluclated.

% Input:
%  model_I -- laser power of the worms (1 x worms)
%  pred_I_range -- minimum and maximum range of the current used in experiments
%  model_S -- boolean index representing go or paused worms. Pause = 1 and go = 0. (1 x worms)
%  model_speed -- speed profile of the worm for calculation of model (time x worms)
%  pred_speed -- speed profile of the worm for prediction. Equal to model_speed if input argument equals to []. (time x pred_nworms)
%  pscale -- rescaling factor of go worms
%  init_val -- initial value for I1 optimization 

% Output:
%  I0 and I1 -- parameters of the model
%  ugt -- average of the go worm speed (1 x time)
%  sigmagt -- variance of the go worm speed (1 x time)
%  upt -- average of the paused worm speed (1 x time)
%  sigmapt -- variance of the paused worm speed (1 x time)
% (c) George Laung and Ilya Nemenman
    
    % setting the initial value if input argument is empty ([])
    if ~isempty('init_val')
         init_val = [40,40];                        % initial value for the optimization
    end
    
    % setting pred_speed equal to model_speed if input argument is empty ([])
    if isempty(pred_speed)
         pred_speed = model_speed;                        % initial value for the optimization
    end
     
    pred_nworms = size(pred_speed,2);                   % number of different worms in the data set 
    model_speed_go = model_speed(:,~model_S);                 %  velocity for go worms only
    model_I_go = model_I(~model_S);                           % laser power for go worms only
           
    

    
    % fitting I1 and I0 for the go worms 
    I0 = Func_fit_I0(model_I,model_S) ;
    [I1 fvals] = Func_fit_I1_multi(model_speed_go,model_I_go,factor1,init_val);
    
    predIval = pred_I_range(1):pred_I_range(2);
    p_all = zeros(length(predIval),pred_nworms);
    % define the range of predicted I; this should be the same as the range
    % of I used in the experiments
   
    %calculate the average and variance of the go worm speed profile
    [ugt,sigmagt]=calc_go_profile_multi(model_I_go,model_speed_go,factor1,I1);
    
        %calculate the prior distribution P(I)
    range_I  = pred_I_range(2)-pred_I_range(1)+1;
    [~ ,phi ,~] = bcsn(model_I,range_I,[],range_I);
    p_I = exp(-phi)/range_I;
    
    for i=1:pred_nworms
        % calculate the likelihood of the I in the range predI 
        % that could have caused the response velocity speed given the 
        % model defined by the rescaling function, I0, I1,  and average and variance of the worm speed profile
        p_v_given_I = prob_I_givenspeed_multi(predIval,pred_speed(:,i),sigmagt,ugt,sigmapt,upt,I0,I1,factor1,pscale); 
        likelihood(i) = p_v_given_I(round(model_I(i)-4));
        p_I_given_v = p_v_given_I.*p_I;
%         p_I_given_v = p_v_given_I;
        p_I_given_v = p_I_given_v./sum(p_I_given_v); %Normalize the probability distribution
        p_all(:,i) = p_I_given_v';
    end


    
end