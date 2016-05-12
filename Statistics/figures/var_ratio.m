%plot figure 4



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Compute variance difference for smoothed / nonsmoothed dataset
clear all
smoothflag = 1;

factor1 = @(I,I1) I1(1)+((I)./(1+(I/I1(2)))); 
% factor1 = @(I,I1) (I1(1)+((I)./(1+(I/I1(2)))))/(I1(1)+I1(2)); 
% factor1 = @(I,I1) ((I)./(1+(I/I1(2)))); 
% factor1 = @(I,I1) (I1(2)*I);

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

S_i = gopause(fspeed_i);
I_i = I;


load('mutant.mat')
%Undersample the fspeed
fspeed_m = fspeed(speedtimelist,:);
speed_m = speed(speedtimelist,:);
%%%%

S_m = gopause(fspeed_m);
I_m = I;
%%%%Data prep end


%%%data processing
timelabel = speedtimelist; 

    [p_all_c,I0c,I1c,ugt_c,sigmagt_c,upt_c,sigmapt_c,likelihood_c] = P_Ipred_multi(I_c,S_c,fspeed_c,[5 180],[],factor1,[40 40],1);
    [p_all_m,I0m,I1m,ugt_m,sigmagt_m,upt_m,sigmapt_m,likelihood_m] = P_Ipred_multi(I_m,S_m,fspeed_m,[5 180],[],factor1,[40 40],1);
    [p_all_i,I0i,I1i,ugt_i,sigmagt_i,upt_i,sigmapt_i,likelihood_i] = P_Ipred_multi(I_i,S_i,fspeed_i,[5 180],[],factor1,[40 40],1);
    
    [ratiodata_c ,ratiodata2_c, collaspe_v_c,collaspe_SD_c,uncollaspe_v_c,uncollaspe_SD_c,meanI_c,totalvar_c,exvar_c] = collaspe_plot_5binned(fspeed_c,I_c,I1c,S_c);
    [ratiodata_i ,ratiodata2_i, collaspe_v_i,collaspe_SD_i,uncollaspe_v_i,uncollaspe_SD_i,meanI_i,totalvar_i,exvar_i] = collaspe_plot_5binned(fspeed_i,I_i,I1i,S_i);
    [ratiodata_m, ratiodata2_m, collaspe_v_m,collaspe_SD_m,uncollaspe_v_m,uncollaspe_SD_m,meanI_m,totalvar_m,exvar_m] = collaspe_plot_5binned(fspeed_m,I_m,I1m,S_m);
  
I3c = abs(min(ugt_c));
I3i = abs(min(ugt_i));
I3m = abs(min(ugt_m));

%calculate deviance of control model
for ii = 1:size(likelihood_c,2)
    deviance_c(ii) = -2*log(likelihood_c(round(I_c(ii)-4),ii));
end
avg_deviance_c = mean(deviance_c); %9.77



%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%
%%%Collasped velocity plot
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%

    for ii = 1:5
        legendtext{ii} = [num2str(meanI_c(ii),3) ' mA'];
    end

timelabel = 0:27;

fig =figure(4)
fig = gcf;
fig.Units = 'inches'
fig.Position = [2 2 7.5 2.65];
% set(fig, 'Position', [100, 100, 1041, 738]);
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 7.5 2.85];
fig.PaperSize = [7.5 2.85];


clf(4)
  ax(3) = subplot(1,2,1);
  uncollaspe_SD_c2(:,1,:) = uncollaspe_SD_c;
  uncollaspe_SD_c2(:,2,:) = uncollaspe_SD_c;
  
   
   
   %%fix the legend problem
    hold
    h32 =  plot(timelabel, uncollaspe_v_c, '-');
    llegend = legend({legendtext{1},legendtext{2},legendtext{3},legendtext{4},legendtext{5}},'FontSize',6)
    %%%
  h3=  boundedline(timelabel, uncollaspe_v_c, uncollaspe_SD_c2, 'alpha');
  set(h3,'linewidth',1);
    title('A');
    ax(3).XTick = [0 6 12 18 24 30];
    ax(3).XTickLabel = [1 1.5 2 2.5 3 3.5];
    xlabel('Time (s)')
    ylabel('Velocity (a.u.)')
    set(ax(3),'FontSize',10,'fontWeight','bold')
%     
%     for ii = 1:5
%         legendtext{ii} = ['I = ' num2str(meanI_c(ii),3) 'mA'];
%     end
%     
    
   
    
    
  ax(4) = subplot(1,2,2);
  collaspe_SD_c2(:,1,:) = collaspe_SD_c;
  collaspe_SD_c2(:,2,:) = collaspe_SD_c;
  
  
   %%fix the legend problem
    hold
    h42 =  plot(timelabel, collaspe_v_c, '-');
    rlegend = legend({legendtext{1},legendtext{2},legendtext{3},legendtext{4},legendtext{5}},'FontSize',6)
    %%%
  h4=boundedline(timelabel, collaspe_v_c, collaspe_SD_c2, 'alpha');
  set(h4,'linewidth',1);
  title('B');
  ax(4).XTick = [0 6 12 18 24 30];
    ax(4).XTickLabel = [1 1.5 2 2.5 3 3.5];
    xlabel('Time (s)')
    ylabel('Collapsed Velocity (a.u.)')
    set(ax(4),'FontSize',10,'fontWeight','bold')
    
    
    


%%%%%%%%%%%%%%%%%%%%
%Var ratio and total var plot
%%%%%%%%%%%%%%%%%%%%



fig2=figure(100)
clf(100)
fig2.Units = 'inches'
fig2.Position = [2 2 7.5 1.765];
fig2.PaperUnits = 'inches';
fig2.PaperPosition = [0 0 7.5 1.965]; 
fig2.PaperSize = [7.5 1.965];


    
%%%%%%%%%%%%%%%%%%%%
%%%var diff plot
ax(1) = subplot(1,3,2);
plot(timelabel,ratiodata2_c,'-r',timelabel,ratiodata2_i,'-b',timelabel,ratiodata2_m,'-g','LineWidth',1)
title('var(binned speed)/var(speed)) (Multivariate, active nonsmoothed worms only)')
xlabel('Time (s)')
title('B')
ylabel('Fraction of explainable variance')
ylim([0 1])
ax(1).XTick = [0 6 12 18 24 30];
ax(1).XTickLabel = [1 1.5 2 2.5 3 3.5];
legend('control','ibuprofen','mutant')
set(ax(1),'FontSize',6)

ax(2) = subplot(1,3,3);
plot(timelabel,ratiodata_c,'-r',timelabel,ratiodata_i,'-b',timelabel,ratiodata_m,'-g','LineWidth',1)
title('var(binned residual)/var(binned speed)) (Multivariate, active nonsmoothed worms only)')
title('C')
xlabel('Time (s)')
ylabel('Fraction of unexplained variance')
ylim([0 1])

ax(2).XTick = [0 6 12 18 24 30];
ax(2).XTickLabel = [1 1.5 2 2.5 3 3.5];
legend('control','ibuprofen','mutant')
set(ax(2),'FontSize',6)

%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%

bx(1) = subplot(1,3,1);
plot(timelabel,totalvar_c,'-r',timelabel,totalvar_i,'-b',timelabel,totalvar_m,'-g','LineWidth',1)
xlabel('Time (s)')
title('A')
ylabel('Total variance (pixel^2/s^2)')
legend('control','ibuprofen','mutant')
bx(1).XTick = [0 6 12 18 24 30];
bx(1).XTickLabel = [1 1.5 2 2.5 3 3.5];
set(bx(1),'FontSize',6)
% 
% bx(2) = subplot(1,2,2);
% plot(timelabel,exvar_c,'-r',timelabel,exvar_i,'-b',timelabel,exvar_m,'-g','LineWidth',1)
% title('var(binned speed)/var(speed)) (Multivariate, active nonsmoothed worms only)')
% xlabel('time (s)')
% title('B')
% ylabel('Explainable variance (a.u.)')
% legend('control','ibuprofen','mutant')
% bx(2).XTick = [0 6 12 18 24 30];
% bx(2).XTickLabel = [1 1.5 2 2.5 3 3.5];
% set(bx(2),'FontSize',10,'fontWeight','bold')
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%

% 
% %%compute min max and slope of function fI
% initslope_c = abs(min(ugt_c));
% min_f_c = I1c(1)*initslope_c';
% max_f_c = (I1c(2)+I1c(1))*initslope_c';
% 
% initslope_i = abs(min(ugt_i));
% min_f_i = I1i(1)*initslope_i';
% max_f_i = (I1i(2)+I1i(1))*initslope_i';
% 
% initslope_m = abs(min(ugt_m));
% min_f_m = I1m(1)*initslope_m';
% max_f_m = (I1m(2)+I1m(1))*initslope_m';
