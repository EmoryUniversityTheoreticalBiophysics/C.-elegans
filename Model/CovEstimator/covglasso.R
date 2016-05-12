##Used with cov_estimate function in MATLAB
##Read in speed data and estimation covariance matrix with data

library(R.matlab)
library(glasso)
setwd("/Users/kleung4/Dropbox/Ilya/Worm_Pain/Data_Ayalsis/data_multi_gaussain/Para_var/Temp/")
filename = "temp"
mattest <- readMat(file.path(paste(filename,".mat",sep="")))

s<- var(t(speed))
a<-glasso(s, rho=.01)

#saving data
writeMat(paste("temp2",".mat",sep=""),lambda1=fit1$lambda,lambda2=fit2$lambda,r2cv=r2cv, beta=fit1$beta, nzero=fit1$df,a0 = fit1$a0,input_I = I,input_nfspeed = speed)

