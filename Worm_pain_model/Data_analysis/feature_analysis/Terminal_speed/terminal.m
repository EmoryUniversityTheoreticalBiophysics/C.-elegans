%%% calculate terminal speed and plot bar charts

tspeed = mean(speed_ctrl(end-59:end,:));


%%%%binning
binl = 10;
diff =  150.1/binl;

tmaxvalue = tspeed;
tI2 = I_ctrl;
tI2(find(isnan(tmaxvalue))) = [];
tmaxvalue(find(isnan(tmaxvalue))) = [];

for i = 1:binl
    temp = find(tI2<(i*diff) & tI2>((i-1)*diff));
    avg1(i) = mean(tmaxvalue(temp));
    SD1(i) = sqrt(var(tmaxvalue(temp)));
    x1(i) = (i+i-1)*diff/2;
end

figure(1)
errorbar(x1,avg1,SD1/2,'xr')
ylabel('Terminal speed')
xlabel('Laser power')




