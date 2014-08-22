
rm(list = ls())
library("R.matlab")
library("glmnet")


setwd("D:/Dropbox/GitHub/C.-elegans/Worm_pain_model/Data_analysis/Range_optimization_LASSO")

#Read the data
filename = "temp"
mattest <- readMat(file.path(paste(filename,".mat",sep="")))



speed = mattest$nfspeed
I = mattest$I

if (dim(I)[1]<dim(I)[2]){
  I = t(I)
}
  


###LASSO
fit1 = glmnet(t(speed), t(I))

####Cross-validation LASSO
fit2 = cv.glmnet(t(speed), t(I))
r2cv= 1- (fit2$cvm/var(I))



#saving data
writeMat(paste("temp2",".mat",sep=""),lambda1=fit1$lambda,lambda2=fit2$lambda,r2cv=r2cv, beta=fit1$beta, nzero=fit1$df,a0 = fit1$a0,input_I = I,input_nfspeed = speed)

