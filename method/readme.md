#图像处理的方法

##一、纸袋模型(BOW)[1]
BOW模型实现将高维数据转换为低维的方法。首先将原来数据使用k-means进行聚类，找到适当的聚类中心点<br>
再将原来数据向聚类中心映射，得到每一个原来高维数据在聚类中心空间的一个低维的表示。<br>
##二、BP神经网络(BP neural network)
BP神经网络是一种多层前馈神经网络，该网络的主要特点是信号前向传递，误差反向传递。在前向传递中，<br>
输入信号从输入层经隐含层逐层处理，直至输出层。每一层的神经元状态只影响下一层神经元的状态，如果<br>
输出层得不到期望的输出，则转入反向传播，根据预测误差调整网络权值和阈值，从而使BP神经网络预测输出<br>
不断逼近期望输出。<br>[2]
修改权值有不同的规则，标准的BP神经网络沿着误差性能函数梯度的反方向修改权值，属于最速下降法。在实际中，<br>
数据量如果比较小，就有可能在找不到使误差最小的点，任意陷入局部最优，甚至于分类失败。<br>
其中参数设定比较多，并且参数的选择没有有效的方法。一般是根据经验或者通过反复实验确定。因此，网络往往<br>
存在很大的冗余性，在一定程度上也增加了网络学习的负担。<br>
##三、尺度不变特征变换(SIFT)[3]
SIFT特征具有尺度不变性，可以在图像中检测出关键点，是一种局部特征描述子。SIFT特征是基于物体上的一些<br>
局部外观的兴趣点而与影像的大小和旋转无关。<br>
##四、决策树(decision tree)[4]
决策树是一个树形结构。每一个非叶子节点表示一个特征属性的判别条件，每个叶节点存放一个类别。使用决策树的<br>
过程就是从根节点开始，输入特征向量，判别特征中相应的特征属性，并按照其值选择不同的输出分支，从而到达不同<br>
的叶子节点，叶子节点存放的类别即为决策结果。<br>
利用了matlab中的fitctree来构造决策树，采用的是CART算法。
##五、特征融合(feature combination)[5]
特征融合分为前期融合和后期融合。前期融合就是将多种特征向量直接拼接组合为新的特征向量，直接拼接的效果<br>
不是很好。还可以通过给特征赋给一定权值，方式就是通过分类的正确率迭代的确定权值，以达到满意的分类效果。<br>
后期融合为多核学习是针对svm分类来实现的，首先将特征向量分别选取对应效果好的核函数进行处理，到高维空间再通过一定权值<be>
将其结合起来。
##六、方向梯度直方图(HOG)[6]
HOG是用来进行物体检测的特征描述子。通过计算和统计图像局部区域的梯度方向直方图来构成特征。HOG的实现方式是<br>
首先将图像分成小的细胞单元，然后采集细胞单元中各像素点的梯度的或边缘的方向直方图，再把这些直方图结合起来<br>
构成特征描述器。<br>
由于HOG是在图像的局部方格单元上操作，所以它对图像几何的和光学的形变都能保持很好的不变性，两种形变只会出现在<br>
更大的空间领域上。程序采用的是matlab自带的函数extractHOGFeatures()可以直接输出HOG特征，特征的维数和图像<br>
大小有关。
##七、主成因分析(PCA)[7]
PCA（Principal Component Analysis）是一种常用的数据分析方法。PCA通过线性变换将原始数据变换为一组<br>
各维度线性无关的表示，可用于提取数据的主要特征分量，常用于高维数据的降维。<br>
PCA的原理就是把原来的数据样本投影到一个新的空间之中，可以理解为把一组坐标转换到另外一组坐标下，<br>
但是在新的坐标下，表示原来的数据并不需要原来的变量个数，只需要原来数据样本中的最大线性无关组的特<br>
征值对应的坐标就可以了。<br>
也就是说，通过去除信息量比较小或者没有的维数，以达到降维的目的。实际上PCA是丢失原始数据信息最少的<br>
一种线性降维方式。即最接近原始数据，但是PCA并不试图去探索数据内在结构。<br>


[1]Elyasir, Ayoub Mohamed H.; Anbananthen, Kalaiarasi Sonai Muthu "Comparison between Bag of Words and Word Sense Disambiguation" (2015)<br>
[2]Huang, Guang-Bin; Zhu, Qin-Yu; Siew, Chee-Kheong "Extreme learning machine: Theory and applications" (2006)<br>
[3]D.G. Lowe "Distinctive image features from scale-invariant keypoints "Int. J. Comput. Vision, 60 (2004), pp. 91–110<br>
[4]Quinlan J. R "Induction of decision trees" Machine Learning ,(1986),(1),81-106<br>
[5]Tang, Dejun; Zhang, Weishi; Qu, Xiaolu "A Feature Fusion Method for Feature Extraction" (2012)<br>
[6]N. Dalal, Bill. Triggs "Histograms of oriented gradients for human detection" (2005)<br>
[7]Wold et al., 1987S. Wold, K. Esbensen, P. Geladi "Principal component analysis" Chemometrics and Intelligent Laboratory Systems, 2 (1987), pp. 37–52<br>



