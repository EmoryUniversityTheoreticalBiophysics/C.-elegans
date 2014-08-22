function [foutput]=range_lasso_manual(I,nfspeed,fspeed,drange,area) 

    
    cd D:\Dropbox\GitHub\C.-elegans\Worm_pain_model\Data_analysis\Range_optimization_LASSO

   
    
    %Pick the data as specified in area and drange
    fspeed(:,[46 173 265]) = [];
    I([46 173 265]) = [];
    nfspeed(:,[46 173 265]) = [];
    
    %delete the data that out of the limit
    timepick = 80;
    
    area1list = find(fspeed(timepick,:)>drange(2));
    area1list(find(I(area1list)<drange(1))) = [];
    
    area4list = find(fspeed(timepick,:)>drange(2));
    area4list(find(I(area4list)>drange(1))) = [];
    
    area3list = find(fspeed(timepick,:)<drange(2));
    area3list(find(I(area3list)>drange(1))) = [];
    
    area2list = find(fspeed(timepick,:)<drange(2));
    area2list(find(I(area2list)<drange(1))) = [];
    
    
    
    tnfspeed = [];
    tfspeed = [];
    tI = [];
    if area(1) == 1
        tnfspeed = [tnfspeed nfspeed(:,area1list)];
        tfspeed = [tfspeed fspeed(:,area1list)];
        tI = [tI I(:,area1list)];
    end
    if area(2) == 1
        tnfspeed = [tnfspeed nfspeed(:,area2list)];
        tfspeed = [tfspeed fspeed(:,area2list)];
        tI = [tI I(:,area2list)];
    end
    if area(3) == 1
        tnfspeed = [tnfspeed nfspeed(:,area3list)];
        tfspeed = [tfspeed fspeed(:,area3list)];
        tI = [tI I(:,area3list)];
    end
    if area(4) == 1
        tnfspeed = [tnfspeed nfspeed(:,area4list)];
        tfspeed = [tfspeed fspeed(:,area4list)];
        tI = [tI I(:,area4list)];
    end
    
    
    nfspeed = tnfspeed;
    I = tI;
    
     %Transforming I by sigmoid function
    transcoeff(1) = 2.3764;
    transcoeff(2) = 32.4007;
    I = (I.^transcoeff(1) ./ ((I.^transcoeff(1)) + (transcoeff(2)^transcoeff(1))));

    
    save temp I nfspeed
    
   %Run the R script of LASSO 
    executed = system('"C:\Program Files\R\R-2.14.2\bin\R.exe" CMD BATCH  --vanilla --slave "D:\Dropbox\GitHub\C.-elegans\Worm_pain_model\Data_analysis\Range_optimization_LASSO\range_lasso_optR.R"');
    
    
    load temp2
    
    [maxvalue maxpos] = max(r2cv);
 
%     Maximize R2 
     display('Output')
     foutput = 1- maxvalue;
end