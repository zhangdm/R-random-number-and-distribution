#create data
set.seed(3)

#time steps
t.step<-seq(0,20)

#group names
grps<-letters[1:10]

#random data for group values across time
grp.dat<-runif(length(t.step)*length(grps),5,15)

#create data frame for use with plot
grp.dat<-matrix(grp.dat,nrow=length(t.step),ncol=length(grps))
grp.dat<-data.frame(grp.dat,row.names=t.step)
names(grp.dat)<-grps




source("https://gist.github.com/fawda123/6589541/raw/8de8b1f26c7904ad5b32d56ce0902e1d93b89420/plot_area.r")
plot.area(grp.dat)






plot.area(grp.dat,col=c('red','lightgreen','purple'))


plot.area(grp.dat,col=c('red','lightgreen','purple'),grp.ln=F)
plot.area(grp.dat,col=c('red','lightgreen','purple'),stp.ln=F)



plot.area(grp.dat,prop=F)
plot.area(grp.dat,prop=F,horiz=T)




require(ggplot2)
require(reshape)

#reshape the data
p.dat<-data.frame(step=row.names(grp.dat),grp.dat,stringsAsFactors=F)
p.dat<-melt(p.dat,id='step')
p.dat$step<-as.numeric(p.dat$step)
#create plots
p<-ggplot(p.dat,aes(x=step,y=value)) + theme(legend.position="none")
p + geom_area(aes(fill=variable)) 
p + geom_area(aes(fill=variable),position='fill')




