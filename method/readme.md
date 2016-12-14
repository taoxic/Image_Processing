#图像处理的方法

##一、分水岭分割算法
###1、定义
	如果图像中的目标物体是连在一起的，则分割起来会更困难，分水岭算法经常用于处理这类问题，<br>
通常会取得比较好的效果。分水岭分割算法把图像看成一副“地形图”，其中亮度比较强的地区像素值较大，<br>
而比较暗的地区像素比较小，通过寻找`汇水盆地`和`分水岭界限`，对图像进行分割。<br>
[引用博客](http://blog.csdn.net/zd0303/article/details/6703068"csdn blog")<br>
![](https://github.com/taoxic/matlab/raw/master/method/img/lena.jpg)



