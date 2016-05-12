function [Ipred_diff,mean_Ipred_diff,actIdiff] = delta_I_diff(pred_I_i,pred_I_c,act_I_i,act_I_c,bin_index_c)
% This function computes the delta I between control and ibu/mutant data
% using control as ref point. Binning is computed according to control
% dataset.
% Input:
%   pred_I_c : predicted value of control laser power
%   pred_I_i : predicted value of ibuprofen laser power
%   bin_index_c: index of the control bins 
% Output:
%   Ipred_diff : Delta I of each control data point
%   mean_Ipred_diff : mean delta I in each bin


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Compute neighbour list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    nei_list_i = zeros(1,length(act_I_c));
    
    % Find the data point in ibuprofen with closest laser power with the data
    % points in control
    % Create a mapping list from data to model 
    for i = 1:length(act_I_c)
        templist = abs(act_I_c(i)-act_I_i);
        temppos = find(templist==min(templist));
        nei_list_i(i) = temppos(1);    %list of datapoints in I_i_temp that is closest to I_c
    end
    nei_val_i = act_I_i(nei_list_i);

    %%Statistics
    actIdiff = abs(act_I_c - nei_val_i);
    actIdiff = actIdiff(:);

    pred_I_i_nei = pred_I_i(nei_list_i);
    Ipred_diff = pred_I_c - pred_I_i_nei;
    
    mean_Ipred_diff = zeros(1,5);
    for ii = 1:5
        %calcualte the mean difference in each bin 
        mean_Ipred_diff(ii) = mean(Ipred_diff(bin_index_c==ii));
    end
    
end