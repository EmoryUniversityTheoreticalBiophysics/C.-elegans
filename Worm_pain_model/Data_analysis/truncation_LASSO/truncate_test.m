%%%% truncate the time series and calculate maximum R2 at different time
%%%% peroid

clear all
load('D:\Ilya\Control_Data\Control_data_analysis\centroid_speed\truncate_test\Control_data_CVel_R100logI.mat')


cd D:\Dropbox\GitHub\C.-elegans\Worm_pain_model\Data_analysis\truncation_LASSO

samszie = 30;
diff = floor((959-60)/samszie);
org_nfspeed = nfspeed;

for i = 1:samszie+1
    i
    timeend = 60+((i-1)*diff);
    nfspeed = org_nfspeed(30:timeend,:);
    save temp I nfspeed
    
    executed = system('"C:\Program Files\R\R-2.14.2\bin\R.exe" CMD BATCH  --vanilla --slave "D:\Dropbox\GitHub\C.-elegans\Worm_pain_model\Data_analysis\truncation_LASSO\lasso_trunc.R"');
    load temp2
    
    [maxvalue maxpos] = max(r2cv);
    maxtime(i) = timeend;
    maxr2cv(i) = maxvalue;
    
end