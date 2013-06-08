function []=centroid_speed(path_to_file, datafname, framerate,filterlength)
% function []=centroid_speed(path_to_file, fname
% 
% The function calaculates the worm centroid speed from 
% centroid position data. HOW IS THIS CALCULATED?
% Input:
%  path_to_file -- path to the file with the centroid 
%	position data
%  fname -- filename of the centroid position data file,
%	extension '.mat' is assumed
% Input file structure:
%	......
%  We also need a additional input file 'fname'_notes.mat.
%	which is structured as:.....
% Output:
%  no output variables
% Output File:
%  data will be stored in a file named 'datafname'_CVel.mat in 
%	the directory specified by 'path_to_file'
% Output file structure:
% 	......
%
% (c) George Leung, Ilya Nemenman, Emory University, 2011-2013


%%%%%%%%%%%%%%%%%%
%%Settings

%%Settings end
%%%%%%%%%%%%%%%%%%

%


%load data 
load([path_to_file '\' datafname '.mat'])

%%%calculate centroid speed
for i = 1:length(data)
    
    %Calculate the speed by calculating the difference of centroid
    diff_t = zeros(size(data{i}.centroid,1)-1,2);
    for k = 1:size(data{i}.centroid,1)-1
        diff_t(k,:) = data{i}.centroid(k+1,:) - data{i}.centroid(k,:); 
    end
    speed(:,i) = sqrt(diff_t(:,1).^2 + diff_t(:,2).^2)./framerate;
    
    
    %find forward/backward direction
    %Calculate tail to head vector
    %x direction of the tail to head vector      
    thvector(:,1) = data{i}.wormskelx(:,1) - data{i}.wormskelx(:,end);
    %y direction of the tail to head vector   
    thvector(:,2) = data{i}.wormskely(:,1) - data{i}.wormskely(:,end);
         
         for j = 1:size(data{i}.centroid,1)-1
           %Calculate the dot product of velocity and thvector
            dirvec(j) = dot(diff_t(j,:),thvector(j,:));
            
            %set the speed to negative if the dot product is negative
           if dirvec(j) < 0
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
%Changing folder and make one if the folder does not exist

filepathname = [path_to_file '\' datafname '_analysis\centroid_speed'];
try
    mkdir(filepathname)
end

%saving data
save([filepathname '\' datafname(1:end-5) '_speed'],'fspeed','nfspeed','I')

end
