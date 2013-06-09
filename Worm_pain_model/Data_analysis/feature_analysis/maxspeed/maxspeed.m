function []=maxspeed(speeddatapath, datafilename,starttime,endtime,binlength)

% function []=maxspeed(speeddatapath, datafilename)binlength
% 
% This function calaculates the maximum backward velocity and the time 
% which the maximum velocity is reached between 'starttime' and 'endtime' and save the
% result in .mat format. This function also seperate the data into binlength groups
% according to their laser power and calculate the average and standard
% deviation of maximum backward velocity respectively.
% 
% 
% Recommended values:
% For 60fps data --'starttime' = 60, 'edntime'= 200. 
% For 30fps data --'starttime' = 30, 'edntime'= 100. 
% 'binlength' = 10.
% 
% Input:
%  speeddatapath -- path to the file with the centroid 
% 	speed data
%  datafilename -- filename of the centroid speed data file,
% 	datafilename '.mat' is assumed
%  starttime -- starting time of measurement.
%  filterlength -- ending time of measurement.
%  binlength -- 
% 
% Input file structure:
% 	fspeed (i,j) -- filtered centroid velocity at time i of trial j.
%   I(i) -- laser power of worm i.
% 
% Output:
%  no output variables
% 
% Output File:
%  data will be stored in a file named 'datafilename'_max.mat in 
% 	the directory specified by 'path_to_file'
% 
% Output file structure:
% 	maxvalue(i) -- maximum backward velocity of trial i.
%   time2max i) -- filtered and normalized centroid veloctiy at time i of trial j.
%   avgmaxspeed(k) -- average maximum backward velocity of group k.
%   SDmaxspeed(k) -- standard deviation of the maximum backward velocities of group k.
%   I_avgmaxspeed(k) -- laser power of group k.
% 
% (c) George Leung, Ilya Nemenman, Emory University, 2011-2013


%%load data
cd(speeddatapath)
load(datafilename)


%%Calculating maximum fspeed
for i = 1:size(fspeed,2)
    temp = find(fspeed(starttime:200,i)<0);
    
    %Put NaN into the results if the worm is keep moving forward
    if isempty(temp)
        maxvalue(i) = NaN;
        time2max(i) = NaN;
    else
        [maxvalue(i) time2max(i)] = max(-fspeed(starttime:endtime,i));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Plotting max fspeed vs laser power
binlength = 10;
diff =  150.1/binlength;

tmaxvalue = maxvalue;
I(find(isnan(tmaxvalue))) = [];
tmaxvalue(find(isnan(tmaxvalue))) = [];

for i = 1:binlength
    temp = find(I<(i*diff) & I>((i-1)*diff));
    avgmaxspeed(i) = mean(tmaxvalue(temp));
    SDmaxspeed(i) = sqrt(var(tmaxvalue(temp)));
    I_avgmaxspeed(i) = (i+i-1)*diff/2;
end


figure(1)
errorbar(I_avgmaxspeed,avgmaxspeed,SDmaxspeed/2,'xr')

ylabel('Max fspeed')
xlabel('Laser power')
%%%%plotting end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%saving data
savefilename = [datafilename '_max'];
save(savefilename,'maxvalue','time2max','avgmaxspeed','I_avgmaxspeed','SDmaxspeed')
end
