上一期介绍了读取：
 
-  [csv格式](http://blog.csdn.net/xxzhangx/article/details/53066300)

这期介绍读取excel文件。代码如下：
```
library(readxl)
dataset <- read_excel(NULL)
View(dataset)
```

关于read_excel 函数，见其帮助文档


前面介绍了另外一种读取excel文件的方式，可以对比下。
采用gdata包来读取。

- [gdata包读取excel文件](http://blog.csdn.net/xxzhangx/article/details/52557289)
