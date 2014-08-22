
function []=sig_trans2var(speedfpath, speedfname,transcoeff)

% This function transform the laser power by tanh(transcoeff(1).*(I-transcoeff(2)))
% Transcoeff: [0.003159731128368,-52.415061370385980] for slope = 1


load([speedfpath '\' speedfname '.mat']) 

tranI = tanh(transcoeff(1).*(I-transcoeff(2)));


figure()
plot(I,tranI,'.');
ylabel('Transformed laser power')
xlabel('Original laser power')

oldI = I;
I = tranI;

save([speedfpath '\' speedfname '_sigtran'],'fspeed','nfspeed','I','oldI')

end