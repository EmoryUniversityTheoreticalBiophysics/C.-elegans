%%%Calculate the change in direction during the response

clear all
orgpath = pwd;

%%%%%%%%%%%%%%%%%%%%%%%%%
%%Settings
%path of the combined data
datapath = 'D:\Dropbox\Ilya\Worm_Pain\Data_Ayalsis\3rd_data_analysis\Preprocessing';
%data filename
datafilename = 'data_IBUPROFEN.mat';
%name of data variable
datavarname = 'data_IBUPROFEN';
%%%Settings end
%%%%%%%%%%%%%%%%%%%%%%%%%%

%load data
cd(datapath)
load(datafilename)

data = eval(datavarname);
clear(datavarname);

cd(orgpath)
%calculate the change in direction during different time
for i = 1:length(data)
    
    %calculate tail to head vector
    head(:,1) = data{i}.wormskelx(:,1);
    tail(:,1) = data{i}.wormskelx(:,41);
    head(:,2) = data{i}.wormskely(:,1);
    tail(:,2) = data{i}.wormskely(:,41);
    thvector{i} = head - tail;
    
%   calculate initial vector 
    initvector = mean(thvector{i}(1:30,1:2));
    
%     calculate the change in direction
    for  k = 1:960
        angle_all(k,i) = angle_change(initvector,thvector{i}(k,1:2));
    end
end

%save data
save(['angle' datavarname(5:end)],'angle_all')