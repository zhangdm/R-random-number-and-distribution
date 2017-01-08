#number of iterations in the loop
iters<-10

#vector for appending output
ls<-vector('list',length=iters)

#start time
strt<-Sys.time()

#loop
for(i in 1:iters){
  
  #counter
  cat(i,'\n')
  
  to.ls<-rnorm(1e6)
  to.ls<-summary(to.ls)
  
  #export
  ls[[i]]<-to.ls
  
}

#end time
print(Sys.time()-strt)
# Time difference of 2.944168 secs




#iterations to time
iters<-seq(10,100,by=10)

#output time vector for  iteration sets
times<-numeric(length(iters))

#loop over iteration sets
for(val in 1:length(iters)){
  
  cat(val,' of ', length(iters),'\n')
  
  to.iter<-iters[val]
  
  #vector for appending output
  ls<-vector('list',length=to.iter)
  
  #start time
  strt<-Sys.time()
  
  #same for loop as before
  for(i in 1:to.iter){
    
    cat(i,'\n')
    
    to.ls<-rnorm(1e6)
    to.ls<-summary(to.ls)
    
    #export
    ls[[i]]<-to.ls
    
  }
  
  #end time
  times[val]<-Sys.time()-strt
  
}

#plot the times
library(ggplot2)

to.plo<-data.frame(iters,times)
ggplot(to.plo,aes(x=iters,y=times)) + 
  geom_point() +
  geom_smooth() + 
  theme_bw() + 
  scale_x_continuous('No. of loop iterations') + 
  scale_y_continuous ('Time in seconds')






#predict times
mod<-lm(times~iters)
predict(mod,newdata=data.frame(iters=1e4))/60
# 45.75964



#import packages
library(foreach)
library(doParallel)

#number of iterations
iters<-1e4

#setup parallel backend to use 8 processors
cl<-makeCluster(8)
registerDoParallel(cl)

#start time
strt<-Sys.time()

#loop
ls<-foreach(icount(iters)) %dopar% {
  
  to.ls<-rnorm(1e6)
  to.ls<-summary(to.ls)
  to.ls
  
}

print(Sys.time()-strt)
stopCluster(cl)

#Time difference of 10.00242 mins













library(foreach)  
library(doSNOW)  
library(randomForest)  
data(iris)  

cores<-2  

num_trees<-ceiling(2000/cores)  
c1<-makeCluster(cores)  
registerDoSNOW(c1)  

rf_fit<-foreach(ntree=rep(num_trees,cores),.combine=combine,  
                .packages=c("randomForest")) %dopar% {  
                  randomForest(iris[,-5],y=iris[,5],ntree=ntree,do.trace=100)   
                }  

stopCluster(c1) 








library(foreach)  
library(doSNOW)  
library(randomForest)  
data(iris)  

cores<-2  

num_trees<-ceiling(2000/cores)  
c1<-makeCluster(cores)  
registerDoSNOW(c1)  

writeLines(c(""), "log.txt")  

rf_fit<-foreach(ntree=rep(num_trees,cores),.combine=combine,  
                .packages=c("randomForest")) %dopar% {  
                  sink("log.txt", append=TRUE)  
                  randomForest(iris[,-5],y=iris[,5],ntree=ntree,do.trace=100)   
                }  

stopCluster(c1)  










rf_fit<-foreach(iteration=1:cores,ntree=rep(num_trees,cores),  
                .combine=combine,.packages=c("randomForest")) %dopar% {  
                  sink("log.txt", append=TRUE)  
                  cat(paste("Starting iteration",iteration,"\n"))  
                  randomForest(iris[,-5],y=iris[,5],ntree=ntree,do.trace=100)   
                }  




