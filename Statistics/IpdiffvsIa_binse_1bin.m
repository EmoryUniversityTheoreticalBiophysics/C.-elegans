function [Ipred_diff_mean_bin,Ipred_diff_se_bin] = IpdiffvsIa_binse_1bin(Ipred_diff)

    
    Ipred_diff_mean = mean(Ipred_diff,1);
    Ipred_diff_var = var(Ipred_diff,1);
    
        Ipred_diff_mean_bin = mean(Ipred_diff_mean);
        Ipred_diff_var_bootavg = mean(Ipred_diff_var);
        Ipred_diff_var_bin = var(Ipred_diff_mean);
        Ipred_diff_se_bin = sqrt(Ipred_diff_var_bootavg + Ipred_diff_var_bin)/sqrt(size(Ipred_diff,2));

end