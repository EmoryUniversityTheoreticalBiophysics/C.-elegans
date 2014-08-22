% Optimize the sigmoid fit by R-square of LASSO
clear all
% load('D:\Ilya\Control_Data\Control_data_analysis\centroid_speed\Control_data_CVel.mat')

load('D:\Ilya\Control_Data\Control_data_analysis\centroid_speed\Control_data_CVel_R100.mat')
% 
% load('D:\Ilya\AUG_DATA\randompower_data_analysis\centroid_speed\randompower_data_CVel.mat')


cd D:\Dropbox\GitHub\C.-elegans\Worm_pain_model\Data_analysis\Sigmoid_Optmiziation_LASSO



% %%%%%%%%%%%%%%%%%%%%%%%%
% %%%fitting tanh 2 variables
% %%%%%%%%%%%%%%%%%%%%%%%%
% maxspeed = featuredata.maxspeed./max(featuredata.maxspeed);
% [fitresult2 gof2] = tanhfit2(featuredata.I,maxspeed);
% transcoeff0(1) = fitresult2.b;
% transcoeff0(2) = fitresult2.c;

%%%new fit
transcoeff0(1) = 6;
transcoeff0(2) = 30;
transcoeff0(3) = 55.03;
% Islope = lasso_opt(I,nfspeed,transcoeff0) 

tic
opts = optimset('UseParallel','never', 'MaxIter', 100,'Display','iter');
[fbest,fval,exitflag,output] = fminsearch(@(transcoeff)lasso_optR2(I,nfspeed,transcoeff,0),transcoeff0(1:2),opts);
% [fbest,fval,exitflag,output] = fminsearch(@(transcoeff)lasso_opt3varR2(I,nfspeed,transcoeff,0),transcoeff0,opts);
toc

save RESULT

%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%



% %%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%fitting 3 variables
% %%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %get initial fit of sigmoid function
% maxspeed = featuredata.maxspeed./max(featuredata.maxspeed);
% [fitresult gof] = tanhfit(featuredata.I,maxspeed);
% transcoeff0(1) = fitresult.b;
% transcoeff0(2) = fitresult.c;
% transcoeff0(3) = fitresult.a;
% 
% tic
% opts = optimset('UseParallel','always', 'MaxIter', 200,'Display','iter');
% [fbest,fval,exitflag,output] = fminsearch(@(transcoeff)lasso_opt3(I,nfspeed,transcoeff,0),transcoeff0,opts);
% toc
% 
% save RESULT
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%