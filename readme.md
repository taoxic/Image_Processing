# matlab 图像处理

## 一、对香蕉和苹果的识别
### 1、app_or_ban1.0
matlab自带k-means分割图像，提取sift特征，BOW模型降维，使用自带svm分类。
###2、app_or_ban2.0
在1的基础上更换了提取sift特征的方法。

## 二、对人物行为的识别
### 1、behavior1.0
SIFT+BOW模型+Libsvm<br>
使用图像SIFT特征，再通过BOW模型降维，最后使用libsvm进行分类。
### 2、behavior1.1
对1进行分析。
### 3、behavior2.0
SIFT+BOW模型+BP神经网络<br>
在1的基础上，使用BP神经网络代替libsvm进行特征分类。
### 4、behavior3.0
SIFT+BOW模型+决策树<br>
在1的基础上，使用决策树代替libsvm进行分类。
### 5、behavior4.0
PCA+最近邻分类<br>
直接将图像使用matlab自带的PCA函数形成特征向量，在用最近邻分类器分类。
### 6、behavior5.0
SIFT+BOW模型+Libsvm+PCA+最近邻分类<br>
将1和5结合，对libsvm分类的结果，根据决策值的大小使用5进行二次分类。
### 7、behavior6.0
HOG+Libsvm<br>
提取图像的HOG特征，使用libsvm进行分类。
### 8、behavior7.0
SIFT+HOG+Libsvm<br>
将图像分块后，分别提取SIFT和HOG特征，直接合并后，再使用libsvm进行分类。
### 9、behavior8.0
SIFT+BOW模型+PCA+最近邻分类+改动Libsvm<br>
在1的基础上改动libsvm中多个二分类器的投票结果，加入PCA+最近邻分类的二分类器进行投票。

## 三、图像处理过程方法
### 1、libsvm
libsvm的源码
### 2、method
图像处理方法

## 四、思维导图
![](https://github.com/taoxic/matlab/raw/master/method/img/behavior.png)
