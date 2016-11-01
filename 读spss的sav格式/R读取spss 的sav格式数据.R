#R语言读取Spss的sav格式的数据

#英文的
##1
library(foreign)
mydata=read.spss("data.sav")  

##2
library(Hmisc)  
data=spss.get("data.sav") 


#中文的字符
library(memisc)
data1 = as.data.set(spss.system.file("data.sav"))
data = as.data.frame(data1)


#更加详细的，请看http://blog.csdn.net/xxzhangx/article/details/52198474
