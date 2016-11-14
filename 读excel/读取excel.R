setwd("")#工作目录
getwd()#返回工作目录
library(gdata)
a<-read.xls("watermelon.xlsx",sheet=1,header =T,fileEncoding="utf8")
a