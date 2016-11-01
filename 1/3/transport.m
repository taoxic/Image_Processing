
load trees%装载图像，工作区生成caption,X,map数据
I = ind2gray(X,map);%将图像转换为灰度图像，去除色调和饱和度信息
imshow(X,map)%显示原始图像
figure,imshow(I);

load trees %装载图像
%converts the indexed image X with colormap map to a binary image
BW = im2bw(X,map,0.4);%将索引色图像进行阈值为0.4的二值化处理
imshow(X,map)
figure, imshow(BW)

I8 = imread('snowflakes.png');%读入图像
X8 = grayslice(I8,16);%将灰度图像转换为索引色图像
imshow(I8) 
%jet是M软件预定义的色图矩阵，表示蓝头红尾饱和色 map
figure,imshow(X8,jet(16))


