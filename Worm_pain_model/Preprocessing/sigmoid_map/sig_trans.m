
function []=sig_trans(speedfpath, speedfname,modelfpath,modelfname)

% This function transform the laser power by model created by create_model
%


load([modelfpath '\' modelfname '.mat'])
load([speedfpath '\' speedfname '.mat'])

tranI = fitresult(I);

tranI = tranI*scalefactor;

figure()
plot(I,tranI,'.');
ylabel('Transformed laser power')
xlabel('Original laser power')

oldI = I;
I = tranI';

save([speedfpath '\' speedfname '_sigtran'],'fspeed','nfspeed','I','oldI')
end