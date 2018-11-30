

function []=nonlinear(speeddatapath, datafilename,maxspeeddatapath,maxspeedfilename)
% function []=nonlinear(speeddatapath, datafilename,maxspeeddatapath,maxspeedfilename)
% 
% This function will apply nonlinear transform to laser power by fitting a
% exponential curve to the maximum centroid speed verse laser power data. 
% 
% Input:
%  speeddatapath -- path to the file with the centroid velocity data
%  datafilename -- filename of the centroid velocity data file,
% 	extension '.mat' is assumed
%  maxspeeddatapath -- path to the file with the maximum centroid velocity data
%  maxspeedfilename -- filename of the maximum centroid velocity data file,
% 	extension '.mat' is assumed
% 
% Input file structure:
% centroid velocity data:
% 	fspeed (i,j) -- filtered centroid velocity at time i of trial j.
%   nfspeed (i,j) -- filtered and normalized centroid veloctiy at time i of trial j.
%   I(i) -- laser power of worm i.
% maximum centroid velocity data:
%   avgmaxspeed(k) -- average maximum backward velocity of group k.
%   I_avgmaxspeed(k) -- laser power of group k.
% 
% Output:
%  no output variables
% 
% Output File:
% Transformed laser power data will be stored with centroid speed data in
% the path specified by 'speeddatapath'.
% 
% Output file structure:
% 	fspeed (i,j) -- filtered centroid velocity at time i of trial j.
%   nfspeed (i,j) -- filtered and normalized centroid veloctiy at time i of trial j.
%   I(i) -- Transformed laser power of worm i.
% 
% 
% (c) George Leung, Ilya Nemenman, Emory University, 2011-2013

%load data
load([speeddatapath '/' datafilename '.mat'])
load([maxspeeddatapath '/' maxspeedfilename '.mat'])

%rescaling of the maximum speed such that the range of laser power are roughly the
%same
tavgmaxspeed = (I_avgmaxspeed(end))/(avgmaxspeed(end))*avgmaxspeed;

%fitting a double exponential curve 
I_avgmaxspeed(find(isnan(tavgmaxspeed))) = [];
tavgmaxspeed(find(isnan(tavgmaxspeed))) = [];
curve = fit(I_avgmaxspeed', tavgmaxspeed',  'exp2');

%plot the curve
figure(1)
plot(curve)
hold 
plot( I_avgmaxspeed',tavgmaxspeed','.')
title(datafilename)
ylabel('Transformed Laser power')
xlabel('Original Laser power')
hold
%transform the laser power
I= curve(I)';


%%%saving data to the same folder 
save([speeddatapath '\' datafilename '_nonlinear.mat'], 'I','fspeed','nfspeed','curve')

end






