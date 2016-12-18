将SIFT和HOG特征进行前期融合，再用BOW模型处理，最后用libsvm分类

方法：将图像分为16*16的patch，先提取sift特征点，如果可以sift特征，再提取hog特征，将其组合为一个Features

运行时间：二分类为25min左右，三分类为37min左右




结果：

二分类：
'Phoning','PlayingGuitar'    75% 
'PlayingGuitar','RidingHorse'  72.5%
'Phoning','RidingHorse'  72.5%    

三分类：60%



与只用SIFT比较：
'Phoning','PlayingGuitar'    75%   识别率下降5%左右
'PlayingGuitar','RidingHorse'  72.5%  提升18%左右
'Phoning','RidingHorse'  基本持平   