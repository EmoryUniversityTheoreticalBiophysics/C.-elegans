
function []=model_prediction_sig(speeddatapath, speedfilename,modeldatapath, modeldataname,transcoeff)

% function []= datafeature(speeddatapath, speedfilename,datapath, datafilename, framerate)
% 
% Read in LASSO results and predict laser power from speed data
% 
% Input:
%  speeddatapath -- path to the file with the centroid speed data
%  speedfilename -- filename of the centroid speed data file,
% 	datafilename '.mat' is assumed
%  modeldatapath -- path to the file with the model file
%  modeldatafilename -- filename of the model file,
% 	datafilename '.mat' is assumed
% 
% 
% Output:
%  no output variables
% 
% Output File:
% 
% 
% Output file structure:
% 
% (c) George Leung, Ilya Nemenman, Emory University, 2011-2013

%load data

load([modeldatapath '\' modeldataname '.mat'])
load([speeddatapath '\' speedfilename '.mat'])





[maxvalue maxpos] = max(r2cv);
predres.LASSOresult = LASSOresult;
predres.a0 = a0;
predres.nfspeed = nfspeed;
predres.fspeed = fspeed;


%Making prediction from model
predres.predI = nfspeed'*predres.LASSOresult(:,maxpos) + a0(maxpos);
predres.I = I;
if size(predres.I,1) ~= size(predres.predI,1)
    predres.I = predres.I';
end

%transforming the laser power back to normal scale
tranpredI = predres.predI;
tranI = predres.I;
predres.predI = (atanh(predres.predI)./transcoeff(1))+transcoeff(2);
predres.I = (atanh(predres.I)./transcoeff(1))+transcoeff(2);

%Fitting the prediction vs actual laser power graph
Ifit = polyfit(predres.I,predres.predI,1);
Ifit(1) 


%Calculate R-square of Prediction data
predres.Rsqaure = 1 - (sum((predres.predI - predres.I).^2)/sum((mean(predres.I) - predres.I).^2));
Rsqaure = predres.Rsqaure


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot Predicted and raw data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot transformed laser power vs pred laser power
figure()
plot(tranI,tranpredI,'.')
title(['Predicting ' speedfilename ' with model ' modeldataname])
ylabel('Predicted laser power (Transformed)')
xlabel('Actual laser power (Transformed)')

%Plot actual laser power vs pred laser power
figure()
plot(predres.I,predres.predI,'.')
title(['Predicting ' speedfilename ' with model ' modeldataname])
ylabel('Predicted laser power')
xlabel('Actual laser power')


% Plot laser power < 100
figure()
plot(predres.I(predres.I<100),predres.predI(predres.I<100),'.')
title(['Predicting ' speedfilename ' with model ' modeldataname ' (I<100)'])
ylabel('Predicted laser power')
xlabel('Actual laser power')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%calculate the residual of the regression
predres.residual =  predres.I - predres.predI;

figure()
plot(predres.I,(predres.residual),'.')
ylabel('prediction residual ')
xlabel('Actual laser power')

figure()
hist(predres.residual)
ylabel('Count')
xlabel('Prediction residual')
title(['Histogram of prediction residual' ' (skewness =' num2str(skewness(predres.residual),2) 'mean = ' num2str(mean(predres.residual),2) ')'])

c2 = sum(predres.residual.*predres.I);
predres.c2 = c2;

%%%%%%%%%%%%%%%%%%%%

mkdir([modeldatapath '\prediction\' modeldataname]);

save([modeldatapath '\prediction\' modeldataname '\' speedfilename '_prediction.mat'], 'predres');


predI = predres.predI;
save([modeldatapath '\prediction\' modeldataname '\' speedfilename '_shortprediction.mat'], 'predI', 'I');

end
