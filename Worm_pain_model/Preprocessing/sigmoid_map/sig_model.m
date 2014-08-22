
function []=sig_model(speedfpath, speedfname,featurefname)

% This function Create model for sigmoid transform by fitting a tanh curve to the
% max speed vs laser power plot

    load([speedfpath '\' featurefname '.mat'])
    load([speedfpath '\' speedfname '.mat'])
    
    
    [fitresult gof] = tanhfit(featuredata.I,featuredata.maxspeed);

    tranI = fitresult(I);
    scalefactor = sqrt(var(I))/sqrt(var(tranI));
    
    save([speedfpath '\' speedfname '_sigmodel'],'fitresult','gof','scalefactor')
end