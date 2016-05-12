%figure 6

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% P vs A scatter plot and prob map (multi undersampled)
%%%%%%%% Predict the data according to non-bootstrapped control model

smoothflag = 1;

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


%%%data processing
timelabel = speedtimelist; 

    [p_all_cc,I0c,I1c,ugt_c,sigmagt_c,upt_c,sigmapt_c] = P_Ipred_multi(I_c,S_c,fspeed_c,[5 180],fspeed_c,factor1,[40 40],1);
    [p_all_ci,~,~,~,~,~,~] = P_Ipred_multi(I_c,S_c,fspeed_c,[5 180],fspeed_i,factor1,[40 40],1);
    [p_all_cm,~,~,~,~,~,~] = P_Ipred_multi(I_c,S_c,fspeed_c,[5 180],fspeed_m,factor1,[40 40],1);
    
    [ratiodata_c ratiodata2_c ratiodata3_c] = collaspe_plot_5binned(fspeed_c,I_c,I1c,S_c);

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
%%%data processing end



% figure
% plot(I_c,pred_I_c,'.')
R2c =  1-var(pred_I_cc-I_c)/var(I_c);
% title(['Inferred laser current vs actual laser current (R2 =' num2str(R2) ')'])
% ylabel('Inferred laser current')
% xlabel('Actual laser current')
% xlim([0 200])
% ylim([0 200])

% %prob map
% [p_avg_c meanI]=prob_map(p_all_cc,I_c,5,'Conditional probability of control oct data using control model',[]);
% [p_avg_i meanI]=prob_map(p_all_ci,I_i,5,'Conditional probability of ibuprofen data using control model',[]);
% [p_avg_m meanI]=prob_map(p_all_cm,I_m,5,'Conditional probability of mutant data using control model',[]);


[bin_num_c meanIc ~]=data_bin(I_c, 5);
[bin_num_i meanIi ~]=data_bin(I_i, 5);
[bin_num_m meanIm ~]=data_bin(I_m, 5);
%%Calculating prob map
for i = 1:5
        p_avgc(i,:) = mean(p_all_cc(:,bin_num_c==i),2)'; %average conditional probability distribution of bin i
        p_avgi(i,:) = mean(p_all_ci(:,bin_num_i==i),2)'; %average conditional probability distribution of bin i
        p_avgm(i,:) = mean(p_all_cm(:,bin_num_m==i),2)'; %average conditional probability distribution of bin i
end
 plen = size(p_all_cc,1);

%%plotting the data

fig2=figure(6)
clf(6)
set(fig2, 'Position', [100, 100, 1560, 740]);
% 
% fig2 = gcf;
% fig2.Units = 'inches'
% fig2.Position = [2 2 7.5 3.53];
fig2.PaperUnits = 'inches';
fig2.PaperPosition = [0 0 7.5 3.53];
fig2.PaperSize = [7.5 3.53];

subplot(2,3,1)
% surf([p_avgc' zeros(1,plen)'])

surf([p_avgc ; zeros(1,plen)])
colormap(gray)
shading flat 
xlabel('Inffered laser current (mA)')
ylabel('Actual laser current (mA)')
view([-270 -90]);  
title('A')
YTickvalue = [1.5 2.5 3.5 4.5 5.5];
set(gca,'YTick',YTickvalue)
set(gca,'YTickLabel',round(meanIc,0));
% set(gca,'FontSize',15,'fontWeight','bold')
caxis([0 0.02])

subplot(2,3,2)
surf([p_avgi ; zeros(1,plen)])
colormap(gray)
shading flat 
% caxis([0 0.01])
xlabel('Inferred laser current (mA)')
ylabel('Actual laser current (mA)')
view([-270 -90]);
title('B')
YTickvalue = [1.5 2.5 3.5 4.5 5.5];
set(gca,'YTick',YTickvalue)
set(gca,'YTickLabel',round(meanIi,0));
% set(gca,'FontSize',15,'fontWeight','bold')
caxis([0 0.02])

subplot(2,3,3)
surf([p_avgm ; zeros(1,plen)])
colormap(gray)
shading flat 
% caxis([0 0.01])
xlabel('Inferred laser current (mA)')
ylabel('Actual laser current (mA)')
view([-270 -90]);
title('C')
YTickvalue = [1.5 2.5 3.5 4.5 5.5];
set(gca,'YTick',YTickvalue)
set(gca,'YTickLabel',round(meanIm,0));
% set(gca,'FontSize',15,'fontWeight','bold')
caxis([0 0.02])

ax=gca;
pos=get(gca,'pos');
set(gca,'pos',[pos(1) pos(2) pos(3) pos(4)]);
pos=get(gca,'pos');
hc=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.01 pos(2) 0.01 pos(4)]);


subplot(2,3,4)
% plot(I_c,pred_I_cc,'.','MarkerSize',12)
plot(I_c,pred_I_cc,'.')
title('D')
ylabel('Inferred laser current (mA)')
xlabel('Actual laser current (mA)')
xlim([0 200])
ylim([0 200])
% set(gca,'FontSize',15,'fontWeight','bold')

subplot(2,3,5)
plot(I_i,pred_I_ci,'.')
title('E')
ylabel('Inferred laser current (mA)')
xlabel('Actual laser current (mA)')
xlim([0 200])
ylim([0 200])
% set(gca,'FontSize',15,'fontWeight','bold')

subplot(2,3,6)
plot(I_m,pred_I_cm,'.')
title('F')
ylabel('Inferred laser current (mA)')
xlabel('Actual laser current (mA)')
xlim([0 200])
ylim([0 200])
% set(gca,'FontSize',15,'fontWeight','bold')

