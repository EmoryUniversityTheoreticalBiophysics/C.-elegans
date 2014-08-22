
rm(list = ls())
library("R.matlab")
library("glmnet")


setwd("D:/Ilya/Control_Data/Control_data_analysis/centroid_speed/truncate_test")
#setwd("D:/Ilya/AUG_DATA/randompower_data_analysis/centroid_speed")


#filename = "Control_data_CVel_sigtran"
filename = "Control_data_CVel_R100logI"
#filename = "randompower_data_CVel"
#filename = "Control_data_CVel_logI"


mattest <- readMat(file.path(paste(filename,".mat",sep="")))


speed = mattest$nfspeed
I = mattest$I


###Alter the direction of the matrix
if (dim(I)[1]<dim(I)[2]){
  I = t(I)
}

#set a lambda
#lambdafit1 = seq(0,28.311063326,length=100) 



###LASSO
#fit1 = glmnet(t(speed), t(I),lambda = lambdafit1)
fit1 = glmnet(t(speed), t(I))
####Cross-validation LASSO
#fit2 = cv.glmnet(t(speed), t(I),lambda = lambdafit1)
fit2 = cv.glmnet(t(speed), t(I))
r2cv= 1- (fit2$cvm/var(I))


###output Rsquare plots
windows() 
plot(fit2$nzero,r2cv,col="red",xlab="no. of nonzero",ylab='Rsquare',ylim=c(0,1))
title('Rsquare')

xlab='Rsquare'

### find the maximum value of Rsquare
windows() 
plot(fit1$beta[,which.max(r2cv)],xlab='time')
title(r2cv[which.max(r2cv)],  sub = fit2$nzero[which.max(r2cv)],
      cex.sub = 0.75, font.sub = 3, col.sub = "red")



#saving data
writeMat(paste(filename,"_LASSO",".mat",sep=""),r2cv=r2cv, cvm = fit2$cvm,cvup = fit2$cvup,cvlo = fit2$cvlo ,LASSOresult=fit1$beta, nzero=fit1$df,a0 = fit1$a0, intput_I = I)

