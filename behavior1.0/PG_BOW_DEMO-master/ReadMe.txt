========================================================================
Image Classification using Bag of Words and Spatial Pyramid BoW
Created by Piji Li
Email: pagelee.sd@gmail.com
Blog: http://www.zhizhihu.com
Weibo: http://www.weibo.com/pagecn
10/24/2011

Some code are from:

S. Lazebnik, C. Schmid, and J. Ponce, "Beyond Bags of Features: Spatial 
Pyramid Matching for Recognizing Natural Scene Categories," CVPR 2006.

========================================================================

Use:
1, follow labes/readme to prepare data
2, go to libsvm/: make
3, modify ini.m: rootpath=your demo path, and then run main.m.


The BOW and Dictionary is in the dir:/data/global, size of BOW_sift.mat is (DictionarySize * #images).
Size of dictionary.mat is (DictionarySize *  dim of features).spatial_pyramid.mat is the Spatial Pyramid BoW.


In /data/local is the sift features for each images. 

========================================================================
Classification using BOW rbf_svm
Accuracy = 76.6667% (92/120) (classification)

Classification using histogram intersection kernel svm
Accuracy = 81.6667% (98/120) (classification)

Classification using Pyramid BOW rbf_svm
Accuracy = 82.5% (99/120) (classification)

Classification using Pyramid BOW histogram intersection kernel svm
Accuracy = 90% (108/120) (classification)

========================================================================
Idea from:
S. Lazebnik, C. Schmid, and J. Ponce, "Beyond Bags of Features: Spatial 
Pyramid Matching for Recognizing Natural Scene Categories," CVPR 2006.

Images from:
Li, Piji, and Jun Ma. "What is happening in a still picture?." 
In The First Asian Conference on Pattern Recognition, pp. 32-36. IEEE, 2011.

Piji Li, Jun Ma, Shuai Gao. Actions in Still Web Images: Visualization, Detection and Retrieval. 
The 12th International Conference on Web-Age InformationManagement (WAIM 2011). Springer, 2011.

SVM from: 
Chih-Chung Chang and Chih-Jen Lin, LIBSVM : a library for support vector machines. 
ACM Transactions on Intelligent Systems and Technology, 2:27:1--27:27, 2011. Software available at http://www.csie.ntu.edu.tw/~cjlin/libsvm 
