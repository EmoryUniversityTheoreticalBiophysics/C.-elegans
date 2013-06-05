
%%%%%%%%%%%%%%%%%%%%%%%
%%%find max speed
%%%%%%%%%%%%%%%%%%%%%%5
load D:\Dropbox\Ilya\Worm_Pain\Data_Ayalsis\3rd_data_analysis\DATAANLYSIS\centroid_speed\speed_ctrl.mat

speed = speed_ctrl;
tI = I_ctrl;
lasertime = 60;
lasertime2 = 30;

for i = 1:size(speed,2)
    temp = find(speed(lasertime:200,i)<0);
    if isempty(temp)
        rtime(i) = NaN;
        maxspeed(i) = NaN;
        time2maxspeed(i) = NaN;
    else
        rtime(i) = temp(1);
        [maxspeed(i) time2maxspeed(i)] = max(-speed(lasertime:200,i));
    end
end


%%%%%%%%%%%%%max speed end
%%%%
%%%calculate mean acceleration around maxspeed
%%%%
clear acc acc1 acc2
time2maxspeed = time2maxspeed+lasertime;
windowsize = 20;
for i = 1:size(speed,2)
    if isnan(maxspeed(i))
    else
    acc(i,:) = gradient(speed_ctrl(:,i));
    acc1(i) = mean(acc(i,time2maxspeed(i)-windowsize:time2maxspeed(i)));
    acc2(i) = mean(acc(i,time2maxspeed(i):time2maxspeed(i)+windowsize));
    end
end
%%%%histogram%%%%
%%%%%%%%%%%%%%%%%%%%%%
binl = 10;
diff =  150.1/binl;

tmaxvalue = acc2;
tI(find(isnan(tmaxvalue))) = [];
tmaxvalue(find(isnan(tmaxvalue))) = [];

for i = 1:binl
    temp = find(tI<(i*diff) & tI>((i-1)*diff));
    avg1(i) = mean(tmaxvalue(temp));
    SD1(i) = sqrt(var(tmaxvalue(temp)));
    x1(i) = (i+i-1)*diff/2;
end
ylabel('Acceleration after maxspeed')
xlabel('Laser power')

figure(2)
errorbar(x1,avg1,SD1/2,'xr')


%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%
%load angle data and combine into one vector
% rawdata = maxspeed;acc1;acc2;angle_diff';rmsangle;abssumangle;maxangle
%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
load angle_diff
load angle_all_analysis

% rawdata = [maxspeed;acc1;acc2;angle_diff';rmsangle;abssumangle;maxangle];
rawdata = [acc1;acc2;angle_diff';rmsangle;abssumangle;maxangle];
% 

% 
% save maxspeed_acc maxspeed time2maxspeed acc acc1 acc2
% save rawdata rawdata I_ctrl


%%%%LASSO

tI = I_ctrl;
[nx nxinfo] = lasso(rawdata',tI','NumLambda',100);
[nx_cv nxinfo_cv] = lasso(rawdata',tI','CV',10,'NumLambda',100);

save lasso_temp nx nxinfo  nx_cv nxinfo_cv

r2 = 1-(nxinfo_cv.MSE./mean((tI-mean(tI)).^2));
nonzeros = nxinfo_cv.DF;

figure(4)
plot(nonzeros,r2,'.')
xlabel('number of non-zeros')
ylabel('R-square')
title('CV R-square vs number of non-zeros')

%%%find largest r2 in each nonzeros
for i = 1:7
    tempr2 = r2;
    tempr2(nonzeros~=i-1) = 0;
    [val pos] = max(tempr2);
    maxlasso(:,i) = nx_cv(:,pos);
end

figure(10)
lassoPlot(nx,nxinfo,'PlotType','Lambda','XScale','log');

% %%%%%%%%
% %%%%%%%%
% tI = angle_diff;
% tmaxvalue = maxspeed;
% tI(find(isnan(tmaxvalue))) = [];
% tmaxvalue(find(isnan(tmaxvalue))) = [];
% corr(tI',tmaxvalue')
% %%%%%%%%
