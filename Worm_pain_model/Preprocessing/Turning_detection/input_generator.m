%Prepare input for interactive plot

clear all
orgpath = pwd;

%%%%%%%%%%%%%%%%%%%%%%%%%
%%Settings
%path of the combined data
datapath = 'D:\Dropbox\Ilya\Worm_Pain\Data_Ayalsis\3rd_data_analysis\Preprocessing';
%data filename
datafilename = 'data_ctrl.mat';
%name of data variable
datavarname = 'data_ctrl';
%%%Settings end
%%%%%%%%%%%%%%%%%%%%%%%%%%

%load the data
cd(datapath)
load(datavarname)
load(['note' datavarname(end-4:end)])

filename = eval(['filename' datavarname(5:end)]);

data = eval(datavarname);
clear(datavarname);

for i =1:length(data)
    wormskelx(:,:,i) = data{i}.wormskelx;
    wormskely(:,:,i) = data{i}.wormskely;
    skelcurv(:,:,i) = data{i}.skelcurv2;
    
    
%     %calculate curvature (not finished)
%     for j = 1:size(wormskelx(:,:,i),1)
%         x = wormskelx(:,:,i);
%         y = wormskely(:,:,i);
%         dx = gradient(x);
%         dy = gradient(y);
%         curv = gradient(atan2(dy,dx)) ./ hypot(dx,dy);
%     end
end

%save the data
cd(orgpath)
% save input_ctrl filename wormskelx wormskely I_ctrl skelcurv









