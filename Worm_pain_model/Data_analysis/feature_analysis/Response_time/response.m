%%%Calculate the response time of the worm
%%% 
clear all
orgpath = pwd;

%%%%%%%%%%%%%%%%%%%%%%%%%
%%Settings
%path of the centroid speed data
speeddatapath = 'D:\Dropbox\GitHub\C.-elegans\Worm_pain_model\Preprocessing\centroid_speed';
%filename
datafilename = 'speed_ctrl.mat';
%speed variable name
speedvarname = 'speed_ctrl';
%Laser power variable name
laservarname = 'I_ctrl';

%starting time for calculation
starttime = 60;
%ending time for calculation
endtime = 100;
%%%Settings end
%%%%%%%%%%%%%%%%%%%%%%%%%%



%%load data
cd(speeddatapath)
load(datafilename)
speed = eval(speedvarname);
tI = eval(laservarname);


%%Find the time when speed drops below zero
%% NaN if the speed is positive
for i = 1:size(speed,2)
    temp = find(speed(starttime:endtime,i)<0);
    if isempty(temp)
        rtime(i) = NaN;
    else
        rtime(i) = temp(1);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Plotting data

binl = 10;
diff =  150.1/binl;

tmaxvalue = rtime;
tI(find(isnan(tmaxvalue))) = [];
tmaxvalue(find(isnan(tmaxvalue))) = [];

for i = 1:binl
    temp = find(tI<(i*diff) & tI>((i-1)*diff));
    avg1(i) = mean(tmaxvalue(temp));
    SD1(i) = sqrt(var(tmaxvalue(temp)));
    x1(i) = (i+i-1)*diff/2;
end

figure(1)
errorbar(x1,avg1,SD1/2,'xr')
ylabel('Response time (control)')
xlabel('Laser power')
%%%%plotting end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%saving data
cd(orgpath)
savefilename = ['responsetime' speedvarname(6:end)];
save(savefilename,'rtime')