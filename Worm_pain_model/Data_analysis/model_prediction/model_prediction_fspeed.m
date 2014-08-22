
function []=model_prediction_fpseed(speeddatapath, speedfilename,modeldatapath, modeldataname)

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

%delete any data with laser power <1
nfspeed(:,I<1) = [];
fspeed(:,I<1) = [];
I(I<1) = [];

%Making prediction from modeL
predres.predI = fspeed'*LASSOresult(:,maxpos) + a0(maxpos);
predres.I = I;



%Calculate R-square of Prediction data
predres.Rsqaure = 1 - (sum((predres.predI - I').^2)/sum((mean(I) - I).^2));
Rsqaure = predres.Rsqaure

%calculate p-value using F-test
p = nzero(maxpos);
n = length(I);
Fvalue = ((n-p)*sum((mean(I) - I).^2))/((p-1)*sum((predres.predI - I').^2));
pvalue = 1 - fcdf(double(Fvalue),double(nzero(maxpos)-1),double(length(I)-nzero(maxpos)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot Predicted and raw data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Plot actual vs pred
% figure()
% plot(predres.predI,I,'.')
% title(['Predicting ' speedfilename ' with model ' modeldataname])
% xlabel('predres.predIcted laser power')
% ylabel('Actual laser power')
% 
% %adding lienar regressed line to the plot
% fit1 = polyfit(predres.predI,predres.I',1);
% predres.fit1 = fit1(1)*predres.predI+fit1(2);
% hold on;
% plot(predres.predI,predres.fit1,'r-.');
% text(3,5,['y=' num2str(fit1(1),3) 'x+' num2str(fit1(2),3)])

if not(isempty(strfind(modeldataname,'logI')))
    %logI transformation
    %Plot pred vs actual from 1-100 in log scale
    figure()
    plot(I(find(exp(I)<100)),predres.predI(find(exp(I)<100)),'.')
    title(['Predicting ' speedfilename ' with model ' modeldataname])
    ylabel('Predicted laser power (log scale)')
    xlabel('Actual laser power (log scale)')


    %Plot pred vs actual from 1-100 in actual scale
    figure()
    plot(exp(I(find(exp(I)<100))),exp(predres.predI(find(exp(I)<100))),'.')
    title(['Predicting ' speedfilename ' with model ' modeldataname])
    ylabel('Predicted laser power (actual scale)')
    xlabel('Actual laser power (actual scale)')

else
    if not(isempty(strfind(modeldataname,'linear')))
    %linear transform
    %Plot pred vs actual from 1-100 in actual scale
    figure()
    plot(I(I<100),predres.predI(I<100),'.')
    title(['Predicting ' speedfilename ' with model ' modeldataname])
    ylabel('Predicted laser power')
    xlabel('Actual laser power')

    end
end



%adding lienar regressed line to the plot
fit2 = polyfit(predres.I',predres.predI,1);
predres.fit2 = fit2(1)*predres.I'+fit2(2);
% hold on;
% plot(predres.I',predres.fit2,'r-.');
% % text(3,5,['y=' num2str(fit2(1),3) 'x+' num2str(fit2(2),3)])


% 
% %Plot predres.predIcted and raw data for I < 100
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

predres.residual =  predres.I' - predres.predI;

figure()
plot(predres.I,(predres.residual),'.')
ylabel('prediction residual ')
xlabel('Actual laser power')



figure()
hist(predres.residual)
ylabel('Count')
xlabel('Prediction residual')
title(['Histogram of prediction residual' ' (skewness =' num2str(skewness(predres.residual),2) 'mean = ' num2str(mean(predres.residual),2) ')'])

c2 = sum(predres.residual.*predres.I')
predres.c2 = c2;

%%%%%%%%%%%%%%%%%%%%

mkdir([modeldatapath '\prediction\' modeldataname]);

save([modeldatapath '\prediction\' modeldataname '\' speedfilename '_prediction.mat'], 'predres');


predI = predres.predI;
save([modeldatapath '\prediction\' modeldataname '\' speedfilename '_shortprediction.mat'], 'predI', 'I');

end
