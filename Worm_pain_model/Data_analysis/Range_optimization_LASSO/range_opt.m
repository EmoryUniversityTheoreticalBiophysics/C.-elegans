% Optimize the R-square by selecting different data
clear all
load('D:\Ilya\Control_Data\Control_data_analysis\centroid_speed\Control_data_CVel.mat')

cd D:\Dropbox\GitHub\C.-elegans\Worm_pain_model\Data_analysis\Range_optimization_LASSO

%Define the range that data are deleted
drange0(1) = 40;     %Laser power lower limit
drange0(2) = -10;    %Reverse speed upper limit

tic
opts = optimset('UseParallel','never', 'MaxIter', 300,'Display','iter');
[fbest,fval,exitflag,output] = fminsearch(@(drange)range_lasso_optR2(I,nfspeed,fspeed,drange),drange0(1:2),opts);
toc

save RESULT