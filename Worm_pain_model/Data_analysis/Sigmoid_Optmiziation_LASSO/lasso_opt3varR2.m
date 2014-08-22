function [foutput]=lasso_opt(I,nfspeed,transcoeff,displayflag) 
% This function do sigmoid transform on I and then do lasso analysis    
%
% Input:
% 
% Output:
%
%

    cd D:\Dropbox\GitHub\C.-elegans\Worm_pain_model\Data_analysis\Sigmoid_Optmiziation_LASSO\

    I = transcoeff(3)*(I.^transcoeff(1) ./ ((I.^transcoeff(1)) + (transcoeff(2)^transcoeff(1))));

    
    save temp I nfspeed
    
   %Run the R script of LASSO 
    executed = system('"C:\Program Files\R\R-2.14.2\bin\R.exe" CMD BATCH  --vanilla --slave "D:\Dropbox\GitHub\C.-elegans\Worm_pain_model\Data_analysis\Sigmoid_Optmiziation_LASSO\lasso_optR.R"');
    
    
    load temp2
    
    [maxvalue maxpos] = max(r2cv);
 
%     Maximize R2 
     display('Output')
     foutput = 1- maxvalue;
end