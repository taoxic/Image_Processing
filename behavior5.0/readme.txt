每一类共60个样本，48个训练样本，12个测试样本

(1)
SIFT特征识别率：
    二分类识别率：
		'Phoning','PlayingGuitar'：70.83%
		'Phoning','RidingBike'：87.50%
		'Phoning','RidingHorse'：83.33%
		'RidingHorse','RidingBike'：91.67%
		'RidingHorse','PlayingGuitar'：79.17%
		'RidingBike','PlayingGuitar':87.50%
    四分类识别率：
		'Phoning','PlayingGuitar','RidingBike','RidingHorse'：54.17%，58.33%，62.5%

PCA识别率：
    二分类识别率：
		'Phoning','PlayingGuitar'：79.17%
		'Phoning','RidingBike'：70.83%
		'Phoning','RidingHorse'：66.67%
		'RidingHorse','RidingBike'：54.17%
		'RidingHorse','PlayingGuitar'：66.67%
		'RidingBike','PlayingGuitar':83.33%
    四分类识别率：
		'Phoning','PlayingGuitar','RidingBike','RidingHorse'：52.08%
		
		
(2)	
'Phoning','PlayingGuitar'实验结果：

	SIFT特征使用svm分类：
	
	1    		 1  	   1   		  2  	   1    	 1    	 2   		  1  	   1   		  1  	   1    	 1
	0.1020    0.4588    0.7947   -0.4090    1.1726    0.6778   -0.2755    1.1373    0.8019    0.6987    0.9453    0.3087
    2    		 1     		2    	 2   	  2    		 2    	 1   		  1    		1    	  2		   2  	     2
	-0.7592   0.1227   -0.1489   -0.7449   -0.6469   -0.2742    0.2827    0.3579    0.5329   -0.1439   -0.5390   -0.4056
	

	PCA分类：
	1     2     3     4     5     6     7     8    9     10     11     12 
	
	1     1     2     2     2     1     2     1     2     1     1     1 
	283.9885  270.0742  289.5770  240.6667  291.6276  176.3800  253.7002  517.0821  427.2638  150.4979  509.6307  408.9545 
	2     2     2     2     2     2     2     2     2     2     2     2
	215.8463  165.8953  232.3929  248.8813  324.2447  381.2257  296.7449  203.9765  654.2746  283.1329  229.3559  241.4977
	
	
	错误分类：
	SIFT:
                        4         7
    'Phoning'        -0.409   -0.2755
	                    2         7       8        9
	'PlayingGuitar'   0.1227   0.2827   0.3579   0.5329
	
	PCA:   
    'Phoning'           3,4,5,7,9       
	'PlayingGuitar'        无
	
'RidingHorse','RidingBike'实验结果：

	SIFT特征使用svm分类：
	
	
	   1          1        1         2         1        1          1         1        2         1         1         1
	0.5672    0.0378    0.5314   -0.8460    0.4730    0.2809    0.5062    0.5145   -0.0367    0.3328    0.5195    0.3302
	   2          2        2         1         2        2          2         2        2         2         2         2
   -0.0726   -0.6759   -0.7423    0.0816   -0.6037   -0.5689   -0.1865   -0.5907   -0.0754   -0.3031   -0.3477   -0.6113

   
	PCA分类：
	 1     2     3     4     5     6     7     8     9     10     11    12 
	 2     1     1     1     2     2     2     1     2     2      1     2
     2     2     2     1     2     1     2     1     2     2      1     2

	错误分类：
	SIFT:
	
	'RidingHorse'      4        9
					-0.8460  -0.0367 
	'RidingBike'       4        
	                 0.0816

	PCA:   
    'Phoning'           1,5,7,8,9,10,12       
	'PlayingGuitar'     4,6,8,11




(3)
先经过SIFT+libsvm后PCA+最近邻的二次处理

二分类识别率：
		'Phoning','PlayingGuitar'：83.33%,70.83%,75.00% ++
		'Phoning','RidingBike'：58.33% --
		'Phoning','RidingHorse'：83.33% 
		'RidingHorse','RidingBike'：83.33%  --
		'RidingHorse','PlayingGuitar'：66.67% 
		'RidingBike','PlayingGuitar':87.50%
四分类识别率：
		'Phoning','PlayingGuitar','RidingBike','RidingHorse'：40.63% --
		



		
		
		
		
		