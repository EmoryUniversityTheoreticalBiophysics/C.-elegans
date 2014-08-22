
function []=model_prediction(speeddatapath, speedfilename,modeldatapath, modeldataname)

% function []= datafeature(speeddatapath, speedfilename,datapath, datafilename, framerate)
% 
% Read in LASSO results and predres.predIct laser power from speed data
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





% 
% %%%%%%%%%%%%%%%%%%
% % Alter the model
% %%%%%%%%%%%%%%%%%%
% alpha = 0.41;
% beta = 2.5;
% 
% LASSOresult = LASSOresult./alpha;
% 
% a0 = (a0 - beta)/alpha;
% %%%%%%END%%%%%%%%%


[maxvalue maxpos] = max(r2cv);
predres.LASSOresult = LASSOresult;
predres.a0 = a0;
predres.nfspeed = nfspeed;
predres.fspeed = fspeed;
% 
% %delete any data with laser power <1
% nfspeed(:,I<1) = [];
% fspeed(:,I<1) = [];
% I(I<1) = [];

%Making prediction from modeL
% predres.predI = fspeed'*LASSOresult(:,maxpos) + a0(maxpos);
predres.predI = nfspeed'*LASSOresult(:,maxpos) + a0(maxpos);
predres.I = I;

if size(I,1) ~= size(predres.predI,1)
    predres.I = predres.I';
end

%Calculate R-square of Prediction data
predres.Rsqaure = 1 - (sum((predres.predI - predres.I).^2)/sum((mean(predres.I) - predres.I).^2));
Rsqaure = predres.Rsqaure

%calculate p-value using F-test
p = nzero(maxpos);
n = length(I);
Fvalue = ((n-p)*sum((mean(I) - I).^2))/((p-1)*sum((predres.predI - predres.I).^2));
pvalue = 1 - fcdf(double(Fvalue),double(nzero(maxpos)-1),double(length(I)-nzero(maxpos)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot Predicted and raw data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot actual vs pred
figure()
plot(predres.predI,predres.I,'.')
title(['Predicting ' speedfilename ' with model ' modeldataname])
xlabel('Predicted laser power')
ylabel('Actual laser power')

%Plot pred vs actual
figure()
plot(predres.I,predres.predI,'.')
title(['Predicting ' speedfilename ' with model ' modeldataname])
xlabel('Predicted laser power')
ylabel('Actual laser power')

display(' ')
display('Actual vs Pred')
polyfit(predres.I,predres.predI,1)

display('Pred vs Actual')
polyfit(predres.predI,predres.I,1)


% %Plot predicted and actual data for I < 100
% threshold = 60;
% tI = I;
% tI(I>threshold) = [];
% tpred = predres.predI;
% tpred(I>threshold) = [];
% figure()
% plot(tpred,log(tI),'.')
% % title(['predres.predIcting ' speedfilename ' with model ' modeldataname])
% xlabel('predres.predIcted laser power')
% ylabel('Actual laser power')

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
