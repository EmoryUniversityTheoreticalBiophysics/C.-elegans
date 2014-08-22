%Calculate the overlap of two distributions


    data1 = beta1;
    data2 = beta2;

    %t-test
    [h,p] = ttest2(data1,data2,[],'both','unequal' )
    
    

    
    figure()
    histfit(data1)
    hold
    histfit(data2)
    
    intersec = 0.3147;
    if mean(data1)> mean(data2)
        num1 = length(find(data1<intersec))/length(data1);
        num2 = length(find(data2>intersec))/length(data2);
    else
        num1 = length(find(data1>intersec))/length(data1);
        num2 = length(find(data2<intersec))/length(data2);
    end
    
    
