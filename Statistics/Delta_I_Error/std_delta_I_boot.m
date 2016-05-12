function [mean_deltaI, std_deltaI] = std_delta_I_boot(pred_I_boot_c,pred_I_boot_i,I_c,I_i,groupindex)
% This function read in bootstrapped bootstrapped control and  a specific ibuprofen data
% and calculate the average and standard deviation of the difference. Group
% index specify the bin number (1-5) of interest and return the mean and
% std value of delta I in the group.
% Input:
%
% Output:
%
    load('IpvsIa_control_oct_multi_boot_1000_result_shuffled_c','pred_I_boot_c_boot','pred_I_boot_i','I_c_boot','I_i')
    
    Iboot_c = I_c_boot;
    pred_I_boot_c2 = pred_I_boot_c_boot;
    
    numboot = size(pred_I_boot_c,1);
    
    %find the range of bins by original control laser current
    [~, ~ ,bin_range]=data_bin(I_c,5);
    bin_range_c = [0 bin_range];
    bin_range_c(6) = 200;
    
    %find the ibuprofen datapts in the bin according to control data
    bin_num_i = zeros(1,length(I_i));
    for ii = 1:5
         bin_num_i((I_i<=bin_range_c(ii+1) & I_i>bin_range_c(ii))) = ii;
    end
    pred_I_boot_i2 = [];
    Iboot_i = [];
    
    
%     %%resample the data 
%     templist_c = randi(length(I_c),numboot,length(I_c));
%     pred_I_boot_c2 = zeros(size(pred_I_boot_c,1),size(pred_I_boot_c,2));
%     Iboot_c = zeros(size(pred_I_boot_c,1),size(pred_I_boot_c,2));
%   
%     for ii = 1:numboot
%         %resample control data
%         pred_I_boot_c2(ii,:) = pred_I_boot_c(ii,templist_c(ii,:));
%         Iboot_c(ii,:) = I_c(templist_c(ii,:));
%     end
    

end