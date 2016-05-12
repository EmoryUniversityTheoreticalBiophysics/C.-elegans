%Estimate initial speed and error
speedtimelist = 1:60;
%%%%Data preparation 
load('control_oct.mat')
fspeed_c = fspeed(speedtimelist,:);
fspeed_c_all = fspeed;
speed_c = speed(speedtimelist,:);
%%%%


load('ibuprofen.mat')
fspeed_i = fspeed(speedtimelist,:);
speed_i = speed(speedtimelist,:);
fspeed_i_all = fspeed;
%%%%


load('mutant.mat')
%Undersample the fspeed
fspeed_m = fspeed(speedtimelist,:);
speed_m = speed(speedtimelist,:);
fspeed_m_all = fspeed;
%%%%



%%%%%%
%Select the correct samples
%%%%%%
acc_c = max(abs(diff(speed_c)));
acc_i = max(abs(diff(speed_i)));
acc_m = max(abs(diff(speed_m)));


wrongflag_c = find(acc_c>100);
wrongflag_i = find(acc_i>100);
wrongflag_m = find(acc_m>100);


wrongflag_c = (max(abs(fspeed_c))>60);
wrongflag_i = (max(abs(fspeed_i))>60);
wrongflag_m = (max(abs(fspeed_m))>60);
% 
% find(mean_fspeed_c>20)


%%%%%%%%%%
%Calculate Mean and SD

avg_fspeed_c = mean(speed_c(30:60,~wrongflag_c));
avg_fspeed_i = mean(speed_i(30:60,~wrongflag_i));
avg_fspeed_m = mean(speed_m(30:60,~wrongflag_m));


avg_fspeed_c_se = std(avg_fspeed_c)/length(avg_fspeed_c);
avg_fspeed_i_se = std(avg_fspeed_i)/length(avg_fspeed_i);
avg_fspeed_m_se = std(avg_fspeed_m)/length(avg_fspeed_m);

avg_fspeed_c_std = std(avg_fspeed_c);
avg_fspeed_i_std = std(avg_fspeed_i);
avg_fspeed_m_std = std(avg_fspeed_m);

avg_fspeed_c_mean = mean(avg_fspeed_c);
avg_fspeed_i_mean = mean(avg_fspeed_i);
avg_fspeed_m_mean = mean(avg_fspeed_m);

%%%%%%%%%%%%
figure(8)
plot(fspeed_c(30:60,~wrongflag_c));
plot(fspeed_i(30:60,~wrongflag_i));
plot(fspeed_m(30:60,~wrongflag_m));

plot(avg_fspeed_c,'.')
plot(avg_fspeed_i,'.')
plot(avg_fspeed_m,'.')

