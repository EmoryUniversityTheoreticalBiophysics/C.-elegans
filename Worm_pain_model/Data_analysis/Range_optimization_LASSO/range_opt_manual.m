% Optimize the R-square by selecting different data manually
clear all
load('D:\Ilya\Control_Data\Control_data_analysis\centroid_speed\Control_data_CVel.mat')

cd D:\Dropbox\GitHub\C.-elegans\Worm_pain_model\Data_analysis\Range_optimization_LASSO

drangelist1 = [0 10 20 30 40 50 60 70 80 90 100]; %Laser power
drangelist2 = [10 0 -10 -20 -30 -40]; %Speed at t = 100

for i = 1:length(drangelist1)
    for j = 1:length(drangelist2)
        drange(1) = drangelist1(i);
        drange(2) = drangelist2(j);
        
        temp = range_lasso_manual(I,nfspeed,fspeed,drange,[0 1 1 0]);
        

        maxr2(i,j) = 1-temp; 
        
        display('Current')
        display(i)
        display(j)
    end
end

save RESULT_MAN



