> a<-matrix(1:10,2)
> a
     [,1] [,2] [,3] [,4] [,5]
[1,]    1    3    5    7    9
[2,]    2    4    6    8   10
> which(a==3,arr.ind = TRUE)
     row col
[1,]   1   2


> a<-matrix(c(rep(1,5),rep(2,5)),2,5)
> a
     [,1] [,2] [,3] [,4] [,5]
[1,]    1    1    1    2    2
[2,]    1    1    2    2    2
> which(a==2,arr.ind = TRUE)
     row col
[1,]   2   3
[2,]   1   4
[3,]   2   4
[4,]   1   5
[5,]   2   5


