function [foutput]=lasso_opt(I,nfspeed,transcoeff,displayflag) 
% This function do 3 value sigmoid transform on I and then do lasso analysis    
%
% Input:
% 
% Output:
% foutput - Difference between the slope and 1
%
%



    tranI = transcoeff(3)*tanh(transcoeff(1).*(I-transcoeff(2)));

    save temp I nfspeed
    
   %Run the R script of LASSO 
    executed = system('"C:\Program Files\R\R-2.14.2\bin\R.exe" CMD BATCH  --vanilla --slave "D:\Dropbox\GitHub\C.-elegans\Worm_pain_model\Data_analysis\Sigmoid_Optmiziation_LASSO\lasso_optR.R"');
    
    
    load temp2
    
%   checksum
%   sum(lambda1 == lambda2)
    
%     figure()
%     plot(nzero,r2cv,'.')
%     title(['R-square vs no. of nonzero'])
%     xlabel('no. of nonzero')
%     ylabel('R-square')
    
    [maxvalue maxpos] = max(r2cv);
    predI = input_nfspeed'*beta(:,maxpos) + a0(maxpos);
    
    if size(predI,1) ~= size(I,1)
        predI = predI';
    end
    
    %do inverse transform
    inv_predI = (atanh(predI./transcoeff(3))./transcoeff(1))+transcoeff(2);
    inv_I = (atanh(tranI./transcoeff(3))./transcoeff(1))+transcoeff(2);
    
    
    if displayflag == 1
        figure()
        plot(input_I,predI,'.')
        title(['Predicted I vs Actual I (Transformed)'])
        xlabel('Actual I')
        ylabel('Predicted I')

        figure()
        plot(inv_I,inv_predI,'.')
        title(['Predicted I vs Actual I (Not Transformed)'])
        xlabel('Actual I')
        ylabel('Predicted I')
        
        display('Max R2')
        max(r2cv)
    end
    
    if size(inv_I,1) ~= size(inv_predI,1)
        inv_I = inv_I';
    end
    Ifit = polyfit(inv_I,inv_predI,1);
    
%     Minimize |slope - 1|
    foutput = abs(Ifit(1) - 1);
%     

%     Maximize R2 
%     foutput = 1- maxvalue;
end