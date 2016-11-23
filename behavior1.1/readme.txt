
1.四类分类识别率 60%,62.5%,57.5%,62.5%,55%

测试集中41~50的图像，识别错误编号
'Phoning','PlayingGuitar' 80%,85%,75%
(1)P 3.5.6;   p 10
(2)P 3.5;     p 10
(3)P 3.5.7.9; p 10
'Phoning','RidingBike'  90%,90%,90%
(1)P 3.5;R
(2)P 3.5;R
(3)P 3.5;R
'Phoning','RidingHorse' 70%,75%,70%
(1)P 3.5.;R 4.6.8.10
(2)P 3.5.;R 6.8.10
(3)P 3.5.;R 4.6.8.10
'PlayingGuitar','RidingHorse' 50%,55%,55%
(1)P 4.5.6.7.8.9.10;R 2.4.8
(2)P 4.5.6.7.8.9.10;R 2.4
(3)P 4.5.6.8.9.10;R 2.4.6
'PlayingGuitar','RidingBike' 75%,70%,70%
(1)P 4.5.7.8;R 6
(2)P 4.5.7.8.9;R 6
(3)P 4.5.7.8;R 6.10
'RidingBike','RidingHorse' 65%,70%,75%
(1)R 6;    r 1.2.3.5.7.9
(2)R 6;    r 1.2.5.7
(3)R 6.7;  r 1.2.5

2.分类出现错误的图像
'Phoning':3.5.6.7.9
'PlayingGuitar':4.5.6.7.8.9.10
'RidingBike':6.7.10
'RidingHorse':1.2.3.4.5.6.7.8.9.10

3.将其中分类错误的图像添加到各自的训练集中;
4.使用50~60作为测试集，四类分类识别率 70%,65%,60%,67.5%,70%

5.'Phoning','PlayingGuitar' 75%,70%,70%
'Phoning','RidingBike' 85%,85%,85%
'Phoning','RidingHorse' 85%,85%,80%
'PlayingGuitar','RidingHorse' 90%,90%,90%
'PlayingGuitar','RidingBike' 90%,90%,90%
'RidingBike','RidingHorse' 90%,90%,90%
6.只有'Phoning','PlayingGuitar';'Phoning','RidingBike'两组识别率有5%左右的下降，其它都明显提升。四类识别率有提升。
在每组中，识别错误的图像编号基本不变，又可能是图像目标与背景融合不易识别


