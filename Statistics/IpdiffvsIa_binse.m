function [Ipred_diff_mean,Ipred_diff_mean_bin,bin_se]=IpdiffvsIa_binse(Ipred_diff,I_data,nbins)
% This function calculates the mean and errorbar of binned Ip vs Ia difference
% Input:
%   Ipred_diff: the bootstrapped difference between predicted I of the data

    Ipred_diff_mean = mean(Ipred_diff,1); %average difference 
    

    [bin_num,~,~]=data_bin(I_data, nbins);
    var_boot = var(Ipred_diff,1);
    for i = 1:nbins
        bin_numdata(i) = sum(bin_num==i);
        bin_se(i) = sqrt(mean(var_boot(bin_num==i)) +  var(Ipred_diff_mean(bin_num==i)))/sqrt(bin_numdata(i));  %standard error in the bin  
        Ipred_diff_mean_bin(i) = mean(Ipred_diff_mean(bin_num==i))'; 
    end

end