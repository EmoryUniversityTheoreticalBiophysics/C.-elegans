function [sumdiff2 mlogP] = collaspe_plot(speed,fspeed,I,I1)
% Calculate the speed divided by rescaling function, and plot the average
% of the rescaled speed by five bins
% Input:
%   fspeed -- smoothed speed profile of the worm (time x nworms)
%   I1 -- parameters of the model (go velocity rescaling) (1 x 2)
%   I -- laser power (1 x worms)
%   S -- boolean index representing go or paused worms. Pause = 1 and go = 0. (1 x worms)
% Output:
%   sumdiff2 -- sum of the difference squared between speed profile of go worms and
%   predicted speed profile
%   plots of collasped, uncollasped speed profile and sum((speed -ugt*f(I))^2/(speed-mean speed)^2)

%(c) George Leung and Ilya Nemenman


% anonymous function defining the rescaling model
factor1 = @(I,I1) I1(1)+((I)./(1+(I/I1(2)))); 

% Select the moving worms only
S = gopause(fspeed);
fspeed_go = fspeed(:,~S);  
speed_go = speed(:,~S);  
I_go = I(~S);  

factor1val = factor1(I_go,I1);

% Calculate the collasped speed
collaspe_speed = fspeed_go./(ones(size(fspeed_go,1),1)*factor1val);

% Bin the data
nbins = 5;
[bin_num meanI bin_range]=data_bin(I_go, nbins);
cspeed_binned(1,:) = mean(collaspe_speed(:,I_go<= bin_range(1)),2);
speed_binned(1,:) = mean(fspeed_go(:,I_go<= bin_range(1)),2);
for i = 2:nbins
    cspeed_binned(i,:) = mean(collaspe_speed(:,(I_go<= bin_range(i) & I_go> bin_range(i-1))),2)';
    speed_binned(i,:) = mean(fspeed_go(:,(I_go<= bin_range(i) & I_go> bin_range(i-1))),2)'; 
end


[ugt,sigmagt]=calc_go_profile_v3(I_go,speed_go,factor1,I1);


diff_vel = fspeed_go - (ugt*factor1val);  % time x worms, difference between the actual velocity and the apropriately rescaled  template
ratiodata = var(diff_vel,0,2)./var(fspeed_go,0,2);
sumdiff2 = sum(sum(diff_vel.^2));

figure(3)
plot(ratiodata)
title('var(speed -ugt*f(I))/var(speed))')
xlabel('time')


figure(1)
plot(cspeed_binned')
% plot(collaspe_speed)
xlabel('time')
title('collasped plot')

figure(2)
plot(speed_binned')
% plot(fspeed_go)
xlabel('time')
title('uncollasped plot')

% figure()
% plot(mean(diff_vel,2))
% title('mean(speed -ugt*f(I))')
% xlabel('time')
end