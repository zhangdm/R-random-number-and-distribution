最近Rsudio更新https://www.rstudio.com/products/rstudio/download/了，对我们常用的几种文件格式都作用了封装，直接点击按钮就可以对文件读取啦，感觉好强大好神奇的说。下面来一个个的给出代码!


```
library(readr)
dataset <- read_csv(NULL)
View(dataset)
```

当然，你也许会问，已经有了read.csv函数，为啥还要read_csv函数呢？据查，read_csv读取的速度比read.csv快很多，效率更加的高！






111[这里写链接内容](12)