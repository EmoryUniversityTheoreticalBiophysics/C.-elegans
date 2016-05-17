
%This is an example of building the model from control centroid speed dataset and
%calcualte the posterior probability of laser current of the target centroid speed dataset.
% (c) George Laung and Ilya Nemenman


%Preparaing the data
%rescaling_func defines the rescaling function of the active centroid
%speed.
rescaling_func = @(I,I1) I1(1)+((I)./(1+(I/I1(2)))); 

%In the example dataset, only time from 60th frame (1s) to 200th frame is
%used.
range_speed = [60 200];

%Centroid speed is undersampled by usratio.
usratio = 5;
speedtimelist = round(linspace(range_speed(1),range_speed(2),(range_speed(2)-range_speed(1)+1)/usratio));
%%%%

%loading the model dataset
%fspeed : smoothed centroid velocity of control dataset
%I : corresponding laser current
load('control_oct_data.mat')
model_speed = fspeed(speedtimelist,:);
model_I = I;

%calculating the pause index of the model dataset
%1 = pause state, 0 = active state
model_S = gopause(model_speed);

%loading the target dataset
%fspeed : smoothed centroid velocity of ibuprofen dataset
%I : corresponding laser current
load('ibuprofen_data.mat')
target_speed = fspeed(speedtimelist,:);
target_I = I;

%%Predicting the probabilities of laser current of the target data set
[prob_target_I,I0,I1,ugt_c,sigmagt_c,upt_c,sigmapt_c] = P_Ipred_multi(model_I,model_S,model_speed,[1 200],target_speed,rescaling_func,[40 40]);
%  I0 and I1 -- parameters of the model
%  prob_target_I -- Probabilities of laser current I given the speed profile (1:maxI
%  x worms)
%  ugt -- average of the go worm speed (1 x time)
%  sigmagt -- variance of the go worm speed (1 x time)
%  upt -- average of the paused worm speed (1 x time)
%  sigmapt -- variance of the paused worm speed (1 x time)
