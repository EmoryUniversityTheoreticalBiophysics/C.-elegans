%%%calculate centroid speed
clear all

%%%%%%%%%%%%%%%%%%
%%Settings

%path of data.mat and note.mat
datapath = 'D:\Dropbox\Ilya\Worm_Pain\Data_Ayalsis\3rd_data_analysis\Preprocessing';
%name of data file
dataname = 'data_ctrl.mat';
%name of note file
notename = 'note_ctrl.mat';
%name of data variable
datavarname = 'data_ctrl';

%%Settings end
%%%%%%%%%%%%%%%%%%


%%Main program


orgpath = pwd;




%load data 
cd(datapath)
load(dataname)
load(notename)


data = eval(datavarname);
clear(datavarname)

cd(orgpath)%%%calculate centroid speed
for i = 1:length(data)
    
    %extract the centroid
    for j = 1:length(data{1}.wormskelx)
            centroid{i}(j,:) = data{i}.centroid.wormcentroid(j).c2.Centroid;
    end
    
    %find speed
    diff_t = zeros(length(data{i}.centroid.wormcentroid)-1,2);
    for k = 1:length(data{i}.centroid.wormcentroid)-1
        diff_t(k,:) = centroid{i}(k+1,:) - centroid{i}(k,:); 
    end
        
    speed(:,i) = sqrt(diff_t(:,1).^2 + diff_t(:,2).^2);
    
    
    %%find forward/backward direction
     %Calculate tail to head vector
         thvector(:,1) = data{i}.wormskelx(:,1) - data{i}.wormskelx(:,end);
         thvector(:,2) = data{i}.wormskely(:,1) - data{i}.wormskely(:,end);
         
         allthvector{i} = thvector;
         
         for j = 1:length(data{i}.centroid.wormcentroid)-1
           %Calculate the dot product of velocity and thvector
            dirvec(j) = dot(diff_t(j,:),thvector(j,:));
            
            %set the speed to negative if the dot product is negative
           if dirvec(j) < 0
               speed(j,i) = -speed(j,i);
           end
         end
    
    %filter the speed with a Gaussian filter
    speed_f(:,i) = filter_function(speed(:,i),30);
    
end



%%Normalization of speed
%%calculate mean speed and SD of different time
meanspeed = mean(speed_f,2);
for i = 1:size(speed_f,1)
    SD(i) = sqrt(var(speed_f(i,:)));
end        
SD = SD';

%normalize by x - mean / sigma
for i = 1:size(speed_f,2)
    nfspeed_f(:,i) =  (speed_f(:,i) - meanspeed)./SD;
end        



%%Saving the data in to speed_*.mat file
%% speed : not normalized speed
%% nfspeed : normalized speed

%For control data
speed_ctrl = speed_f;
nfspeed_ctrl = nfspeed_f;
save speed_ctrl nfspeed_ctrl speed_ctrl I_ctrl

% %For IBUPROFEN data
% speed_IBUPROFEN = speed_f;
% nfspeed_IBUPROFEN = nfspeed_f;
% save speed_IBUPROFEN nfspeed_IBUPROFEN speed_IBUPROFEN I_IBUPROFEN

% %For 2nd data
% speed_2nd = speed_f;
% nfspeed_2nd = nfspeed_f;
% save speed_2nd nfspeed_2nd speed_2nd I_2nd
