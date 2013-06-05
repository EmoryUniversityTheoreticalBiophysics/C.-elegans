clear all
load D:\Dropbox\Ilya\Worm_Pain\Data_Ayalsis\3rd_data_analysis\DATAANLYSIS\angle_change_all\angle_all.mat

%%analyze the features of the angluar change

absangle = abs(angle_f);
rmsangle = sqrt(sum(angle_f.^2));
abssumangle= sum(abs(angle_f));
maxangle = max(angle_f);


angle_f2 = angle_f(480:960,:);
rmsangle2 = sqrt(sum(angle_f2.^2));
abssumangle2= sum(abs(angle_f2));
maxangle2 = max(angle_f2);


binl = 10;
diff =  150.1/binl;
for i = 1:binl
    temp = find(I_ctrl<(i*diff) & I_ctrl>((i-1)*diff));
    avg1(i) = mean(maxangle2(temp));
    SD1(i) = sqrt(var(maxangle2(temp)));
    x1(i) = (i+i-1)*diff/2;
end

figure(1)
% plot(x1,avg1)
errorbar(x1,avg1,SD1/2,'xr')
ylabel('Max Angle (later part only)')
xlabel('Laser power')

tI = I_ctrl;
tmaxvalue = maxangle;
tI(find(isnan(tmaxvalue))) = [];
tmaxvalue(find(isnan(tmaxvalue))) = [];
corr(tI',tmaxvalue')


save angle_all_analysis absangle rmsangle abssumangle maxangle
