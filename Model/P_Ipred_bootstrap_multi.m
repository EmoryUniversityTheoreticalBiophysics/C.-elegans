
function [p_all,I0,I1,ugt_full,sigmagt_full,upt_full_boot] = P_Ipred_bootstrap_multi(I,S,speed,pred_I_range,numboot,factor1,fname)
% This function resample the speed profile and calculate the average probability
% distribution of predicted laser power over all resampled data. For
% Multivariate Gaussian Distribution.
%Input:
%  I -- laser power of the worms. Read from file fname if input argument equals to []. (1 x Nworms)
%  S -- boolean index representing go or paused worms. Pause = 1 and go = 0. (1 x worms)
%  speed -- speed profile of the worm for calculation of model (time x worms)
%  pred_I_range -- range of the current used in experiments (2 integer: start, end)
%  fname -- file name of data to work with
%  numboot --bootstrap number of trial

%Output:
%  I0 -- Parameter of the model of all resampled data (1 x
%  numboot)
%  I1 -- Parameter of the model of all resampled data (2 x
%  numboot)
%  ugt_full -- template velocity of active worms (numboot x time)
%  sigmagt_full -- variance of the go worm speed (numboot x time)
%  upt_full -- template velocity of paused worms (numboot x time)
% (c) George Laung and Ilya Nemenman

% Number of bins in the avg_prob_map
nbins = 5;

% bootstrap data file name
fname_boot= [fname '_boot_' num2str(numboot) '_result'];

% % Read from file fname if this speed or fspeed is empty.
% if isempty(speed) || isempty(fspeed) || isempty(I)
%     %data from the file:
%     %  I -- laser power of the worms. Read from file fname if this argument is empty. (1 x Nworms)
%     %  speed -- velocity profile of the worm. Read from file fname if this argument is empty. (time x nworms) 
%     %  fspeed -- filtered (smoothed) velocity profile of the worm. Read from file fname if this argument is empty. (time x nworms)
%     load(fname);
%     
% end

% % anonymous function defining the rescaling model
% factor1 = @(I,I1) I1(1)+((I)./(1+(I/I1(2)))); 

% the hack to deal with corelations in the data; should be about equal
% to the data correlation time
pscale = 1;

nWorms = length(I); % number of different worms in the data set 
ntime = size(speed,1);


        % re-generate bootstrap data if it doesn't exist
        selectindex=zeros(numboot,nWorms);  % initialize samples to be used in bootstrap data


        I1=zeros(numboot,2);                % initialize parameter values
        I0=zeros(numboot,1);                % initialize parameter values
        p_all = cell(numboot,1);                   % initialize probability values
        p_binned = cell(numboot,1);              % initialize binned probability values
        ugt_full = zeros( numboot,ntime);        % initialize average of the go worm speed
        sigmagt_full = cell(numboot,1);          % initialize variance of the go worm speed
        upt_full = zeros( numboot,ntime);        % initialize average of the paused worm speed
        sigmapt_full = cell(numboot,1);         % initialize variance of the paused worm speed
        avg_prob_map = zeros(nbins,pred_I_range(2)-pred_I_range(1)+1);  % initialize average of binned probability values
        [bin_num meanI bin_range]=data_bin(I, nbins); % calculate the range of the bins
        
        
        %calculate the average and variance of the paused worm speed profile
        model_speed_p = speed(:,S);                   % speed of the paused worms      
        [upt,sigmapt]=calc_pause_profile_multi(model_speed_p);
        
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
            % generated bootstrap data index 
            selectindex(k,:) = randi(nWorms, nWorms, 1);      

         
            
            % Organise the data according to selectindex
            I_selected = I(selectindex(k,:)); 
            speed_selected = speed(:,selectindex(k,:));
            S_selected = S(selectindex(k,:));
            
            %calculate the average the paused worm speed profile
            speed_selected_p = speed_selected(:,S_selected);                   % speed of the paused worms  
            upt_full_boot(k,:) = mean(speed_selected_p,2);
            

            % calculate optimal parameters I0 and I1 for the model and calcualte the
            % probability distribution of laser pwoer given the model and speed
            % profile.
            [p_all{k},I0(k),I1(k,:),ugt_full(k,:),sigmagt_full{k},upt_full(k,:),sigmapt_full{k},likelihood_temp] = I01_bootstrap_multi(I_selected,S_selected,speed_selected,upt,sigmapt,pred_I_range,[],factor1,init_val,pscale);
            
            %Calculate the likelihood give the laser power P(I|v)
            likelihood(k,:) = likelihood_temp;
            
            %Group and average the probability distribution into 
            %equalprobable bins
            p_binned{k}(1,:) = mean(p_all{k}(:,I_selected<= bin_range(1)),2)';
            for i = 2:nbins
                p_binned{k}(i,:) = mean(p_all{k}(:,(I_selected<= bin_range(i) & I_selected> bin_range(i-1))),2)'; %average conditional probability distribution of bin i
            end
            
            avg_prob_map = avg_prob_map + p_binned{k};
            I_all(i,:) = I_selected;
            %Plot the collasped velocity
            %plot_vels(fspeed_selected_go, I_selected_go, I1(k,:), factor1, ['_' fname '_shuffled' '_boot' num2str(k) ],2)
            k
        end
%         
        avg_prob_map = avg_prob_map./numboot;
        
        try 
            mkdir('results_data')
        end
        cd('results_data')
%         save(fname_boot,'I0','I1','I','fname','speed','fspeed','selectindex','p_binned','avg_prob_map','ugt_full','upt_full','sigmagt_full','sigmapt_full')
        save(fname_boot,'likelihood','I0','I1','I_all','fname','speed','selectindex','ugt_full','upt_full','sigmagt_full','sigmapt_full','p_all','p_binned','avg_prob_map','likelihood')
        cd('..')

end

    
