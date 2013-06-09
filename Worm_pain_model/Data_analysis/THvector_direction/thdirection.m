function []=thdirection(datapath, datafilename,initlength)
% function []=thdirection(datapath, datafilename,initlength)
% 
% This function calculates the tail-to-head vector (thvector) of the worm at different
% time, then calculate the angular difference between the thvector at certain frame 
% and the average thvector of first 'initlength' frames. 
% 
% Recommended input values:
%   initlength -- 30
% 
% Input:
%  datapath -- path to the file with the centroid position data
%  datafilename -- filename of the centroid position data file,
% 	extension '.mat' is assumed
%  initlength -- length of the initial reference frames.
% 
% Input file structure:
%   data(k) -- cell array of trial k containing:
%       wormskelx (i,j) -- x position of worm skeleton in i represents time 
%       and j represents relative position on the skeleton. Head is
%       represented by position 1 and tail is represented by position 41.
%       wormskely (i,j) -- y position of worms keleton. i represents time 
%       and j represents relative position on the skeleton. 
%   I(i) -- laser power of worm i
% 
% Output:
%  no output variables
% 
% Output File:
%  thdirection data will be stored in a file named 'datafilename'_thdirection.mat in 
% 	the directory specified by 'path_to_file'\datafname_analysis\centroid_speed
% 
% Output file structure:
% 	thdirection(k,i) -- angular difference of trial k between the thvector at time i 
%   and the average thvector of first 'initlength' frames in terms of degress.
%   The angle ranges from +180 to -180 degrees and clockwise is defined as
%   negative. Value of the vector equals to NaN if vector length = 0.
%   I(i) -- laser power of worm i.
% 
% Dependency:
% angle_change.m
% 
% (c) George Leung, Ilya Nemenman, Emory University, 2011-2013


%load data

load([datapath '\' datafilename '.mat'])

%calculate the change in direction during different time
for i = 1:length(data)
    
    %calculate tail to head vector
    head(:,1) = data{i}.wormskelx(:,1);
    tail(:,1) = data{i}.wormskelx(:,41);
    head(:,2) = data{i}.wormskely(:,1);
    tail(:,2) = data{i}.wormskely(:,41);
    thvector{i} = head - tail;
    
%   calculate initial vector by averaging first 'initlength' frames
    initvector = mean(thvector{i}(1:initlength,1:2));
    
%   calculate the angle between initvector and thvector
    for  k = 1:length(thvector)
        thdirection(k,i) = angle_change(initvector,thvector{i}(k,1:2));
    end
end


%Save data in the folder path_to_file\datafname_analysis\thdirection
%make one if the folder does not exist
filepathname = [datapath '\' datafilename '_analysis\thdirection'];
mkdir(filepathname)

%saving data
save([filepathname '\' datafilename '_thdirection'],'thdirection')