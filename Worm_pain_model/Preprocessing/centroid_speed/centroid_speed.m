function []=centroid_speed(path_to_file, datafname, framerate,filterlength)
% function []=centroid_speed(path_to_file, datafname, framerate,filterlength)
% 
% This function calaculates the worm centroid speed in pixels/s from 
% centroid position data. The centroid speed of time t is calculated by calculating
% the difference between time t+1 and time t, then multiply it by
% framerate. Finally the speed is smoothed by a moving gaussian filter.
% 
% Input:
%  path_to_file -- path to the file with the centroid 
% 	position data
%  datafname -- filename of the centroid position data file,
% 	extension '.mat' is assumed
%  framerate -- framerate of the data
%  filterlength -- size of the window of the gaussian filter
% 
% Input file structure:
%   data{k} -- cell array of trial k containing:
%       centroid (i,j) -- Centroid position of the worm. i represents time and j represents x (j = 1) and y (j = 2) coordinates. 
%   I(i) -- laser power of worm i
% 
% Output:
%  no output variables
% 
% Output File:
%  data will be stored in a file named 'datafname'_CVel.mat in 
% 	the directory specified by 'path_to_file'\datafname_analysis\centroid_speed
% 
% Output file structure:
% 	fspeed (i,j) -- filtered centroid velocity at time i of trial j.
%   nfspeed (i,j) -- filtered and normalized centroid veloctiy at time i of trial j.
%   I(i) -- laser power of worm i.
% 
% Dependency:
% filter_function.m
% 
% (c) George Leung, Ilya Nemenman, Emory University, 2011-2013


%load data 
load([path_to_file '\' datafname '.mat'])

%%%calculate centroid speed
for i = 1:length(data)
    
    %Calculate the speed by calculating the difference of centroid
    diff_t = zeros(size(data{i}.centroid,1)-1,2);
    for k = 1:size(data{i}.centroid,1)-1
        diff_t(k,:) = data{i}.centroid(k+1,:) - data{i}.centroid(k,:); 
    end
    speed(:,i) = sqrt(diff_t(:,1).^2 + diff_t(:,2).^2).*framerate;
    
    
    %find forward/backward direction
    %Calculate tail to head vector
    %x direction of the tail to head vector      
    thvector(:,1) = data{i}.wormskelx(:,1) - data{i}.wormskelx(:,end);
    %y direction of the tail to head vector   
    thvector(:,2) = data{i}.wormskely(:,1) - data{i}.wormskely(:,end);
    
     allthvector{i} = thvector;
         
         for j = 1:size(data{i}.centroid,1)-1
           %Calculate the dot product of velocity and thvector
            dirvec(j,i) = dot(diff_t(j,:),thvector(j,:));
            
            %set the speed to negative if the dot product is negative
           if dirvec(j,i) < 0
               speed(j,i) = -speed(j,i);
           end
         end
    
    %filter the speed with a Gaussian filter
    fspeed(:,i) = filter_function(speed(:,i),filterlength);
    
end



%%Normalization of speed
%%calculate mean speed and SD of different time
meanspeed = mean(fspeed,2);
for i = 1:size(fspeed,1)
    SD(i) = sqrt(var(fspeed(i,:)));
end        
SD = SD';

%normalize by x - mean / sigma
for i = 1:size(fspeed,2)
    nfspeed(:,i) =  (fspeed(:,i) - meanspeed)./SD;
end        



%Save data in the folder path_to_file\datafname_analysis\centroid_speed
%make one if the folder does not exist

filepathname = [path_to_file '\' datafname '_analysis\centroid_speed'];
mkdir(filepathname)


%saving data
save([filepathname '\' datafname '_CVel'],'fspeed','nfspeed','I')

end
