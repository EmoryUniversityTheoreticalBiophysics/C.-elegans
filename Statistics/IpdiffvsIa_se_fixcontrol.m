function [Ipred_diff_mean_bin_i,Ipred_diff_std_of_mean,actIdiff_i,Ipred_diff_i] = IpdiffvsIa_se_fixcontrol(Iboot_i,Iboot_c,pred_I_boot_i2,pred_I_boot_c2,bin_range)

%%%%%%%%%%%%%%
%%%%This function fix the number of control data points and reduce the
%%%%number of ibu/mutant data points. Then new pairs is genereated to
%%%%calculate delta I. Z-score is then calculated with different number of
%%%%ibu/mutant data points.
%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute I diff SE using control as ref point
% Find the difference of pred I by finding the closest ibuprofen/mutant
% datapoint for each control datapoint in terms of actual I
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Compute neighbour list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numboot = size(Iboot_c,1);
nei_list_i = zeros(numboot,size(Iboot_c,2));
nei_val_i = zeros(numboot,size(Iboot_c,2));
 
for kk = 1:numboot
    
    I_c_temp = Iboot_c(kk,:);
    I_i_temp = Iboot_i(kk,:);
    
    % Find the data point in ibuprofen with closest laser power with the data
    % points in control
    % Create a mapping list from data to model 
    for i = 1:size(I_c_temp,2)
        templist = abs(I_c_temp(i)-I_i_temp);
        temppos = find(templist==min(templist));
        nei_list_i(kk,i) = temppos(1);    %list of datapoints in I_i_temp that is closest to I_c
    end
    nei_val_i(kk,:) = I_i_temp(nei_list_i(kk,:));
end

%%Statistics
actIdiff_i = abs(Iboot_c - nei_val_i);
actIdiff_i = actIdiff_i(:);


%Compute difference of laser power in each bootstrap
pred_I_i_nei= zeros(numboot,size(Iboot_c,2));
for kk = 1:numboot
    pred_I_i_nei(kk,:) = pred_I_boot_i2(kk,nei_list_i(kk,:));
    Ipred_diff_i = pred_I_boot_c2 - pred_I_i_nei;
end

%Binning the results
Iboot_c_binindex = zeros(size(Iboot_c,1),size(Iboot_c,2));
Ipred_diff_boot_i_bin = zeros(size(Iboot_c,1),5);
for kk = 1:numboot
    for ii = 1:5
        tempindex = find(Iboot_c(kk,:)<=bin_range(ii+1)&Iboot_c(kk,:)>bin_range(ii));
        Iboot_c_binindex(kk,tempindex) = ii;
        
        %calcualte the mean difference in each bin in each bootstrapped sample
        Ipred_diff_boot_i_bin(kk,ii) = mean(Ipred_diff_i(kk,tempindex));
    end
    
end

Ipred_diff_std_of_mean = std(Ipred_diff_boot_i_bin,1);
Ipred_diff_mean_bin_i = mean(Ipred_diff_boot_i_bin,1);


end