%Jan 14
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Control as reference
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Resample  dataset with fixing number in each
%%%%bin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

load('IpvsIa_control_oct_multi_boot_1000_result_shuffled_c')

[std_Idiff_i_bin,~,~] = std_Idiff_Jan14(pred_I_boot_c2,pred_I_boot_i,Iboot_c,I_i,I_c);
[std_Idiff_m_bin,~,~] = std_Idiff_Jan14(pred_I_boot_c2,pred_I_boot_m,Iboot_c,I_m,I_c);


% 
% std_Idiff_i_bin = std(Ipred_diff_boot_i_bin,1);
% std_Idiff_m_bin = std(Ipred_diff_boot_m_bin,1);



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


%%find the nearest neighbour 
%find the range of bins by original control laser current
[~, ~ ,bin_range]=data_bin(I_c,5);

% Find the data point in ibuprofen with closest laser power with the data
% points in control
nei_list_i_real = zeros(1,size(I_c,2));

% Create a mapping list from data to model 
for i = 1:size(I_c,2)
    templist = abs(I_c(i)-I_i);
    temppos = find(templist==min(templist));
    nei_list_i_real(i) = temppos(1);    %list of datapoints in I_i that is closest to I_c
end

% Find the data point in mutant with closest laser power with the data
% points in control
nei_list_m_real = zeros(1,size(I_c,2));

% Create a mapping list from data to model 
for i = 1:size(I_c,2)
    templist = abs(I_c(i)-I_m);
    temppos = find(templist==min(templist));
    nei_list_m_real(i) = temppos(1);    %list of datapoints in I_m that is closest to I_c
end


%compute difference of laser power 
pred_I_ci_nei = pred_I_ci(:,nei_list_i_real);
Ipred_diff_i_real = pred_I_cc - pred_I_ci_nei;
pred_I_cm_nei = pred_I_cm(:,nei_list_m_real);
Ipred_diff_m_real = pred_I_cc - pred_I_cm_nei;



%compute mean diff
[bin_num, meanI ,bin_range]=data_bin(I_c,5);
for ii = 1:5
    mean_Idiff_i_bin(ii) = mean(Ipred_diff_i_real(bin_num==ii));
    mean_Idiff_m_bin(ii) = mean(Ipred_diff_m_real(bin_num==ii));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Calculate the Zscore of the ibuprofen data


[numlist,Zscore_i_all] = Zscore_Jan14;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%plotting the figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% FigHandle=figure(8)
% clf(8)
% set(FigHandle, 'Position', [100, 100, 1041, 369]);

fig2=figure(6)
clf(6)
set(fig2, 'Position', [100, 100, 1561, 369]);
% fig2.Units = 'inches'
% fig2.Position = [2 2 7.5 1.765];
fig2.PaperUnits = 'inches';
fig2.PaperPosition = [0 0 7.5 2];
fig2.PaperSize = [7.5 2];


subplot(1,3,1)
errorbar(meanI,mean_Idiff_i_bin,std_Idiff_i_bin,'bs','LineWidth',1,'MarkerSize',2)
set(gca,'FontSize',6,'fontWeight','bold')
xlabel('Actual laser current (mA)','FontSize',7,'fontWeight','bold')
ylabel('Decrease of inferred laser current (mA)','FontSize',6,'fontWeight','bold')
title('A','FontSize',7,'fontWeight','bold')
ylim([-10 35])
hline = refline([0 0]);
hline.Color = 'black';

subplot(1,3,2)
errorbar(meanI,mean_Idiff_m_bin,std_Idiff_m_bin,'gs','LineWidth',1,'MarkerSize',2)
set(gca,'FontSize',6,'fontWeight','bold')
% title('\Delta I and SE of control and mutant (Control as ref)')
xlabel('Actual laser current (mA)','FontSize',7,'fontWeight','bold')
ylabel('Decrease of inferred laser current (mA)','FontSize',6,'fontWeight','bold')
title('B','FontSize',7,'fontWeight','bold')
ylim([-10 35])
hline = refline([0 0]);
hline.Color = 'black';

subplot(1,3,3)
plot(numlist,Zscore_i_all,'-b')
set(gca,'FontSize',6,'fontWeight','bold')
% title('\Delta I and SE of control and mutant (Control as ref)')
xlabel('Number of ibuprofen samples','FontSize',7,'fontWeight','bold')
ylabel('Z-score','FontSize',6,'fontWeight','bold')
title('C','FontSize',7,'fontWeight','bold')

