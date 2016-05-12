%%bootstrap_fix
%%find Ipdiff

%%%%%%%%%%%%%%
%%%%Resample  dataset without fixing number in each
%%%%bin
%%%%%%%%%%%%%%
clear all
load('IpvsIa_control_oct_multi_boot_1000_result')

numboot = 1000;
templist_c = randi(length(I_c),numboot,length(I_c));
templist_i = randi(length(I_i),numboot,length(I_i));
templist_m = randi(length(I_m),numboot,length(I_m));


%%resample the data 
pred_I_boot_i2 = zeros(size(pred_I_boot_i,1),size(pred_I_boot_i,2));
pred_I_boot_c2 = zeros(size(pred_I_boot_c,1),size(pred_I_boot_c,2));
pred_I_boot_m2 = zeros(size(pred_I_boot_m,1),size(pred_I_boot_m,2));
for ii = 1:numboot
    pred_I_boot_c2(ii,:) = pred_I_boot_c(ii,templist_c(ii,:));
    pred_I_boot_i2(ii,:) = pred_I_boot_i(ii,templist_i(ii,:));
    pred_I_boot_m2(ii,:) = pred_I_boot_m(ii,templist_m(ii,:)); 
    Iboot_c(ii,:) = I_c(templist_c(ii,:));
	Iboot_i(ii,:) = I_i(templist_i(ii,:));
	Iboot_m(ii,:) = I_m(templist_m(ii,:));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute I diff SE using control as ref point
% Find the difference of pred I by finding the closest ibuprofen/mutant
% datapoint for each control datapoint in terms of actual I
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%find the range of bins by original control laser current
[bin_num, meanI ,bin_range]=data_bin(I_c,5);


 nei_list_i = zeros(numboot,size(I_c,2));
 nei_list_m = zeros(numboot,size(I_c,2));
 nei_val_i = zeros(numboot,size(I_c,2));
 nei_val_m = zeros(numboot,size(I_c,2));
 
for kk = 1:numboot
    
    I_c_temp = Iboot_c(kk,:);
    I_i_temp = Iboot_i(kk,:);
    I_m_temp = Iboot_m(kk,:);
    
    % Find the data point in ibuprofen with closest laser power with the data
    % points in control
    % Create a mapping list from data to model 
    for i = 1:size(I_c_temp,2)
        templist = abs(I_c_temp(i)-I_i_temp);
        temppos = find(templist==min(templist));
        nei_list_i(kk,i) = temppos(1);    %list of datapoints in I_i_temp that is closest to I_c
    end
    nei_val_i(kk,:) = I_i_temp(nei_list_i(kk,:));
    

    % Find the data point in mutant with closest laser power with the data
    % points in control
    % Create a mapping list from data to model 
    for i = 1:size(I_c_temp,2)
        templist = abs(I_c_temp(i)-I_m_temp);
        temppos = find(templist==min(templist));
        nei_list_m(kk,i) = temppos(1);    %list of datapoints in I_m_temp that is closest to I_c_temp
    end
    nei_val_m(kk,:) = I_m_temp(nei_list_m(kk,:));
end

%%Statistics
actIdiff_i = abs(Iboot_c - nei_val_i);
actIdiff_m = abs(Iboot_c - nei_val_m);
actIdiff_i = actIdiff_i(:);
actIdiff_m = actIdiff_m(:);

%Compute difference of laser power in each bootstrap
pred_I_i_nei= zeros(numboot,size(I_c,2));
pred_I_m_nei= zeros(numboot,size(I_c,2));
for kk = 1:numboot
    pred_I_i_nei(kk,:) = pred_I_boot_i2(kk,nei_list_i(kk,:));
    Ipred_diff_i = pred_I_boot_c2 - pred_I_i_nei;
    pred_I_m_nei(kk,:) = pred_I_boot_m2(kk,nei_list_m(kk,:));
    Ipred_diff_m = pred_I_boot_c2 - pred_I_m_nei;
end

%Binning the results
Iboot_c_binindex = zeros(size(Iboot_c,1),size(Iboot_c,2));
bin_range_temp = [0 bin_range];
for kk = 1:numboot
    for ii = 1:5
        tempindex = find(Iboot_c(kk,:)<=bin_range_temp(ii+1)&Iboot_c(kk,:)>bin_range_temp(ii));
        Iboot_c_binindex(kk,tempindex) = ii;
        
    %calcualte the mean difference in each bin in each bootstrapped sample
        Ipred_diff_boot_i_bin(kk,ii) = mean(Ipred_diff_i(kk,tempindex));
        Ipred_diff_boot_m_bin(kk,ii) = mean(Ipred_diff_m(kk,tempindex));
    end
    
end

std_Idiff_i_bin = std(Ipred_diff_boot_i_bin,1);
std_Idiff_m_bin = std(Ipred_diff_boot_m_bin,1);


save bootstrap_resam_all std_Idiff_i_bin std_Idiff_m_bin
