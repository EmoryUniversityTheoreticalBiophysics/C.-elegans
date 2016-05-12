
%%%CM_velocity 

cd('/Users/kleung4/Desktop/OLDwormfile/Worm_data/Plots')
FigHandle=figure(1)
clf(1)
% 
FigHandle.Units = 'pixel'
set(FigHandle, 'Position', [100, 100, 1041, 369]);
% FigHandle.Units = 'inches'
% FigHandle.Position = [2 2 7.5 2.67];
% set(FigHandle, 'Position', [100, 100, 1561, 369]);
FigHandle.PaperUnits = 'inches';
FigHandle.PaperPosition = [1 1 7.5 3];
FigHandle.PaperSize = [7.5 3];


load('Control_data_CVel_Oct')
subplot(1,2,1)

plot(fspeed(1:600,68),'LineWidth',1)
hold on
plot(fspeed(1:600,201),'LineWidth',1)
ylabel('Center of mass velocity (pixel/s)')
xlabel('Time (s)')
set(gca,'FontSize',10,'fontWeight','bold')
legend('Pause','Active')
ax = gca;
ax.XTick = 0:60:600;
ax.XTickLabel = (0:60:600)./60;
ylim([-80 40])
title('A')
vliney = -80:40;
vlinex = ones(1,length(vliney))*60;
vline = plot(vlinex,vliney,'k-')
vline.Color = 'Black'

zeroline2 = refline([0 0]);
zeroline2.Color = 'Black';


subplot(1,2,2)

load('Control_centroid_data_all')
temp1 = squeeze(centroid(318,1:20:600,:));

plot(temp1(:,1),temp1(:,2),'LineWidth',1)
hold
temp2 = squeeze(centroid(451,1:10:600,:));
plot(temp2(:,1),temp2(:,2),'LineWidth',1)
ylabel('Y position (pixel)')
xlabel('X position (pixel)')
title('B')
xlim([200 450])
ylim([150 400])
set(gca,'FontSize',10,'fontWeight','bold')
legend('Pause','Active')



