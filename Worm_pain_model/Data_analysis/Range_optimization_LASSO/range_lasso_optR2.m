function [foutput]=range_lasso_optR2(I,nfspeed,fspeed,drange) 

    
    cd D:\Dropbox\GitHub\C.-elegans\Worm_pain_model\Data_analysis\Range_optimization_LASSO

    %delete bad data
    fspeed(:,[46 173 265]) = [];
    I([46 173 265]) = [];
    nfspeed(:,[46 173 265]) = [];
    
    %delete the data that out of the limit
    deletelist = find(fspeed(100,:)>drange(2));
    deletelist(find(I(deletelist)<drange(1))) = [];
    fspeed(:,deletelist) = [];
    I(deletelist) = [];
    nfspeed(:,deletelist) = [];
    
    
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