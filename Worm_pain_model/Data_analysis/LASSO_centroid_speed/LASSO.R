# loading the  libraries
library("R.matlab")
library("glmnet")

# Speed vs time data path
setwd("D:/Dropbox/GitHub/C.-elegans/Worm_pain_model/Preprocessing/nonlinear_mapping")

#read data
mattest <- readMat(file.path("speed_ctrl.mat"))



#Assign input
#names(mattest) : check content in mattest
predict = mattest$nfspeed.ctrl

newI = t(mattest$I.ctrl)


#LASSO
fit0= glmnet(t(predict), t(newI))

#Setting Lambda range 
lambdafit1 = seq(log(20),log(0.0005),length=100) 
lambdafit1 = exp(lambdafit1)

fit1 = glmnet(t(predict), t(newI),lambda=lambdafit1)

#Cross-validated LASSO
fit2 = cv.glmnet(t(predict), t(newI),lambda=lambdafit1)
r2cv= 1- (fit2$cvm/var(newI))

#plot(fit2$nzero,r2cv)
#plot(fit1$beta[,50])
#plot(r2cv)
#plot(fit2$cvm)


#output Rsquare plot
windows() 
plot(fit2$nzero,r2cv,col="red",xlab="no. of nonzero",ylab='Rsquare',ylim=c(0,1))
title('Rsquare')

xlab='Rsquare'

#Plot the coeff. at the maximum value of Rsquare
windows() 
plot(fit1$beta[,which.max(r2cv)],xlab='time')
title(r2cv[which.max(r2cv)],  sub = fit2$nzero[which.max(r2cv)],
      cex.sub = 0.75, font.sub = 3, col.sub = "red")


#save data into R_result.mat
writeMat("R_result.mat",r2cv=r2cv, LASSOresult=fit1$beta, nzero=fit1$df)


