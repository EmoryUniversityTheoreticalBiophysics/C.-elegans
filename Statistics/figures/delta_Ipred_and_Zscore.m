%%figure 8 : Compute I diff using control as ref point
% Find the difference of pred I by finding the closest ibuprofen/mutant
% datapoint for each control datapoint in terms of actual I
clear all

% Number of bins in the avg_prob_map 
nbins = 5;

% anonymous function defining the rescaling model
factor1 = @(I,I1) I1(1)+((I)./(1+(I/I1(2)))); 

% Read the predicted I vs actual I data (bootstrapped and non-bootstrapped)
% load(bootdatafname);
% load(nonbootdatafname);

cd('/Users/kleung4/Dropbox/Ilya/Worm_Pain/Data_Ayalsis/data_multi_gaussain/Para_var/multi_results_data')
load('IpvsIa_control_oct_multi_boot_1000_result.mat')

boot_size = size(pred_I_boot_c,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute I diff SE using control as ref point
% Find the difference of pred I by finding the closest ibuprofen/mutant
% datapoint for each control datapoint in terms of actual I
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%find the range of bins by original control laser current
[~, ~ ,bin_range]=data_bin(I_c,5);

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


%%%Difference between the actual laser power and neighbour
actIdiff_i = abs(I_c - I_i(nei_list_i));
actIdiff_m = abs(I_c - I_m(nei_list_m));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%compute difference of laser power in each bootstrap
pred_I_i_nei = pred_I_boot_i(:,nei_list_i);
Ipred_diff_i = pred_I_boot_c - pred_I_i_nei;
pred_I_m_nei = pred_I_boot_m(:,nei_list_m);
Ipred_diff_m = pred_I_boot_c - pred_I_m_nei;

%binning the results
[bin_num_c,meanI_c,~]=data_bin(I_c, 5);
[Ipred_diff_mean_i_bin,Ipred_diff_se_i_bin]=IpdiffvsIa_binse(Ipred_diff_i,I_c,5);
[Ipred_diff_mean_m_bin,Ipred_diff_se_m_bin]=IpdiffvsIa_binse(Ipred_diff_m,I_c,5);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute I diff SE using ibuprofen/mutant as ref point
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
[bin_num_i,meanI_i,~]=data_bin(I_i, 5);
[bin_num_m,meanI_m,~]=data_bin(I_m, 5);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Compute Actual difference of Pred I
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

factor1 = @(I,I1) I1(1)+((I)./(1+(I/I1(2)))); 
% factor1 = @(I,I1) I1(1)+(I1(2)*I);

range_speed = [60 200];
%Undersampling rate
usratio = 5;
speedtimelist = round(linspace(range_speed(1),range_speed(2),(range_speed(2)-range_speed(1)+1)/usratio));
%%%%

%%%%Data preparation 
load('control_oct.mat')
%Undersample the fspeed
fspeed_c = fspeed(speedtimelist,:);
speed_c = speed(speedtimelist,:);
%%%%

S_c = gopause(fspeed_c);
I_c = I;

load('ibuprofen.mat')
%Undersample the fspeed
fspeed_i = fspeed(speedtimelist,:);
speed_i = speed(speedtimelist,:);
%%%%
I_i = I;


load('mutant.mat')
%Undersample the fspeed
fspeed_m = fspeed(speedtimelist,:);
speed_m = speed(speedtimelist,:);
%%%%
I_m = I;
%%%%Data prep end

    [p_all_cc,I0c,I1c,ugt_c,sigmagt_c,upt_c,sigmapt_c] = P_Ipred_multi(I_c,S_c,fspeed_c,[5 180],fspeed_c,factor1,[40 40],1);
    [p_all_ci,~,~,~,~,~,~] = P_Ipred_multi(I_c,S_c,fspeed_c,[5 180],fspeed_i,factor1,[40 40],1);
    [p_all_cm,~,~,~,~,~,~] = P_Ipred_multi(I_c,S_c,fspeed_c,[5 180],fspeed_m,factor1,[40 40],1);

    pred_I_cc = zeros(1,size(p_all_cc,2));
for i = 1:size(p_all_cc,1)
pred_I_cc = pred_I_cc+(p_all_cc(i,:)*(i+4));
end
pred_I_ci = zeros(1,size(p_all_ci,2));
for i = 1:size(p_all_ci,1)
pred_I_ci = pred_I_ci+(p_all_ci(i,:)*(i+4));
end
pred_I_cm = zeros(1,size(p_all_cm,2));
for i = 1:size(p_all_cm,1)
pred_I_cm = pred_I_cm+(p_all_cm(i,:)*(i+4));
end

%compute difference of laser power in each bootstrap
pred_I_ci_nei = pred_I_ci(:,nei_list_i);
Ipred_diff_i_real = pred_I_cc - pred_I_ci_nei;
pred_I_cm_nei = pred_I_cm(:,nei_list_m);
Ipred_diff_m_real = pred_I_cc - pred_I_cm_nei;


%compute difference of laser power in each bootstrap
pred_I_ci_nei2 = pred_I_cc(:,nei_list_i2);
Ipred_diff_i_real2 = pred_I_ci_nei2-pred_I_ci ;
pred_I_cm_nei2 = pred_I_cc(:,nei_list_m2);
Ipred_diff_m_real2 = pred_I_cm_nei2-pred_I_cm;


%compute mean diff
for ii = 1:5
    Ipred_diff_mean_i_real(ii) = mean(Ipred_diff_i_real(bin_num_c==ii));
    Ipred_diff_mean_m_real(ii) = mean(Ipred_diff_m_real(bin_num_c==ii));
    Ipred_diff_mean_i_real2(ii) = mean(Ipred_diff_i_real2(bin_num_i==ii));
    Ipred_diff_mean_m_real2(ii) = mean(Ipred_diff_m_real2(bin_num_m==ii));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%plotting the figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Control as reference
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FigHandle=figure(8)
clf(8)
set(FigHandle, 'Position', [100, 100, 1041, 369]);

subplot(1,2,1)

errorbar(meanI_c,Ipred_diff_mean_i_real,Ipred_diff_se_i_bin,'s','LineWidth',2,'MarkerSize',4)
xlabel('Actual laser power of control dataset (mA)')
ylabel('Difference of Predicted laser power \Delta I_i (mA)')
set(gca,'FontSize',15,'fontWeight','bold')
title('A')
ylim([-10 35])

subplot(1,2,2)

errorbar(meanI_c,Ipred_diff_mean_m_real,Ipred_diff_se_m_bin,'s','LineWidth',2,'MarkerSize',4)
% title('\Delta I and SE of control and mutant (Control as ref)')
xlabel('Actual laser power of control dataset (mA)')
ylabel('Difference of Predicted laser power \Delta I_m  (mA)')
set(gca,'FontSize',15,'fontWeight','bold')
title('B')
ylim([-10 35])
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%Mutant/Ibuprofen as reference
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FigHandle=figure(18)
% clf(18)
% set(FigHandle, 'Position', [100, 100, 1041, 369]);
% 
% subplot(1,2,1)
% errorbar(meanI_i,Ipred_diff_mean_i_real2,Ipred_diff_se_i_bin2,'x','LineWidth',4,'MarkerSize',12)
% % title('\Delta I and SE of control and ibuprofen (Control as ref)')
% xlabel('Actual laser power of control dataset (mA)')
% ylabel('Difference of Predicted laser power \Delta I_i (mA)')
% set(gca,'FontSize',15,'fontWeight','bold')
% 
% subplot(1,2,2)
% errorbar(meanI_m,Ipred_diff_mean_m_real2,Ipred_diff_se_m_bin2,'x','LineWidth',4,'MarkerSize',12)
% % title('\Delta I and SE of control and mutant (Control as ref)')
% xlabel('Actual laser power of control dataset (mA)')
% ylabel('Difference of Predicted laser power \Delta I_m  (mA)')
% set(gca,'FontSize',15,'fontWeight','bold')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%figure9
%%%Z-score vs sample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[bin_num_total,meanI_c,~]=data_bin(I_c,5);


bin_num_suffle = find(bin_num_total==4);
bin_num_suffle = bin_num_suffle(randperm(sum(bin_num_total==4)));
[~,Ipred_diff_se_i]=IpdiffvsIa_zscore(Ipred_diff_i,bin_num_suffle);
zscore_i = Ipred_diff_mean_i_real(4)./Ipred_diff_se_i;

bin_num_suffle = find(bin_num_total==4);
bin_num_suffle = bin_num_suffle(randperm(sum(bin_num_total==4)));
[~,Ipred_diff_se_m]=IpdiffvsIa_zscore(Ipred_diff_m,bin_num_suffle);
zscore_m = Ipred_diff_mean_m_real(4)./Ipred_diff_se_m;

FigHandle=figure(9)
clf(9)
set(FigHandle, 'Position', [100, 100, 1041, 369]);

subplot(1,2,1)

plot(zscore_i,'LineWidth',4)
xlim([5 40])
title('A')
xlabel('Number of samples')
ylabel('Z-score')
set(gca,'FontSize',20,'fontWeight','bold')

subplot(1,2,2)

plot(zscore_m,'LineWidth',4)
title('B')
xlim([5 40])
xlabel('Number of samples')
ylabel('Z-score')
set(gca,'FontSize',20,'fontWeight','bold')





