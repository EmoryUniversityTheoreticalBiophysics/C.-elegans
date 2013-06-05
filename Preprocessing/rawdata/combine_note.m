%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Load note.txt from raw data into one file 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

%Get the path of origional folder
orgfolder = pwd;

%Path of folder containing all the rawdata
rawdatapath = 'D:\Ilya\FEBMAR_DATA\DATA';

%load the note.txt into one file
cd(rawdatapath)
cd('.\RANDOMPOWER_CTRL')
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
    I_ctrl(i) = str2num(line{4}(strfind(line{4}, '(mA):')+5 : end))*0.32;
    %read in x position of Laser power 
    xpos_ctrl(i) = str2num(line{5}(strfind(line{5}, 'x:')+2 : strfind(line{5}, 'y:')-1));
    %read in y position of Laser power 
    ypos_ctrl(i) = str2num(line{5}(strfind(line{5}, 'y:')+2 : end));
    %read in filename of Laser power 
    filename_ctrl{i} = filelist(i+2).name;
    
    
    % Read in the side of the worm
    % R: the worm was crawling on the right side
    % L: the worm was crawling on the left side
    % N: side o
    if filelist(i+2).name(end-6) == 'R'
        side_ctrl{i} = 'R';
    else
        if filelist(i+2).name(end-6) == 'L'
            side_ctrl{i} = 'L';
        else
            side_ctrl{i} = 'N';
        end
    end
    
    
    cd ..
end 

%Read in IBUPROFEN data
cd ..
cd IBUPROFEN
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
    I_IBUPROFEN(i) = str2num(line{4}(strfind(line{4}, '(mA):')+5 : end))*0.32;
    %read in x position of Laser power 
    xpos_IBUPROFEN(i) = str2num(line{5}(strfind(line{5}, 'x:')+2 : strfind(line{5}, 'y:')-1));
    %read in y position of Laser power 
    ypos_IBUPROFEN(i) = str2num(line{5}(strfind(line{5}, 'y:')+2 : end));
    
    %read in filename of Laser power 
    filename_IBUPROFEN{i} = filelist(i+2).name;
        
    % Read in the side of the worm
    % R: the worm was crawling on the right side
    % L: the worm was crawling on the left side
    % N: side o
    if filelist(i+2).name(end-6) == 'R'
        side_IBUPROFEN{i} = 'R';
    else
        if filelist(i+2).name(end-6) == 'L'
            side_IBUPROFEN{i} = 'L';
        else
            side_IBUPROFEN{i} = 'N';
        end
    end
    
    cd ..
end 


%%%Saving the data into one file
cd(orgfolder)
save note_IBUPROFEN I_IBUPROFEN xpos_IBUPROFEN ypos_IBUPROFEN filename_IBUPROFEN side_IBUPROFEN
save note_ctrl I_ctrl xpos_ctrl ypos_ctrl filename_ctrl side_ctrl
