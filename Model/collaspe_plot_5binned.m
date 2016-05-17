function [ratiodata ,ratiodata2 ,collapse_v, collapse_SD ,uncollapse_v ,uncollapse_SD ,meanI ,totalvar,explainable_var] = collaspe_plot_sim(speed,I,I1,S)
% Calculate the reduction of variance by averaging the data to 5 bins.
% Multivariate gaussian model.
%
% Input:
%   fspeed -- smoothed speed profile of the worm (time x nworms)
%   I1 -- parameters of the model (go velocity rescaling) (1 x 2)
%   I -- laser power (1 x worms)
%   S -- boolean index representing go or paused worms. Pause = 1 and go = 0. (1 x worms)
% Output:
%   ratiodata -- residual variance ratio
%   ratiodata2 -- explainable variance ratio
%   collaspe_v -- Collapsed velocity (v/f(I))
%   gowormvar -- total variance of the velocity profile of go worms
%   uncollaspe_v - velocity of go worms 

%(c) George Leung and Ilya Nemenman



% anonymous function defining the rescaling model
factor1 = @(I,I1) I1(1)+((I)./(1+(I/I1(2)))); 

% Select the moving worms only
% S = gopause(fspeed);
speed_go = speed(:,~S);  
I_go = I(~S);  

factor1val = factor1(I_go,I1);

% Bin the data
nbins = 5;
[bin_num ,meanI ,~]=data_bin(I_go, nbins);



% Plotting the variance ratio after collaspe
[ugt_plot,~]=calc_go_profile_multi(I_go,speed_go,factor1,I1);


diff_vel = speed_go - (ugt_plot*factor1val);  % time x worms, difference between the actual velocity and the apropriately rescaled  template

%%calculate collasped and uncollapsed speed and SD
factor1val= ones(size(speed_go,1),1)*factor1(I_go,I1);
collaspe_vall = speed_go./factor1val;


for i = 1:nbins
    mean_speed_go(:,i) = mean(speed_go(:,bin_num==i),2);
    mean_diffvel(:,i) = mean(diff_vel(:,bin_num==i),2);
    collapse_v(:,i) = mean(collaspe_vall(:,bin_num==i),2);
    collapse_SD(:,i) = std(collaspe_vall(:,bin_num==i),0,2);
    uncollapse_SD(:,i) = std(speed_go(:,bin_num==i),0,2);
    uncollapse_v(:,i) = mean_speed_go(:,i);
end

ratiodata = var(mean_diffvel,0,2)./var(mean_speed_go,0,2);
ratiodata2 = var(mean_speed_go,0,2)./var(speed_go,0,2);
totalvar = var(speed_go,0,2);
explainable_var = var(mean_speed_go,0,2);
% ratiodata3 = var(diff_vel,0,2)./var(speed_go,0,2);



end