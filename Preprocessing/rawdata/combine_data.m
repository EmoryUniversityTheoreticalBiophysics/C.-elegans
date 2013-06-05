%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Load raw data into one file 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

%Get the path of origional folder
orgfolder = pwd;

%Path of folder containing all the rawdata
rawdatapath = 'D:\Ilya\FEBMAR_DATA\DATA';

%load the IBUPROFEN data 
cd(rawdatapath)
cd('.\IBUPROFENalldata')
filelist = dir;
for i = 1:length(filelist)-2
    data_IBUPROFEN{i} = load(filelist(i+2).name);
    filename2_IBUPROFEN{i} = filelist(i+2).name;
end
cd('..')

%load the centroids of IBUPROFEN data
cd('.\IBUPROFENcentroids')
filelist = dir;
for i = 1:length(filelist)-2
    data_IBUPROFEN{i}.centroid = load(filelist(i+2).name);
end
cd('..')

%load the Control data
cd('.\RANDOMPOWER_CTRLalldata')
filelist = dir;
for i = 1:length(filelist)-2
    data_ctrl{i} = load(filelist(i+2).name);
    filename2_ctrl{i} = filelist(i+2).name;
end
cd('..')

%load the centroids of Control data
cd('.\RANDOMPOWER_CTRLcentroids')
filelist = dir;
for i = 1:length(filelist)-2
    data_ctrl{i}.centroid = load(filelist(i+2).name);
end
cd('..')


%%%Saving the data into one file
cd(orgfolder)
save data_IBUPROFEN  data_IBUPROFEN filename2_IBUPROFEN
save data_ctrl  data_ctrl filename2_ctrl
