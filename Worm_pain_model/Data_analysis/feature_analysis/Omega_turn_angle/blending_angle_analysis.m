%%minimum angle

tbendangle=abs(bendangle);
tI = I_ctrl;
[minangle time2minangle] = min(tbendangle);


%%%%plotting bar charts

binl = 10;
diff =  150.1/binl;

tmaxvalue = time2minangle;
tI(find(isnan(tmaxvalue))) = [];
tmaxvalue(find(isnan(tmaxvalue))) = [];

for i = 1:binl
    temp = find(tI<(i*diff) & tI>((i-1)*diff));
    avg1(i) = mean(tmaxvalue(temp));
    SD1(i) = sqrt(var(tmaxvalue(temp)));
    x1(i) = (i+i-1)*diff/2;
end

figure(1)
errorbar(x1,avg1,SD1/2,'xr')
ylabel('Minimum angle')
xlabel('Laser power')
