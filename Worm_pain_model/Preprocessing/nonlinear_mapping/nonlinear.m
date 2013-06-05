%%nonlinear mapping of the laser power according to maximum speed
clear all
orgpath = pwd;


%%%%%%%%%%%%%%%%%%%%%%%%%
%%Settings
%path of the centroid speed data
speeddatapath = 'D:\Dropbox\GitHub\C.-elegans\Worm_pain_model\Preprocessing\centroid_speed';
%centroid speed data filename
datafilename = 'speed_ctrl.mat';
%path of maximum speed
maxspeeddatapath = 'D:\Dropbox\GitHub\C.-elegans\Worm_pain_model\Data_analysis\feature_analysis\maxspeed';
%maximum speed data filename
maxspeedfilename = 'maxspeed_ctrl.mat';

%%%Settings end
%%%%%%%%%%%%%%%%%%%%%%%%%%

%load data
cd(speeddatapath)
load(datafilename)
cd(maxspeeddatapath)
load(maxspeedfilename)


%rescaling of the maximum speed such that the range of laser power are the
%same
tavgmaxspeed = (I_avgmaxspeed(end))/(avgmaxspeed(end))*avgmaxspeed;

%fitting a double exponential curve 
curve = fit( tavgmaxspeed', I_avgmaxspeed' , 'exp2');
plot(curve)

%nI_ctrl = normalized laser power
nI_ctrl = curve(I_ctrl)';



%%%saving data
cd(orgpath)
save(datafilename, ['I' datafilename(6:10)],['nI' datafilename(6:10)],['nfspeed' datafilename(6:10)], ['speed' datafilename(6:10)])







