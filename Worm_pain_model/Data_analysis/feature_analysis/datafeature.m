function []=datafeature(speeddatapath, speedfilename,datapath, datafilename, framerate)

% function []= datafeature(speeddatapath, speedfilename,datapath, datafilename, framerate)
% 
% Input:
%  speeddatapath -- path to the file with the centroid 
% 	speed data
%  speedfilename -- filename of the centroid speed data file,
% 	datafilename '.mat' is assumed
%  datapath -- path to the file with the data file
%  datafilename -- filename of the data file,
% 	datafilename '.mat' is assumed
%  framerate -- framerate of the video.
% 
% 
% Output:
%  no output variables
% 
% Output File:
%  data will be stored in a file named 'speedfilename'_feature.mat in 
% 	the directory specified by 'speeddatapath'
% 
% Output file structure:
% 	featuredata.maxspeed(i) -- maximum backward velocity of trial i.
% 	featuredata.time2max(i) -- 
% 	featuredata.I(i) --
% 	featuredata.avgmaxspeed(i) --
% 	featuredata.SDmaxspeed(i) --
% 	featuredata.I_avgmaxspeed(i) --
% 	featuredata.acc(i) --
% 	featuredata.maxacc(i) --
% 	featuredata.angle_all(i) --
% 	featuredata.absangle(i) --
% 	featuredata.rmsangle(i) --
% 	featuredata.abssumangle(i) --
% 	featuredata.maxangle(i) --
% 	featuredata.terminal(i) --
% 	featuredata.rtime(i) --
% 	featuredata.speed(i) --
% (c) George Leung, Ilya Nemenman, Emory University, 2011-2013

%%load data
load([speeddatapath '\' speedfilename '.mat'])
load([datapath '\' datafilename '.mat'])

featuredata.I = I;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculating the maximum speed from the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Calculating maximum fspeed
for i = 1:size(fspeed,2)
        [featuredata.maxspeed(i) featuredata.time2max(i)] = max(-fspeed(framerate:framerate*3,i));
end
figure()
plot(featuredata.I,featuredata.maxspeed,'.')
title(['Max reverse speed of ' datafilename])
ylabel('Max reverse fspeed')
xlabel('Laser power')
%%%Plotting max fspeed vs laser power

I_upperlimit = max(I);
[featuredata.avgmaxspeed,featuredata.SDmaxspeed,featuredata.I_avgmaxspeed] = bin_plot(featuredata.maxspeed,I,10,I_upperlimit);
title(['Max reverse speed distribution of ' datafilename])
ylabel('Max reverse fspeed')
xlabel('Laser power')
%%%%plotting end


%%%Plotting time 2 max vs laser power
bin_plot(featuredata.time2max,I,10,150);
title(['Time to Max speed distribution of ' datafilename])
ylabel('Time to Max fspeed')
xlabel('Laser power')
%%%%plotting end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculating the acceleration from the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

featuredata.acc = diff(fspeed);
featuredata.maxacc = max(featuredata.acc(framerate:framerate*4,:));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculating the angle from the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for i = 1:length(data)
    head(:,1) = data{i}.wormskelx(:,1);
    tail(:,1) = data{i}.wormskelx(:,41);
    middle(:,1) = data{i}.wormskelx(:,21);
    head(:,2) = data{i}.wormskely(:,1);
    tail(:,2) = data{i}.wormskely(:,41);
    middle(:,2) = data{i}.wormskely(:,21);
    
    htvector{i} = tail - head;
    initvector = mean(htvector{i}(1:framerate,1:2));
    for  k = 1:16*framerate
        featuredata.angle_all(k,i) = angle_change(htvector{i}(k,1:2), initvector);
    end
end

%filter the angle?

featuredata.absangle = abs(featuredata.angle_all);
featuredata.rmsangle = sqrt(sum(featuredata.angle_all.^2));
featuredata.abssumangle= sum(abs(featuredata.angle_all));
featuredata.maxangle = max(featuredata.angle_all);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculating the terminal speed from the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

featuredata.terminal = mean(fspeed(end-framerate:end,:));

%Plotting
bin_plot(featuredata.terminal,I,10,150);
title(['Terminal speed of ' datafilename])
ylabel('Terminal speed')
xlabel('Laser power')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculating the response time from the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for i = 1:size(fspeed,2)
    temp = find(fspeed(framerate:200,i)<0);
    if isempty(temp)
        featuredata.rtime(i) = NaN;
    else
        featuredata.rtime(i) = temp(1);
    end
end

figure()
plot(I,featuredata.rtime,'.')
title(['Response time of ' datafilename])
ylabel('Response time')
xlabel('Laser power')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculating the initial speed of the worm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
featuredata.initspeed = mean(fspeed(framerate/2:framerate,:));

figure()
plot(featuredata.initspeed,featuredata.maxspeed,'.')
title(['Initial speed vs Max reverse speed of ' datafilename])
xlabel('Initial speed')
ylabel('Max reverse speed')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Combining data into one vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
featuredata.fspeed = fspeed;
featuredata.filename = filename;

combined = [];
combined = [featuredata.maxspeed;featuredata.time2max;featuredata.rmsangle;featuredata.maxangle;featuredata.rtime;featuredata.maxacc;featuredata.terminal];
combined(:,find(isnan(featuredata.rtime))) = [];
I(:,find(isnan(featuredata.rtime))) = [];



%%%saving the data
save([speeddatapath '\' speedfilename '_feature'],'featuredata','combined','I','fspeed','nfspeed')
%%%



end