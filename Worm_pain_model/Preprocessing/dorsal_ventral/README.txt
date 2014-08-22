% function []=dorsal_ventral(speedfpath, speedfname, datafpath,datafname,threshold,laseron)
% 
% This function calculates the  curvature of the first 1/3 part of the body
% before the laser was fired. Then determine which side of the body the head
% was bending(dorsal/ventral).
% 
% Input:
%  speedfpath -- path to the file with the centroid 
% 	speed data
%  speedfname -- filename of the centroid speed data file,
% 	extension '.mat' is assumed
%  datafpath -- path to the file with the centroid 
% 	position data
%  datafname -- filename of the centroid position data file,
% 	extension '.mat' is assumed
%  threshold -- threshold of dorsal/ventral selection (recommended value:
%  0.01)
%  laseron -- frame no. when the laser was fired
% 
% Input file structure:
% 	fspeed (i,j) -- filtered centroid velocity at time i of trial j.
%   nfspeed (i,j) -- filtered and normalized centroid veloctiy at time i of trial j.
%   I(i) -- laser power of worm i.
%   data{k} -- cell array of trial k containing:
%       centroid (i,j) -- Centroid position of the worm. i represents time and j represents x (j = 1) and y (j = 2) coordinates. 
% 
% Output:
%  no output variables
% 
% Output File:
%  data will be stored in a file named 'datafname'_D.mat and 'datafname'_V.mat in 
% 	the directory specified by 'path_to_file'\datafname_analysis\centroid_speed
% 
% Output file structure:
% 	fspeed (i,j) -- filtered centroid velocity at time i of trial j.
%   nfspeed (i,j) -- filtered and normalized centroid veloctiy at time i of trial j.
%   I(i) -- laser power of worm i.
%   headbend (i) -- the side where the head was bending to. (D: dorsal
%   side, V: ventral side)
% 
% Dependency:
% filter_function.m
% 
% (c) George Leung, Ilya Nemenman, Emory University, 2011-2013