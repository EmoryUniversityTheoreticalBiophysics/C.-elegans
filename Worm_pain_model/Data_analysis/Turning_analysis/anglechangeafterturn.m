%%% calculate the angle change after the turn
clear all

cd D:\Dropbox\Ilya\Worm_Pain\Data_Ayalsis\3rd_data_analysis\Preprocessing
load data_ctrl
load note_ctrl

cd D:\Dropbox\Ilya\Worm_Pain\Data_Ayalsis\3rd_data_analysis\DATAANLYSIS\Turning_analysis\ANALYSIS\angle_change
load output

angle_diff = zeros(length(data_ctrl),1);
for i = 1:length(data_ctrl)
    head(:,1) = data_ctrl{i}.wormskelx(:,1);
    tail(:,1) = data_ctrl{i}.wormskelx(:,41);
    head(:,2) = data_ctrl{i}.wormskely(:,1);
    tail(:,2) = data_ctrl{i}.wormskely(:,41);
    if wronghead(i) == 1
        htvector{i} = tail - head;
        htvector{i}(endnum(i):end,:) = -htvector{i}(endnum(i):end,:);
    else
        htvector{i} = tail - head;
    end
    if reversevalue(i) == 1
        if startnum(i) >0 
            initvec = mean(htvector{i}(startnum(i)-30:startnum(i),:));
            if endnum(i)+30<= length(data_ctrl{i}.wormskelx)
                finalvec = mean(htvector{i}(endnum(i):endnum(i)+30,:));
            else
                finalvec = mean(htvector{i}(endnum(i):end,:),1);
            end
            angle_diff(i) = angle_change(initvec,finalvec);
        end
    end
end

figure(1) 
plot(I_ctrl,abs(angle_diff),'.')
xlabel('Laser power')



%%%%binning
binl = 10;
diff =  150.1/binl;

tmaxvalue = abs(angle_diff);
tI2 = I_ctrl;
tI2(find(isnan(tmaxvalue))) = [];
tmaxvalue(find(isnan(tmaxvalue))) = [];

for i = 1:binl
    temp = find(tI2<(i*diff) & tI2>((i-1)*diff));
    avg1(i) = mean(tmaxvalue(temp));
    SD1(i) = sqrt(var(tmaxvalue(temp)));
    x1(i) = (i+i-1)*diff/2;
end

figure(2) 
errorbar(x1,avg1,SD1/2,'xr')
ylabel('Angle change after turning')
xlabel('Laser power')

tI = I_ctrl;
tmaxvalue = abs(angle_diff);
tI(find(isnan(tmaxvalue))) = [];
tmaxvalue(find(isnan(tmaxvalue))) = [];
corr(tI,tmaxvalue)

save angle_diff angle_diff
