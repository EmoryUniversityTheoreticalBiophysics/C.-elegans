%%Base on Zscore_Jan14

function [std_Ipred_diff_meanofbin,mean_Ipred_diff_meanofbin,Ipred_diff_meanofbin] = std_Idiff_Jan14(pred_I_boot_c2,pred_I_boot_i,Iboot_c,I_i,I_c)
%     clear all
%     load('IpvsIa_control_oct_multi_boot_1000_result_shuffled_c','pred_I_boot_c2','pred_I_boot_i','Iboot_c','I_i','I_c')
%     
    numboot = size(pred_I_boot_c2,1);
    
    
    for groupindex = 1:5;
    
    
    %find the range of bins by original control laser current
    [~, ~ ,bin_range]=data_bin(I_c,5);
    bin_range_c = [0 bin_range];
    bin_range_c(6) = 200;
    
    %find the bin index of control data according to original control bin
    %range
    I_c_size = length(I_c);
    bin_num_c = zeros(numboot,length(I_c));
    for ii = 1:numboot
        for kk = 1:5
             bin_num_c(ii,(Iboot_c(ii,:)<=bin_range_c(kk+1) & Iboot_c(ii,:)>bin_range_c(kk))) = kk;
        end
    end
    
    %find the ibuprofen datapts in the bin according to control data
    I_i_size = length(I_i);
    bin_num_i = zeros(1,length(I_i));
    for ii = 1:5
         bin_num_i((I_i<=bin_range_c(ii+1) & I_i>bin_range_c(ii))) = ii;
    end
    
    
    %select ibu data in the bin acrroding to bin_index_i
    bin_index_i = find(bin_num_i==groupindex);
    pred_I_boot_i_bin = pred_I_boot_i(:,bin_index_i);
    I_i_bin = I_i(bin_index_i);
    I_i_bin = ones(numboot,1)*I_i_bin;
    
    binlength_i = sum(bin_num_i==groupindex); %no of ibu data in the bin
    
%     %%resample the control data 
%     templist_c = randi(length(I_c),numboot,length(I_c));
%     pred_I_boot_c2 = zeros(size(pred_I_boot_c,1),size(pred_I_boot_c,2));
%     Iboot_c = zeros(size(pred_I_boot_c,1),size(pred_I_boot_c,2));
%   
%     for ii = 1:numboot
%         %resample control data
%         pred_I_boot_c2(ii,:) = pred_I_boot_c(ii,templist_c(ii,:));
%         Iboot_c(ii,:) = I_c(templist_c(ii,:));
%     end
   
         
    %generate undersample index for current length
    templist_i = randi(binlength_i,numboot,binlength_i);
         
 
         for m = 1:numboot
             %%resample the ibuprofen data in the bin
             I_i_bin_tempboot =  I_i_bin(m,templist_i(m,:));
             pred_I_i_bin_tempboot =  pred_I_boot_i_bin(m,templist_i(m,:));
             
             %get the control data 
             bin_index_c_tempboot = bin_num_c(m,:);
             pred_I_c_tempboot = pred_I_boot_c2(m,:);
             I_c_tempboot = Iboot_c(m,:);
             
             [~,mean_Ipred_diff_temp,~] = delta_I_diff(pred_I_i_bin_tempboot,pred_I_c_tempboot,I_i_bin_tempboot,I_c_tempboot,bin_index_c_tempboot);
       
             Ipred_diff_meanofbin(groupindex,m) = mean_Ipred_diff_temp(groupindex);
         end
         
         std_Ipred_diff_meanofbin(groupindex) = std(Ipred_diff_meanofbin(groupindex,:));
         mean_Ipred_diff_meanofbin(groupindex) = mean(Ipred_diff_meanofbin(groupindex,:));
    end
end
    