修改libsvm的关于多类分类过程，通过svmpredict()函数的返回值decision_values，重新执行
svm.cpp中svm_predict_values()函数投票过程，加入基于PCA的二类结果

比较SIFT和PCA分类结果：

基于PCA分类其中'PlayingGuitar','RidingHorse'识别率为75%，明显高于SIFT的55%左右，将其在
投票过程中替换，以提升多类分类的结果


试验结果：{'Phoning','RidingBike','RidingHorse','PlayingGuitar'}四分类
第一次分类结果:Sift识别率为56.25%，改进之后为53.7%
第二次分类结果:Sift识别率为55%，改进之后为53.75%
第三次分类结果:Sift识别率为61.25%，改进之后为56.25%