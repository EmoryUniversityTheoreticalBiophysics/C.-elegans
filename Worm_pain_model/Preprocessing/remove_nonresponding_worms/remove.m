function []=remove_nonresponding(speeddatapath, speedfilename,datapath, datafilename)
% function []= remove_nonresponding(speeddatapath, speedfilename,datapath, datafilename)
% 
% Input:
%  speeddatapath -- path to the file with the centroid 
% 	speed data
%  speedfilename -- filename of the centroid speed data file,
% 	datafilename '.mat' is assumed
%  datapath -- path to the file with the data file
%  datafilename -- filename of the data file,
% 	datafilename '.mat' is assumed
% 
% Output:
%  no output variables
% 
% Output File:
%  data will be stored in a file named 'speedfilename'_removed.mat in 
% 	the directory specified by 'speeddatapath'
% 
% Output file structure:
% 	featuredata.maxspeed(i) -- maximum backward velocity of trial i.
% (c) George Leung, Ilya Nemenman, Emory University, 2011-2013

load([speeddatapath '\' speedfilename '.mat'])

initspeed = mean(fspeed(1:60,:));


end