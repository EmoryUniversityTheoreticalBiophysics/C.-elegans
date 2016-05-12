function [] = IpdiffvsIa_plot(datafilename,modelname,dataname)
    
    load(datafilename)
   
%     figure()
%     errorbar(I_data,Ipred_max_diff_avg,Ipred_max_diff_std,'.' )
%     xlabel('laser power')
%     ylabel('Predicted laser power difference')
%     title(['Binned predicted most probable laser power of ' modelname ' - ' dataname])
% 
%     figure()
%     errorbar(meanI,Ipred_max_diff_avg_bin,Ipred_max_diff_std_bin,'.' )
%     xlabel('laser power')
%     ylabel('Predicted laser power difference')
%     title(['Predicted most probable laser power of ' modelname ' - ' dataname])
    
    figure()
    errorbar(I_data,Ipred_exp_diff_avg,Ipred_exp_diff_std,'.' )
    xlabel('laser power')
    ylabel('Predicted laser power difference')
    title(['Predicted expected laser power of ' modelname ' - ' dataname])

    nbins = 5;
    [bin_num meanI ~]=data_bin(I_data, nbins);
    var_boot = var(Ipred_exp_diff,1);
    for i = 1:nbins
        bin_numdata(i) = sum(bin_num==i);
        bin_std(i) = sqrt(mean(var_boot(bin_num==i)) +  var(Ipred_exp_diff_avg(bin_num==i)))/sqrt(bin_numdata(i));
    end

    figure()
    errorbar(meanI,Ipred_exp_diff_avg_bin,bin_std,'.' )
    xlabel('Actual laser power (mA)')
    ylabel('Difference of predicted laser power (mA)')
    title(['Binned predicted expected laser power of ' modelname ' - ' dataname])

    
end