
function [avg_prob_map,I0,I1,ugt_full,sigmagt_full] = P_Ipred_bootstrap(I,speed,fspeed,max_pred_I,numboot,timerange,fname)
% This function resample the speed profile and calculate the average probability
% distribution of predicted laser power over all resampled data
%Input:
%  I -- laser power of the worms. Read from file fname if input argument equals to []. (1 x Nworms)
%  speed -- velocity profile of the worm. Read from file fname if input argument equals to []. (time x nworms) 
%  fspeed -- filtered (smoothed) velocity profile of the worm. Read from file fname if input argument equals to []. (time x nworms)
%  max_pred_I -- max_pred_Imum range of the current used in experiments (single integer)
%  fname -- file name of data to work with
%  numboot --bootstrap number of trial
%  timerange = time period after signal application used for data analysis 

%Output:
%  avg_prob_map -- average probabilities of the speed profile given laser
%  power I over all resampled data (nbins x max_pred_I)
%  I0 -- Parameter of the model of all resampled data (1 x
%  numboot)
%  I1 -- Parameter of the model of all resampled data (2 x
%  numboot)
%  ugt_full -- average of the go worm speed (numboot x time)
%  sigmagt_full -- variance of the go worm speed (numboot x time)
% (c) George Laung and Ilya Nemenman

% Number of bins in the avg_prob_map
nbins = 5;

% bootstrap data file name
fname_boot= ['.\results_data\' fname '_boot_' num2str(numboot) '_' num2str(timerange(1)) '-' num2str(timerange(2)) '_result'];

% Read from file fname if this speed or fspeed is empty.
if isempty(speed) || isempty(fspeed) || isempty(I)
    %data from the file:
    %  I -- laser power of the worms. Read from file fname if this argument is empty. (1 x Nworms)
    %  speed -- velocity profile of the worm. Read from file fname if this argument is empty. (time x nworms) 
    %  fspeed -- filtered (smoothed) velocity profile of the worm. Read from file fname if this argument is empty. (time x nworms)
    load(fname);
    
end

% anonymous function defining the rescaling model
factor1 = @(I,I1) I1(1)+((I)./(1+(I/I1(2)))); 

% the hack to deal with corelations in the data; should be about equal
% to the data correlation time
pscale = 1;

nWorms = length(I); % number of different worms in the data set 
speed = speed(timerange(1):timerange(2),:);   % unfiltered velocities
fspeed = fspeed(timerange(1):timerange(2),:); % filtered velocoties
ntime = size(speed,1);


    if (exist([fname_boot '.mat'], 'file'))
        % load the bootstrap data if it exists
        load(fname_boot);

    else 
        % re-generate bootstrap data if it doesn't exist
        selectindex=zeros(numboot,nWorms);  % initialize samples to be used in bootstrap data


        I1=zeros(numboot,2);                % initialize parameter values
        I0=zeros(numboot,1);                % initialize parameter values
        p_all = cell(numboot,1);                   % initialize probability values
        p_binned = cell(numboot,1);              % initialize binned probability values
        ugt_full = zeros( numboot,ntime);        % initialize average of the go worm speed
        sigmagt_full = zeros(numboot,ntime);     % initialize variance of the go worm speed
        upt_full = zeros( numboot,ntime);        % initialize average of the paused worm speed
        sigmapt_full = zeros(numboot,ntime);     % initialize variance of the paused worm speed
        avg_prob_map = zeros(nbins,max_pred_I);  % initialize average of binned probability values
        [bin_num meanI bin_range]=data_bin(I, nbins); % calculate the range of the bins
        
        for k = 1:numboot %number of bootstraping
            %setting up initial values for the parameter guesses
            if (k==1)
                init_val = [30,30];         % use this for the first optimization
            else
                init_val(1) = mean(I1(1:(k-1),1)); 
                init_val(2) = mean(I1(1:(k-1),2)); % use average of the prior optimization
                                            % runs for the subsequent
                                            % optimizations
            end
            % bootstrap data index generation
            selectindex(k,:) = randi(nWorms, nWorms, 1);      

            % Organise the data according to selectindex
            I_selected = I(selectindex(k,:)); 
            speed_selected = speed(:,selectindex(k,:));
            fspeed_selected = fspeed(:,selectindex(k,:));
            S_selected = gopause(fspeed_selected);
            fspeed_selected_go = fspeed_selected(:,~S_selected);
            I_selected_go = I_selected(S_selected==0);


            % calculate optimal parameters I0 and I1 for the model and calcualte the
            % probability distribution of laser pwoer given the model and speed
            % profile.
            [p_all{k},I0(k),I1(k,:),ugt_full(k,:),sigmagt_full(k,:),upt_full(k,:),sigmapt_full(k,:)] = P_Ipred(I_selected,S_selected,speed_selected,max_pred_I,[],factor1,init_val,pscale);
            
            %Group and average the probability distribution into 
            %equalprobable bins
            p_binned{k}(1,:) = mean(p_all{k}(:,I_selected<= bin_range(1)),2)';
            for i = 2:nbins
                p_binned{k}(i,:) = mean(p_all{k}(:,(I_selected<= bin_range(i) & I_selected> bin_range(i-1))),2)'; %average conditional probability distribution of bin i
            end
            
            avg_prob_map = avg_prob_map + p_binned{k};
            
            %Plot the collasped velocity
            %plot_vels(fspeed_selected_go, I_selected_go, I1(k,:), factor1, ['_' fname '_shuffled' '_boot' num2str(k) ],2)
            k
        end
        
        avg_prob_map = avg_prob_map./numboot;
        
        try 
            mkdir('results_data')
        end
        save(fname_boot,'I0','I1','I','fname','timerange','speed','fspeed','selectindex','p_binned','avg_prob_map','ugt_full','upt_full','sigmagt_full','sigmapt_full')
        
    end
end

    
