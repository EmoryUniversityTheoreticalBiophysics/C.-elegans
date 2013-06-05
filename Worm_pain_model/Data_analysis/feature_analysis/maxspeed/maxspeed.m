%%%Calculate maximum backward speed of the worm
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
endtime = 200;
%%%Settings end
%%%%%%%%%%%%%%%%%%%%%%%%%%


%%load data
cd(speeddatapath)
load(datafilename)
speed = eval(speedvarname);
tI = eval(laservarname);


%%Calculating maximum speed
for i = 1:size(speed,2)
    temp = find(speed(starttime:200,i)<0);
    
    %Put NaN into the results if the worm is keep moving forward
    if isempty(temp)
        rtime(i) = NaN;
        maxvalue(i) = NaN;
        time2max(i) = NaN;
    else
        rtime(i) = temp(1);
        [maxvalue(i) time2max(i)] = max(-speed(starttime:endtime,i));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Plotting max speed vs laser power
binl = 10;
diff =  150.1/binl;

tmaxvalue = maxvalue;
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

ylabel('Max speed')
xlabel('Laser power')
%%%%plotting end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%saving data
cd(orgpath);
savefilename = ['max' speedvarname];
save(savefilename,'maxvalue','time2max')

