
function [] = IpvsIa_bootstrap(Iact,speedact,testfname,max_pred_I,modelfname)
% Calculate the predicted laser power vs actual laser power with
% bootstrapped model
% Input:
%   Iact -- Actual laser power of the worms. Read from file testfname if input argument equals to []. (1 x nworms)
%   speedact -- speed profile of the worm for prediction. Read from file testfname if input argument equals to []. (time x nworms)
%   testfname -- file name of test data
%   max_pred_I -- max_pred_Imum range of the current used in experiments (single integer)
%   modelfname -- file name of model data
% 
% Output:
%   A data file saved at the same folder with the name "IpvsIa_ testfname
%   _ modelfname" containing the value of:
%   prob -- the probability distribution P(I|speed) of each worm (200 x
%   number of worms)
%   p_avg -- the equally sampled binned probability distribution P(I|speed) (5*number of worms)
%   Iact -- Actual laser power of the worms. Read from file testfname if input argument equals to []. (1 x nworms)
%   speedact -- speed profile of the worm for prediction. Read from file testfname if input argument equals to []. (time x nworms)
%   I0 -- Parameter of the model of all resampled data (1 x
%   numboot)
%   I1 -- Parameter of the model of all resampled data (2 x
%   numboot)
%   ugt_full -- average of the go worm speed (numboot x time)
%   sigmagt_full -- variance of the go worm speed (numboot x time)
%   upt_full -- average of the paused worm speed (numboot x time)
%   sigmapt_full -- variance of the paused worm speed (numboot x time)
%   pscale -- rescaling factor of go worms

% (c) George Laung and Ilya Nemenman

% Number of bins in the avg_prob_map 
nbins = 5;

% the hack to deal with corelations in the data; should be about equal
% to the data correlation time
pscale = 1;

% anonymous function defining the rescaling model
factor1 = @(I,I1) I1(1)+((I)./(1+(I/I1(2)))); 

% Read the model data
load(modelfname,'I0','I1','sigmagt_full','sigmapt_full','upt_full','ugt_full','pscale','timerange','selectindex');

% Read from file fname if this speed or fspeed is empty.
if isempty(speedact)  || isempty(Iact)
    %data from the file:
    %  I -- laser power of the worms. Read from file fname if this argument is empty. (1 x Nworms)
    %  speed -- velocity profile of the worm. Read from file fname if this argument is empty. (time x nworms) 
    %  fspeed -- filtered (smoothed) velocity profile of the worm. Read from file fname if this argument is empty. (time x nworms)
    load(testfname);
    speedact = speed;
    Iact = I;
else
    testfname = '[]';
end



% Select data within the time range
speedact = speedact(timerange(1):timerange(2),:);

% define the range of predicted I; this should be the same as the range
% of I used in the experiments
predI = 1:max_pred_I;

prob = zeros(max_pred_I,length(Iact)); %probability of laser power i of worm j (i x j)

for k = 1:size(selectindex,1) %number of bootstrapping
    k
    for j = 1:length(Iact) %number of worms in prediction dataset
        probtemp = prob_I_givenspeed_v2(predI,speedact(:,j),sigmagt_full(k,:),ugt_full(k,:),sigmapt_full(k,:),upt_full(k,:),I0(k,:),I1(k,:),factor1,pscale)'; 
        prob_all{k}(j,:) = probtemp;
        prob(:,j) = prob(:,j) + probtemp;
    end
    
end

%Normalize the probability
prob = prob/size(selectindex,1);

%binning the data
[p_avg meanI] = prob_map(prob,Iact,nbins,testfname,[]);



datasavename =  ['IpvsIa_' testfname '_' modelfname];
save(datasavename,'prob','p_avg','Iact','speedact','I0','I1','sigmagt_full','sigmapt_full','upt_full','ugt_full','pscale','meanI')
save('prob_all','prob_all')

end