将SIFT和HOG特征进行前期融合，再用BOW模型处理，最后用libsvm分类

方法：将图像分为16*16的patch，先提取sift特征点，如果可以sift特征，再提取hog特征，将其组合为一个Features

运行时间：二分类为25min左右

结果：
'Phoning','PlayingGuitar'     
'PlayingGuitar','RidingHorse'  
'Phoning','RidingHorse'  72.5%
