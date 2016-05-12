function [] = IpdiffvsIa_multi(bootdatafname,nonbootdatafname)

%%This function calculates the difference between predicted laser


% Number of bins in the avg_prob_map 
nbins = 5;

% anonymous function defining the rescaling model
factor1 = @(I,I1) I1(1)+((I)./(1+(I/I1(2)))); 

% Read the predicted I vs actual I data (bootstrapped and non-bootstrapped)
% load(bootdatafname);
% load(nonbootdatafname);

load('IpvsIa_control_oct_multi_boot_1000_result.mat')

boot_size = size(pred_I_boot_c,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Compute the bootstrapped value and diff of slope of Ip vs Ia
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:boot_size
    lm = fitlm(I_c',pred_I_boot_c(i,:)','linear');
    slopec(i) = lm.Coefficients{2,1};
    lm = fitlm(I_i',pred_I_boot_i(i,:)','linear');
    slopei(i) = lm.Coefficients{2,1};
    lm = fitlm(I_m',pred_I_boot_m(i,:)','linear');
    slopem(i) = lm.Coefficients{2,1};
end
slopec_mean = mean(slopec);
slopec_se = std(slopec)/sqrt(boot_size);
slopei_mean = mean(slopei);
slopei_se = std(slopei)/sqrt(boot_size);
slopem_mean = mean(slopem);
slopem_se = std(slopem)/sqrt(boot_size);

slopecm = slopec-slopem;
slopeci = slopec-slopei;
slopecm_mean = mean(slopecm);
slopecm_se = std(slopecm)/sqrt(boot_size);
slopeci_mean = mean(slopeci);
slopeci_se = std(slopeci)/sqrt(boot_size);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Compute I diff using control as ref point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the data point in ibuprofen with closest laser power with the data
% points in control
nei_list_all = cell(1,size(I_c,2));
nei_list_i = zeros(1,size(I_c,2));

% Create a mapping list from data to model 
for i = 1:size(I_c,2)
    templist = abs(I_c(i)-I_i);
    temppos = find(templist==min(templist));
    nei_list_all{i} = temppos;
    nei_list_i(i) = temppos(1);    %list of datapoints in I_i that is closest to I_c
end

% Find the data point in mutant with closest laser power with the data
% points in control
nei_list_all = cell(1,size(I_c,2));
nei_list_m = zeros(1,size(I_c,2));

% Create a mapping list from data to model 
for i = 1:size(I_c,2)
    templist = abs(I_c(i)-I_m);
    temppos = find(templist==min(templist));
    nei_list_all{i} = temppos;
    nei_list_m(i) = temppos(1);    %list of datapoints in I_m that is closest to I_c
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%compute difference of laser power in each bootstrap
pred_I_i_nei = pred_I_boot_i(:,nei_list_i);
Ipred_diff_i = pred_I_boot_c - pred_I_i_nei;
pred_I_m_nei = pred_I_boot_m(:,nei_list_m);
Ipred_diff_m = pred_I_boot_c - pred_I_m_nei;



%binning the results
[~,meanI_c,~]=data_bin(I_c, 5);
[~,Ipred_diff_mean_i_bin,Ipred_diff_se_i_bin]=IpdiffvsIa_binse(Ipred_diff_i,I_c,5);
[~,Ipred_diff_mean_m_bin,Ipred_diff_se_m_bin]=IpdiffvsIa_binse(Ipred_diff_m,I_c,5);

% %Calculate the difference between the predicted laser power
% Ipred_diff_mean_m = mean(Ipred_diff_m);
% Ipred_diff_mean_i = mean(Ipred_diff_i);
% Ipred_diff_se_m = std(Ipred_diff_m,1)./sqrt(boot_size);
% Ipred_diff_se_i = std(Ipred_diff_i,1)./sqrt(boot_size);
%binning the results
% [bin_num meanI ~]=data_bin(I_c, 5);
% for i = 1:5
%     Ipred_diff_mean_i_bin(i) = mean(Ipred_diff_mean_i(bin_num==i))'; 
%     Ipred_diff_mean_m_bin(i) = mean(Ipred_diff_mean_m(bin_num==i))'; 
%     Ipred_diff_se_i_bin(i) = mean(Ipred_diff_se_i(bin_num==i))'; 
%     Ipred_diff_se_m_bin(i) = mean(Ipred_diff_se_m(bin_num==i))'; 
% end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Compute I diff using ibuprofen/mutant as ref point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the data point in control with closest laser power with the data
% points in ibuprofen
nei_diff = zeros(1,size(I_i,2));
nei_list_i2 = zeros(1,size(I_i,2));

% Create a mapping list from data to model 
for i = 1:size(I_i,2)
    templist = abs(I_i(i)-I_c);
    temppos = find(templist==min(templist));
    nei_diff(i) = min(templist);
    nei_list_i2(i) = temppos(1);    %list of datapoints in I_c that is closest to I_i
end

% Find the data point in mutant with closest laser power with the data
% points in control
nei_diff = zeros(1,size(I_m,2));
nei_list_m2 = zeros(1,size(I_m,2));

% Create a mapping list from data to model 
for i = 1:size(I_m,2)
    templist = abs(I_m(i)-I_c);
    temppos = find(templist==min(templist));
    nei_diff(i) = min(templist);
    nei_list_m2(i) = temppos(1);    %list of datapoints in I_c that is closest to I_m
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%compute difference of laser power in each bootstrap
pred_I_i_nei2 = pred_I_boot_c(:,nei_list_i2);
Ipred_diff_i2 = pred_I_i_nei2-pred_I_boot_i ;
pred_I_m_nei2 = pred_I_boot_c(:,nei_list_m2);
Ipred_diff_m2 = pred_I_m_nei2-pred_I_boot_m;

%binning the results
[~,Ipred_diff_mean_i_bin2,Ipred_diff_se_i_bin2]=IpdiffvsIa_binse(Ipred_diff_i2,I_i,5);
[~,Ipred_diff_mean_m_bin2,Ipred_diff_se_m_bin2]=IpdiffvsIa_binse(Ipred_diff_m2,I_m,5);
[~,meanI_i,~]=data_bin(I_i, 5);
[~,meanI_m,~]=data_bin(I_m, 5);


% %Calculate the difference between the predicted laser power
% Ipred_diff_mean_m2 = mean(Ipred_diff_m2);
% Ipred_diff_mean_i2 = mean(Ipred_diff_i2);
% Ipred_diff_se_m2 = std(Ipred_diff_m2,1)./sqrt(boot_size);
% Ipred_diff_se_i2 = std(Ipred_diff_i2,1)./sqrt(boot_size);
% %binning the results
% [bin_num_i meanI ~]=data_bin(I_i, 5);
% [bin_num_m meanI ~]=data_bin(I_m, 5);
% for i = 1:5
%     Ipred_diff_mean_i_bin2(i) = mean(Ipred_diff_mean_i2(bin_num_i==i))'; 
%     Ipred_diff_mean_m_bin2(i) = mean(Ipred_diff_mean_m2(bin_num_m==i))'; 
%     Ipred_diff_se_i_bin2(i) = mean(Ipred_diff_se_i2(bin_num_i==i))'; 
%     Ipred_diff_se_m_bin2(i) = mean(Ipred_diff_se_m2(bin_num_m==i))'; 
% end


%%%plotting the figure


figure
errorbar(meanI_c,Ipred_diff_mean_i_bin,Ipred_diff_se_i_bin)
title('\Delta I and SE of control and ibuprofen (Control as ref)')
xlabel('Control laser power (mA)')
ylabel('\Delta I (mA)')

figure
errorbar(meanI_c,Ipred_diff_mean_m_bin,Ipred_diff_se_m_bin)
title('\Delta I and SE of control and mutant (Control as ref)')
xlabel('Control laser power (mA)')
ylabel('\Delta I (mA)')

figure
errorbar(meanI_i,Ipred_diff_mean_i_bin2,Ipred_diff_se_i_bin2)
title('\Delta I and SE of control and ibuprofen (Ibuprofen as ref)')
xlabel('ibuprofen laser power (mA)')
ylabel('\Delta I (mA)')

figure
errorbar(meanI_m,Ipred_diff_mean_m_bin2,Ipred_diff_se_m_bin2)
title('\Delta I and SE of control and mutant (mutant as ref)')
xlabel('mutant laser power (mA)')
ylabel('\Delta I (mA)')


%%saving the data
clearvars p_all_c p_all_i p_all_m
save IpvsIa_diff_control_oct_multi_boot_1000
end

