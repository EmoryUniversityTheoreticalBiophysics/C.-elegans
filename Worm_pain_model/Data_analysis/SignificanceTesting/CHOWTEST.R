#Perform chow test on two different slope
library("R.matlab")
rm(list = ls())

setwd("D:/Ilya/Control_Data/Control_data_analysis/centroid_speed/prediction/Control_data_CVel_logI_LASSO")
#setwd("D:/Ilya/Control_Data/Control_data_analysis/centroid_speed/prediction/Control_data_CVel_linear_LASSO")


#filename1 = "RANDOMocr2osm9ocr1_data_CVel_logI_shortprediction"
filename1 =   "IBU_combine_data_CVel_logI_shortprediction"

#filename1 = "Control_data_CVel_linear_shortprediction"
#filename1 = "RANDOMocr2osm9ocr1_data_CVel_shortprediction"
data1 <- readMat(file.path(paste(filename1,".mat",sep="")))


filename2 = "Control_data_CVel_logI_shortprediction"
#filename2 = "RANDOMocr2osm9ocr1_data_CVel_logI_shortprediction"
#
#filename2 = "RANDOMocr2osm9ocr1_data_CVel_shortprediction"
#filename2 = "IBU_combine_data_CVel_shortprediction"
data2 <- readMat(file.path(paste(filename2,".mat",sep="")))

threshold = 10000

y1 = data1$predI[data1$I<threshold,]
x1 =data1$I[data1$I<threshold]

y2 = data2$predI[data2$I<threshold,]
x2 = data2$I[data2$I<threshold]

yc = c(y1,y2)
xc = c(x1,x2)

## linear regression on combined and separated data
r.reg = lm(yc ~ xc)
ur.reg1 = lm(y1 ~ x1)
ur.reg2 = lm(y2 ~ x2)

## Calculate sum of squared residuals for each regression
SSR = NULL
SSR$r = r.reg$residuals^2
SSR$ur1 = ur.reg1$residuals^2
SSR$ur2 = ur.reg2$residuals^2

## K is the number of regressors in our model
K = r.reg$rank

## Computing the Chow test statistic (F-test)
numerator = ( sum(SSR$r) - (sum(SSR$ur1) + sum(SSR$ur2)) ) / K
denominator = (sum(SSR$ur1) + sum(SSR$ur2)) / (length(xc) - 2*K)
chow = numerator / denominator
chow

## Calculate P-value
1-pf(chow, K, (length(xc) - 2*K))