
% template velocity of 3 datasets on left
% max-likelihood rescaling function on right
% combine Fig. 11 and 12
clear all
cd('/Users/kleung4/Dropbox/Ilya/Worm_Pain/Data_Ayalsis/data_multi_gaussain/Para_var/multi_results_data')



% load ibu_multi_boot_1000_result ugt_full upt_full
% temp = abs(min(ugt_full'))'*ones(1,28);
% ugt_full = ugt_full./temp;
% std_ugt_i = std(ugt_full);
% std_upt_i = std(upt_full);
% 
% load mutant_multi_boot_1000_result ugt_full upt_full
% temp = abs(min(ugt_full'))'*ones(1,28);
% ugt_full = ugt_full./temp;
% std_ugt_m = std(ugt_full);
% std_upt_m = std(upt_full);
% 
% load control_oct_multi_boot_1000_result ugt_full upt_full
% temp = abs(min(ugt_full'))'*ones(1,28);
% ugt_full = ugt_full./temp;
% std_ugt_c = std(ugt_full);
% std_upt_c = std(upt_full);

load template_velocity_boot_Jan15
temp = abs(min(ugt_full_c'))'*ones(1,28);
ugt_full_c = ugt_full_c./temp;
std_ugt_c = std(ugt_full_c);
std_upt_c = std(upt_full_c);

temp = abs(min(ugt_full_i'))'*ones(1,28);
ugt_full_i = ugt_full_i./temp;
std_ugt_i = std(ugt_full_i);
std_upt_i = std(upt_full_i);

temp = abs(min(ugt_full_m'))'*ones(1,28);
ugt_full_m = ugt_full_m./temp;
std_ugt_m = std(ugt_full_m);
std_upt_m = std(upt_full_m);



load template_velocity
ugt_c = ugt_c./abs(min(ugt_c'));
ugt_i = ugt_i./abs(min(ugt_i'));
ugt_m = ugt_m./abs(min(ugt_m'));

load('curveval_boot.mat')

curvevalc_std = std(curvevalc,0,2);
curvevali_std = std(curvevali,0,2);
curvevalm_std = std(curvevalm,0,2);


%%

%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
%plot
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%

timelabel = 0:27;

figure(11)
try
clf(11)
end



fig = gcf;
% fig.Units = 'inches'
% fig.Position = [2 2 7.5 2.65];
set(fig, 'Position', [100, 100, 1561, 369]);
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 7.5 2.65];
fig.PaperSize = [7.5 2.65];

%%%Plot A - Pause template velocity
ax(1)=subplot(1,3,1);
hold on
errorbar(timelabel,upt_c,std_upt_c,'r','LineWidth',1)
errorbar(timelabel,upt_i,std_upt_i,'b','LineWidth',1)
errorbar(timelabel,upt_m,std_upt_m,'g','LineWidth',1)
legend('control','ibuprofen','mutant','Location','southeast')
xlim([0 30])
ax(1).XTick = [0 6 12 18 24 30 ];
ax(1).XTickLabel = [1 1.5 2 2.5 3 3.5];
xlabel('Time (s)')
ylabel('Pause template velocity (pixel/s)')
title('A')

%%%Plot B - Active template velocity
ax(2)=subplot(1,3,2);
hold
errorbar(timelabel,ugt_c,std_ugt_c,'r','LineWidth',1)
errorbar(timelabel,ugt_i,std_ugt_i,'b','LineWidth',1)
errorbar(timelabel,ugt_m,std_ugt_m,'g','LineWidth',1)
legend('control','ibuprofen','mutant','Location','southeast','FontSize',6)
xlim([0 30])
ax(2).XTick = [0 6 12 18 24 30];
ax(2).XTickLabel = [1 1.5 2 2.5 3 3.5];
    xlabel('Time (s)')
    ylabel('Active template velocity (a.u.)')
    
title('B')

%%subplot on B
handaxes2 = axes('Position', [0.35 0.65 0.1 0.2]);
set(handaxes2, 'Box', 'on')
hold
plot(timelabel,ugt_c,'r','LineWidth',1)
plot(timelabel,ugt_i,'b','LineWidth',1)
plot(0.5:1:26.5,ugt_m(2:28),'g','LineWidth',1)

handaxes2.XTick = [0 6 12 18 24 30];
handaxes2.XTickLabel = [1 1.5 2 2.5 3 3.5];
   xlim([0 30])

set(handaxes2,'FontSize',10)
    ylabh = get(gca,'YLabel');
set(ylabh,'Position',get(ylabh,'Position') - [1 0.5 0])



ax(3)=subplot(1,3,3);
 
curve_real = [curvevalc_real' curvevali_real' curvevalm_real'];
curve_std_temp = [curvevalc_std curvevali_std curvevalm_std];
curve_std(:,1,:) = curve_std_temp;
curve_std(:,2,:) = curve_std_temp;
hold
 h2=boundedline(10:190, curve_real(:,1), curve_std(:,:,1), 'r','alpha');
  h3=boundedline(10:190, curve_real(:,2), curve_std(:,:,2), 'b','alpha');
   h4=boundedline(10:190, curve_real(:,3), curve_std(:,:,3), 'g','alpha');
   h2.LineWidth = 1;
   h3.LineWidth = 1;
   h4.LineWidth = 1;
% errorbar(10:190,curvevalc_real,curvevalc_std,'LineWidth',2)
% errorbar(10:190,curvevali_real,curvevali_std,'LineWidth',2)
% errorbar(10:190,curvevalm_real,curvevalm_std,'LineWidth',2)

legend([h2 h3 h4],'control','ibuprofen','mutant','Location','southeast','FontSize',6)
    ylabel('Rescaling function')
    xlabel('Laser current (mA)')
    

title('C')

set(ax,'FontSize',10,'fontWeight','bold')
set(ax,'FontSize',10,'fontWeight','bold')