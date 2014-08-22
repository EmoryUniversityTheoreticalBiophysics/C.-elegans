#compare the slope of two linear regression by bootstraping

##############################
#loading the data
library("R.matlab")
rm(list = ls())

#setwd("D:/Ilya/Control_Data/Control_data_analysis/centroid_speed/prediction/Control_data_CVel_logI_LASSO")
#setwd("D:/Ilya/Control_Data/Control_data_analysis/centroid_speed/prediction/Control_data_CVel_linear_LASSO")
#setwd("D:/Ilya/Control_Data/Control_data_analysis/centroid_speed/prediction/Control_data_CVel_1-100_LASSO")
setwd("D:/Ilya/AUG_DATA/randompower_data_analysis/centroid_speed/prediction/randompower_data_CVel_nz_LASSO")

#filename1 = "Control_data_CVel_logI_shortprediction"
filename1 = "randompower_data_CVel_nz_shortprediction"
#filename1 = "Control_data_CVel_linear_shortprediction"
data1 <- readMat(file.path(paste(filename1,".mat",sep="")))


#filename2 = "IBU_combine_data_CVel_logI_shortprediction"
filename2 = "IBU_combine_data_CVel_shortprediction"
#filename2 = "IBU_combine_data_CVel_shortprediction"
data2 <- readMat(file.path(paste(filename2,".mat",sep="")))

#filename3 = "RANDOMocr2osm9ocr1_data_CVel_logI_shortprediction"
filename3 = "RANDOMocr2osm9ocr1_data_CVel_shortprediction"
#filename3 = "RANDOMocr2osm9ocr1_data_CVel_shortprediction"
data3 <- readMat(file.path(paste(filename3,".mat",sep="")))

threshold = 100

y1 = data1$predI[data1$I<threshold,]
x1 =data1$I[data1$I<threshold]

y2 = data2$predI[data2$I<threshold,]
x2 = data2$I[data2$I<threshold]

y3 = data3$predI[data3$I<threshold,]
x3 = data3$I[data3$I<threshold]


################################
#num of bootstrap resamples
numb <- 5000

beta1 <- NULL
c1 <- NULL
res1 <- NULL
beta2 <- NULL
c2 <- NULL
res2 <- NULL
beta3 <- NULL
c3 <- NULL
res3 <- NULL


for (i in 1:numb){
  
  randomlist = sample(1:length(x1), length(x1), replace = TRUE)
  xtemp = x1[randomlist]
  ytemp = y1[randomlist]
  reg1 = lm(ytemp ~ xtemp)
  
  beta1[i] = reg1$coefficients[2]
  c1[i] = reg1$coefficients[1]
  res1[i] = sum(reg1$residuals)
  
  randomlist = sample(1:length(x2), length(x2), replace = TRUE)
  xtemp = x2[randomlist]
  ytemp = y2[randomlist]
  reg2 = lm(ytemp ~ xtemp)
  
  beta2[i] = reg2$coefficients[2]
  c2[i] = reg2$coefficients[1]
  res2[i] = sum(reg2$residuals)
  
  randomlist = sample(1:length(x3), length(x3), replace = TRUE)
  xtemp = x3[randomlist]
  ytemp = y3[randomlist]
  reg3 = lm(ytemp ~ xtemp)
  
  beta3[i] = reg3$coefficients[2]
  c3[i] = reg3$coefficients[1]
  res3[i] = sum(reg3$residuals)
  
  print(i)
}

meanbeta1 = mean(beta1);
SDbeta1 = sd(beta1);
meanbeta2 = mean(beta2);
SDbeta2 = sd(beta2); 
meanbeta3 = mean(beta3);
SDbeta3 = sd(beta3);

writeMat(paste("Bootstrap_PvsA_",threshold,".mat",sep=""),SDbeta3=SDbeta3,meanbeta3=meanbeta3,SDbeta2=SDbeta2,meanbeta2=meanbeta2,meanbeta1=meanbeta1,SDbeta1=SDbeta1,beta1=beta1,beta2=beta2,beta3=beta3, c1=c1,c2=c2,c3=c3,res1=res1,res2=res2,res3=res3,Ic=x1,Ii=x2,Im=x3,predIc=y1,predIi=y2,predIm=y3)

save.image(file="Bootstrap.RData")




