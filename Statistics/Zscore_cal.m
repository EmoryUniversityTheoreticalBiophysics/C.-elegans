%%This function calculate Z-score of the Delta I

%%%%%%%%%%%%%%
%%%%This function fix the number of control data points and reduce the
%%%%number of ibu/mutant data points. Then new pairs is genereated to
%%%%calculate delta I. Z-score is then calculated with different number of
%%%%ibu/mutant data points.
%Input:
%   groupindex -- index of the laser current bin group (1,2,3,4 or 5) from
%                 control dataset
%   bootflag -- 1: sample with reduced number of ibu /mutant dataset. 0:
%               sample with original number of ibu /mutant dataset.

%%%%%%%%%%%%%%
function [Zscore_i,Ipred_diff_se_bin_i] = Zscore_cal(Ipred_diff_mean,pred_I_boot_c,pred_I_boot_i,I_c,I_i,groupindex,bootflag)
% 
%     load('IpvsIa_control_oct_multi_boot_1000_result','pred_I_boot_c','pred_I_boot_i','I_c','I_i')

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

    %resample control data
    %%resample the data 
    templist_c = randi(length(I_c),numboot,length(I_c));
    pred_I_boot_c2 = zeros(size(pred_I_boot_c,1),size(pred_I_boot_c,2));
    Iboot_c = zeros(size(pred_I_boot_c,1),size(pred_I_boot_c,2));
    for ii = 1:numboot
        pred_I_boot_c2(ii,:) = pred_I_boot_c(ii,templist_c(ii,:));
        Iboot_c(ii,:) = I_c(templist_c(ii,:));
    end

    %First method: undersample without replacement
    %undersample without replacement
    %%resample the ibu data only for group 4
    %divide the ibuprofe  data by control bin
    bin_num_suffle_i = find(bin_num_i==groupindex);
    % bin_num_suffle_i = bin_num_suffle_i(randperm(sum(bin_num_i==groupindex)));
    
    if bootflag == 1
        for datalength = 1:size(bin_num_suffle_i,2)

            %undersample without replacement
            bin_index_i = bin_num_suffle_i(1:datalength);

            %select ibu data acrroding to bin_index_i
            pred_I_boot_i2 = pred_I_boot_i(:,bin_index_i);
            Iboot_i = I_i(bin_index_i);
            Iboot_i = ones(numboot,1)*Iboot_i;

            %%calculate Z-score
            [Ipred_diff_mean_bin_i2,Ipred_diff_se_bin_i2,actIdiff_i,Ipred_diff_i2] = IpdiffvsIa_se_fixcontrol(Iboot_i,Iboot_c,pred_I_boot_i2,pred_I_boot_c2,bin_range_c);

            Zscore_i(datalength) = Ipred_diff_mean/Ipred_diff_se_bin_i2(groupindex);
            Ipred_diff_se_bin_i = Ipred_diff_se_bin_i2(groupindex);
        end
    else
            %NO undersample
            bin_index_i = bin_num_suffle_i;

            %select ibu data acrroding to bin_index_i
            pred_I_boot_i2 = pred_I_boot_i(:,bin_index_i);
            Iboot_i = I_i(bin_index_i);
            Iboot_i = ones(numboot,1)*Iboot_i;

            %%calculate Z-score
            [Ipred_diff_mean_bin_i2,Ipred_diff_se_bin_i2,actIdiff_i,Ipred_diff_i2] = IpdiffvsIa_se_fixcontrol(Iboot_i,Iboot_c,pred_I_boot_i2,pred_I_boot_c2,bin_range_c);
        
            Zscore_i = Ipred_diff_mean/Ipred_diff_se_bin_i2(groupindex);
            Ipred_diff_se_bin_i = Ipred_diff_se_bin_i2(groupindex);
    end
end

% Ipred_diff_mean = 25.9170



% %Second method: undersample without replacement
% %undersample without replacement
% %%resample the ibu data only for group 4
% %divide the ibuprofe  data by control bin
% bin_num_suffle_i = find(bin_num_i==groupindex);
% 
% 
% samplesize = 100;
% sampleno = 20;
% Zscore_i2 = zeros(samplesize,size(bin_num_suffle_i,2));
% for jj = 1:sampleno
%     
%     datalength = round(jj*size(bin_num_suffle_i,2)/sampleno);
%     
%     datasize_i(jj) = datalength;
%     
%     for ii = 1:samplesize
% 
%         %undersample without replacement
%         bin_num_suffle_i2 = bin_num_suffle_i(randperm(sum(bin_num_i==groupindex)));
%         bin_index_i = bin_num_suffle_i2(1:datalength);
% 
%         %select ibu data acrroding to bin_index_i
%         pred_I_boot_i2 = pred_I_boot_i(:,bin_index_i);
%         Iboot_i = I_i(bin_index_i);
%         Iboot_i = ones(numboot,1)*Iboot_i;
%         %%calculate Z-score
%         [Ipred_diff_mean_bin_i2,Ipred_diff_se_bin_i2,actIdiff_i,Ipred_diff_i2] = IpdiffvsIa_se_fixcontrol(Iboot_i,Iboot_c,pred_I_boot_i2,pred_I_boot_c2,bin_range_c);
%         Zscore_i2(ii,datalength) = 25.9170/Ipred_diff_se_bin_i2(groupindex);
%     end
%     jj
% end



