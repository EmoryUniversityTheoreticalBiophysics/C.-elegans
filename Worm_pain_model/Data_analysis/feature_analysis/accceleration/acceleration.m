%%%calculate acceleration 
acc_ctrl = diff(speed_ctrl);


%finding the maximum acceleration
tacc_ctrl = acc_ctrl;

%removing acceleration before laser is on
tacc_ctrl(1:59,:) = 0;
[maxacc time2maxacc]  = max(-tacc_ctrl);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Plot the maximum acceleration vs laser power
binl = 10;
diff =  150.1/binl;

tmaxvalue = time2maxacc;
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
ylabel('Time to Max -ve acceleration')
xlabel('Laser power')
%%plotting ends
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


save acc_ctrl I_ctrl acc_ctrl
