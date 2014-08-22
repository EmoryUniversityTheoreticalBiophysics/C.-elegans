
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

if size(nfspeed,1) == 959
    for i = 1:479
        tempspeed(i,:) = (nfspeed((2*i)-1,:)+nfspeed((2*i),:))/2;
    end
    nfspeed = tempspeed;
end
if size(nfspeed,1) ~= size(LASSOresult,2)
    nfspeed = nfspeed';
end


%Making prediction from model
predres.predI = nfspeed*LASSOresult(:,maxpos) + a0(maxpos);
predres.I = I;

if size(I,1) ~= size(predres.predI,1)
    predres.I = predres.I';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot Predicted and raw data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
predres.I = exp(predres.I);
predres.predI = exp(predres.predI);

figure()
plot(predres.predI,predres.I,'.')
title(['Predicting ' speedfilename ' with model ' modeldataname])
xlabel('Predicted laser power')
ylabel('Actual laser power')

display(' ')
display('Actual vs Pred')
polyfit(predres.predI,predres.I,1)

display('Pred vs Actual')
polyfit(predres.I,predres.predI,1)


%Calculate R-square of Prediction data
predres.Rsqaure = 1 - (sum((predres.predI - predres.I).^2)/sum((mean(predres.I) - predres.I).^2));
Rsqaure = predres.Rsqaure;


%calculate the residual of the regression
predres.residual =  predres.I - predres.predI;

% figure()
% plot(predres.I,(predres.residual),'.')
% ylabel('prediction residual ')
% xlabel('Actual laser power')


% 
% figure()
% hist(predres.residual)
% ylabel('Count')
% xlabel('Prediction residual')
% title(['Histogram of prediction residual' ' (skewness =' num2str(skewness(predres.residual),2) 'mean = ' num2str(mean(predres.residual),2) ')'])

c2 = sum(predres.residual.*predres.I);
predres.c2 = c2;

%%%%%%%%%%%%%%%%%%%%

mkdir([modeldatapath '\prediction\' modeldataname]);

save([modeldatapath '\prediction\' modeldataname '\' speedfilename '_prediction.mat'], 'predres');

predI = predres.predI;
save([modeldatapath '\prediction\' modeldataname '\' speedfilename '_shortprediction.mat'], 'predI', 'I');

end
