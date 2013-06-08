function []=combine_data(path_to_file, picfname,alldatafname,centroidfname)

% function []=combine_data(path_to_file, picfname,alldatafname,centroidfname)
% 
% The function load centroid, skeleton, curvature, laser power, 
% laser position, crawling side and filename data from experiment results 
% and combine them into one file. 
% 
% Input:
%  path_to_file -- path to the folder which contain experiment data
%  alldatafname -- name of the folder which contain *_analysis data 
%  centroidfname -- name of the folder which contain *_centroid data
%  picfname -- name of the folder which contain pictures from the
%  experiment
% 
% Output:
%  no output variables
% 
% Output File:
%  data will be stored in a file named 'picfname'_data.mat in 
% 	the directory specified by 'path_to_file'
% 
% Output file structure:
% xpos -- x position of laser of trial i
% ypos -- y position of laser of trial i
% data --
%  wormskelx -- x position of worm skeleton in <time * position>. Head is
%  represented by position 1 and tail is represented by position 41.
%  wormskely -- y position of worms keleton in <time * position>. 
%  skelcurv2 -- curvature of worm skeleton in <time * position>. Head is
%  represented by position 1 and tail is represented by position 37.
%  numberofframes -- total number of frames in the video.
%  centroid.wormcentroid.c2.Centroid -- Centroid position of the worm
% I -- laser power of worm i
% side -- side of the worm crawl on
%  R: the worm was crawling on the right side
%  L: the worm was crawling on the left side
%  N: crawling side not recorded 
% 
% (c) George Leung, Ilya Nemenman, Emory University, 2011-2013


%load the *_analysis data
cd(path_to_file)
cd(alldatafname)
filelist = dir;
for i = 1:length(filelist)-2
    data{i} = load(filelist(i+2).name,'wormskelx','wormskely','skelcurv2','numberofframes2');
    filename{i} = filelist(i+2).name;
end

%load the *_centroid data
cd(path_to_file)
cd(centroidfname)
filelist = dir;
for i = 1:length(filelist)-2
    tempdata = load(filelist(i+2).name);
    for j = 1:length(data{i}.wormskelx)
        data{i}.centroid(j,:) = tempdata.wormcentroid(j).c2.Centroid;
    end
end

%load the note.txt into one file
cd(path_to_file)
cd(picfname)
filelist = dir;
for i = 1:length(filelist)-2
    %opening notes.txt
    cd(filelist(i+2).name)
    tempfile = fopen('notes.txt');
    for j = 1:5
        line{j} = fgets(tempfile);
    end
    fclose(tempfile);
    
    %read in Laser power 
    I(i) = str2num(line{4}(strfind(line{4}, '(mA):')+5 : end))*0.32;
    %read in x position of Laser power 
    xpos(i) = str2num(line{5}(strfind(line{5}, 'x:')+2 : strfind(line{5}, 'y:')-1));
    %read in y position of Laser power 
    ypos(i) = str2num(line{5}(strfind(line{5}, 'y:')+2 : end));
    %read in filename of Laser power 
    filename{i} = filelist(i+2).name;
    
    
    % Read in the side of the worm
    if filelist(i+2).name(end-6) == 'R'
        side{i} = 'R';
    else
        if filelist(i+2).name(end-6) == 'L'
            side{i} = 'L';
        else
            side{i} = 'N';
        end
    end
    cd ..
end 



%%%Saving the data into one file
cd(path_to_file)
savefilename = [picfname '_data'];
save(savefilename,'data','filename','I','xpos','ypos','filename','side')
