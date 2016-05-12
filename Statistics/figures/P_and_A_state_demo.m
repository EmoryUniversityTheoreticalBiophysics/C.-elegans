%%%new fig 3

%%%% A part

clear all
load('control_oct')
mrv = (min(fspeed(60:200,:)));
I_1 = I;


%%%% B part


%%%%%%%%%%%%%
%%%Figure 3
%%%%%%%%%%%%%

%Undersampling rate
range_speed = [60 200];
usratio = 1;
speedtimelist = round(linspace(range_speed(1),range_speed(2),(range_speed(2)-range_speed(1)+1)/usratio));
%%%%
init_val = [40,40];  
nbins= 5;
factor1 = @(I,I1) I1(1)+((I)./(1+(I/I1(2)))); 
factor0 = @(I,I0) 1./(1+(I./I0).^2); 




%%Binning the data with the same bin according to control dataset
load('control_oct')
mrvc = (min(fspeed(60:200,:)));
I_c = I;
fspeed_c = fspeed(speedtimelist,:);
S_c = gopause(fspeed_c);


[bin_num_c ,meanIc ,bin_range_c]=data_bin(I, nbins);
bin_range_c = [0 bin_range_c];
bin_range_c(6) = 200;
for ii = 1:5
     mean_pc(ii) = mean(S_c(bin_num_c==ii));
     ste_pc(ii) = std(S_c(bin_num_c==ii))/sqrt(length(S_c(bin_num_c==ii)));
     mean_mrvc(ii) = mean(mrvc(bin_num_c==ii));
     ste_mrvc(ii) = std(mrvc(bin_num_c==ii))/sqrt(length(mrvc(bin_num_c==ii)));
end

load('ibuprofen')
mrvi = (min(fspeed(60:200,:)));
I_i = I;
fspeed_i = fspeed(speedtimelist,:);
S_i = gopause(fspeed_i);


bin_num_i = zeros(1,length(I_i));
    for ii = 1:5
         bin_num_i((I_i<=bin_range_c(ii+1) & I_i>bin_range_c(ii))) = ii;
    end

for ii = 1:5
     mean_pi(ii) = mean(S_i(bin_num_i==ii));
     ste_pi(ii) = std(S_i(bin_num_i==ii))/sqrt(length(S_i(bin_num_i==ii)));
     mean_mrvi(ii) = mean(mrvi(bin_num_i==ii));
     ste_mrvi(ii) = std(mrvi(bin_num_i==ii))/sqrt(length(mrvi(bin_num_i==ii)));
end


load('mutant')
mrvm = (min(fspeed(60:200,:)));
fspeed_m = fspeed(speedtimelist,:);
I_m = I;
S_m = gopause(fspeed_m);

bin_num_m = zeros(1,length(I_m));
    for ii = 1:5
         bin_num_m((I_m<=bin_range_c(ii+1) & I_m>bin_range_c(ii))) = ii;
    end
    
for ii = 1:5
     mean_pm(ii) = mean(S_m(bin_num_m==ii));
     ste_pm(ii) = std(S_m(bin_num_m==ii))/sqrt(length(S_m(bin_num_m==ii)));
     mean_mrvm(ii) = mean(mrvm(bin_num_m==ii));
     ste_mrvm(ii) = std(mrvm(bin_num_m==ii))/sqrt(length(mrvm(bin_num_m==ii)));
end

%%calculate I0
    I0c = Func_fit_I0(I_c,S_c);
    I0i = Func_fit_I0(I_i,S_i);
    I0m = Func_fit_I0(I_m,S_m);

%%%%%%
%%part C
%%%%%%


%%calculate I0
    I0c = Func_fit_I0(I_c,S_c);
    I0i = Func_fit_I0(I_i,S_i);
    I0m = Func_fit_I0(I_m,S_m);

    
    
%%%%Plotting the figure
I = I_1;





fig =figure(23)
   clf(23)
% fig.Units = 'inches'
% fig.Position = [2 2 7.5 1.765];
set(fig, 'Position', [100, 100, 1561, 369]);
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 7.5 2];
fig.PaperSize = [7.5 2];


subplot(1,3,2)
plot(I(mrv<-10),mrv(mrv<-10),'or', 'MarkerSize',1)
hold
plot(I(mrv>=-10),mrv(mrv>=-10),'*r', 'MarkerSize',1)
% plot(I(68),mrv(1),'sr', 'MarkerSize',10,'MarkerEdgeColor','k',...
%                 'MarkerFaceColor',[0 0 1])
% plot(I(201),mrv(173),'dg', 'MarkerSize',10,'MarkerEdgeColor','k',...
%                 'MarkerFaceColor',[1 0 0])
title('B')
xlabel('Laser current (mA)')
set(gca,'FontSize',10,'fontWeight','bold')
ylim([-100 20])
hline = refline([0 -10]);
hline.LineStyle = '--';
hline.Color = 'Red';

zeroline = refline([0 0]);
zeroline.Color = 'Black';



% 
% Xlabh = get(gca,'XLabel');
% set(Xlabh,'Position',get(Xlabh,'Position') - [0 -0.5 0])

subplot(1,3,1)
hold
h4 = errorbar(meanIc,mean_mrvc,ste_mrvc,'.r','LineWidth',0.3)
h5 = errorbar(meanIc,mean_mrvi,ste_mrvi,'.b','LineWidth',0.3)
h6 = errorbar(meanIc,mean_mrvm,ste_mrvm,'.g','LineWidth',0.3)
ylabel('Max. reverse speed (pixel/s) ')
xlabel('Laser current (mA)')
legend('control','ibuprofen','mutant')
title('A')
set(gca,'FontSize',10,'fontWeight','bold')
ylim([-100 20])
hline = refline([0 0]);
hline.Color = 'black';



subplot(1,3,3)

hold
title('C')
plot(1:200,factor0(1:200,I0c),'r','LineWidth',1)
h1 = errorbar(meanIc(mean_pc~=0),mean_pc(mean_pc~=0),ste_pc(mean_pc~=0),'.r','LineWidth',1)
plot(1:200,factor0(1:200,I0i),'b','LineWidth',1)
h2 = errorbar(meanIc(mean_pi~=0),mean_pi(mean_pi~=0),ste_pi(mean_pi~=0),'.b','LineWidth',1)
plot(1:200,factor0(1:200,I0m),'g','LineWidth',1)
h3 = errorbar(meanIc(mean_pm~=0),mean_pm(mean_pm~=0),ste_pm(mean_pm~=0),'.g','LineWidth',1)
ylabel('Probability of pause state ')
xlabel('Laser current (mA)')
legend([h1 h2 h3],'control','ibuprofen','mutant','Location','northeast')
set(gca,'FontSize',10,'fontWeight','bold')
