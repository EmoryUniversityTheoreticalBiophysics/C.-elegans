%%new fig 2: Correlation length of velocity
clear all

load('Control_data_CVel_Oct')
fspeed2c = fspeed(60:200,:);

load('ibuprofen')
fspeed2i = fspeed(60:200,:);

load('mutant')
fspeed2m = fspeed(60:200,:);


autocorrc = corrcoef(fspeed2c');
autocorrc = autocorrc(1,:);

autocorri = corrcoef(fspeed2i');
autocorri = autocorri(1,:);

autocorrm = corrcoef(fspeed2m');
autocorrm = autocorrm(1,:);

FigHandle =figure(12)
clf(12)
set(FigHandle, 'Position', [100, 100, 520, 369]);

hold
plot(autocorrc(1:60),'-r','LineWidth',4)
plot(autocorri(1:60),'-b','LineWidth',4)
plot(autocorrm(1:60),'-g','LineWidth',4)
legend('control','ibuprofen','mutant')
ylabel('Autocorrelation of velocity')
xlabel('Time (s)')
ax = gca;
set(ax,'FontSize',20,'fontWeight','bold')
ax.XTick = 0:15:600;
ax.XTickLabel = (0:15:600)./60;