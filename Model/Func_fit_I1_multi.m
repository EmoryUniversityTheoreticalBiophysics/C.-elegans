
function [I1_opt, fval]=Func_fit_I1_multi(model_speed_go,model_I_go,factor1,init_val) 
% This function fits parameters of the model to the data. For multivariate gaussian
% model.

% Input:
%   model_speed_go -- velocity data of go worms to be used (times x worms); 
%       note that at this point the time slices not used in the 
%       optimization and all the paused worms must have
%       already been removed (time x Nworms)
%   model_I_go -- laser power for the go worms (1 x Nworms)
%   factor1 -- the model that should collapse the data
%   init_val -- initial values of the parameters for the optimization
% Output:
%   I1 -- best fitted parameter values I1 for the model
%   fval -- the minimized function value
%
%(c) George Leung and Ilya Nemenman

% Verified 06/12/2014


%%%Use MATLAB fminsearh
% setting optimization parameters
opts2 = optimset('UseParallel','always');

% finding the best parameter values 
[I1_opt,fval] = fminsearch(@(I1)Prob_calc_go_multi(I1,model_I_go,model_speed_go,factor1),init_val,opts2);



%%%%%%%%%
% 
% %%%Use R optimization algorithm
%     save('/Users/kleung4/Dropbox/Ilya/Worm_Pain/Data_Ayalsis/data_multi_gaussain/Para_var/Temp/temp.mat','model_speed_go','model_I_go','init_val')
%     executed = system('"/usr/bin/Rscript" "/Users/kleung4/Dropbox/GitHub/C.-elegans/multivariate_gaussian_model/CovEstimator/Func_fit_I1_multi_R.R"');
%     
% % %%%


% % %%%Debug
% [mlogP,mlogPlist,sigmagt_opt]=Prob_calc_go_multi(I1_opt,model_I_go,model_speed_go,factor1);
% 
% for i = 1:200
%     mlogP_I12map(i) = Prob_calc_go_multi([-4.7 i],model_I_go,model_speed_go,factor1);
% end
% figure
% plot(mlogP_I12map)
% 
% for j= 1:200
%     for i = 1:210
%         mlogP_allmap(i,j) = Prob_calc_go_multi([i j],model_I_go,model_speed_go,factor1);
%     end
% end
% figure
% surf(mlogP_allmap)
% shading flat
% xlabel('I1(2)')
% ylabel('I1(1)')

end