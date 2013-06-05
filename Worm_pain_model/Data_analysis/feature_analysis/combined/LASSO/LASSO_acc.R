library("R.matlab")


setwd("D:/Dropbox/Ilya/Worm_Pain/Data_Ayalsis/3rd_data_analysis/DATAANLYSIS/feature_analysis/combined")

mattest <- readMat(file.path("rawdata.mat"))


#mattest$I_ctrl and mattest$speedwlaser
#input
#names(mattest) : check content in mattest
predict = mattest$rawdata
# predict = mattest$speed

newI = mattest$I.ctrl
# newI = t(mattest$I.ctrl)

library("glmnet")




###LASSO
fit0= glmnet(t(predict), newI)
#range 
lambdafit1 = seq(log(20),log(0.0005),length=100) 
lambdafit1 = exp(lambdafit1)

fit1 = glmnet(t(predict), t(newI),lambda=lambdafit1)

####Cross-validation LASSO
fit2 = cv.glmnet(t(predict), t(newI),lambda=lambdafit1)
r2cv= 1- (fit2$cvm/var(newI))

#plot(fit2$nzero,r2cv)
#plot(fit1$beta[,50])
#plot(r2cv)
#plot(fit2$cvm)


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



writeMat("R_result.mat",r2cv=r2cv, LASSOresult=fit1$beta, nzero=fit1$df)
# 
# windows() 
# plot(fit1$beta[,26],xlab='time')
# title(r2cv[26],  sub = fit2$nzero[26],
#       cex.sub = 0.75, font.sub = 3, col.sub = "red")

