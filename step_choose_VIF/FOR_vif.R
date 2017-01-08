#VIF
require(MASS)
require(clusterGeneration)

set.seed(2)
num.vars<-15
num.obs<-200
cov.mat<-genPositiveDefMat(num.vars,covMethod="unifcorrmat")$Sigma
rand.vars<-mvrnorm(num.obs,rep(0,num.vars),Sigma=cov.mat)

parms<-runif(num.vars,-10,10)
y<-rand.vars %*% matrix(parms) + rnorm(num.obs,sd=20)


lm.dat<-data.frame(y,rand.vars)
form.in<-paste('y ~',paste(names(lm.dat)[-1],collapse='+'))
mod1<-lm(form.in,data=lm.dat)
summary(mod1)


setwd("C:\\Users\\zhangxf\\Desktop")
source("VIF_func.R")
vif_func(in_frame=rand.vars,thresh=5,trace=T)


keep.dat<-vif_func(in_frame=rand.vars,thresh=5,trace=F)
form.in<-paste('y ~',paste(keep.dat,collapse='+'))
mod2<-lm(form.in,data=lm.dat)
summary(mod2)



