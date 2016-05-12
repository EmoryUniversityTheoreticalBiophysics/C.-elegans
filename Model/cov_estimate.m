function [covmatrix,shrinkage] = cov_estimate(data)
%%% This function estimate the covariance of data

shrinkage = NaN;

estimatorflag = 2;

    %%%%Testing different ways to estimate covariance matrix
switch estimatorflag
    case 1
    %%1. Covar = 0, sample var (equal to simple method)
    covmatrix= cov_diag(data);
    
    case 2
%     %%%2. sample covariance matrix
    covmatrix = cov(data');
    
    case 3
%     %%%3. 
    covmatrix= autocov2(data);
    
    case 4
  %%%4. Ledoit, O. and Wolf, M. (2004) "A well-conditioned estimator for large-dimensional covariance matrices."
  %%% Uses Shrinkage estimation with scaled identiy matrix as target
  %%% covmatrix = shrinkage*target + (1-shrinkage)*sample_cov
    [covmatrix,shrinkage]=cov1para(data');
  
    case 5
  %%%5. Ledoit, O. and Wolf, M. (2004) "Honey, I shrunk the sample covariance matrix"
  %%% Uses Shrinkage estimation with constant correlation matrix as target
    [covmatrix,shrinkage]=covCor(data');

    case 6
 %%%6. Ledoit, O. and Wolf, M. (1996) 
  %%% Uses Shrinkage estimation with diagonal matrix of sample cov as target
    [covmatrix,shrinkage]=covshrinkDiag(data');
  
    case 7
 %%%7. J. Schaefer and K. Strimmer.  2005.  A shrinkage approach to 
 %%%%   large-scale covariance matrix estimation and implications 
  %%%  Shrink the var and cov elements separately
  %%%  shrinkvar : if 1, shrinks the diagonal variance terms, default is 0
    [covmatrix, lamcor, lamvar] = covshrinkKPM(data', 0);  
    
    case 8
    %%export to R and use glasso
    save('/Users/kleung4/Dropbox/Ilya/Worm_Pain/Data_Ayalsis/data_multi_gaussain/Para_var/Temp/temp.mat','data')
    executed = system('"/usr/bin/Rscript" "/Users/kleung4/Dropbox/GitHub/C.-elegans/multivariate_gaussian_model/CovEstimator/Func_fit_I1_multi_R.R"');
    % %%%

    
    otherwise
        error('estimatorflag is invalid')
end
  
end