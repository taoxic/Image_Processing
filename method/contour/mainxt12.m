% 轮廓提取

%读取图像
img=imread('imagex/testing/RidingBike/RidingBike_0058.jpg');
%转灰度
% img=rgb2gray(img);
if ndims(img) == 3
    img = rgb2gray(img);
end

% 迭代法阈值分割法的确定阈值
I = im2double(img);
T = 0.5 * (min(I(:))+max(I(:)));%收敛阈值
U = false;
while ~U
    g = I >= T;
    TT = 0.5 * (mean(I(g))+mean(I(~g)));
    if (abs(T - TT)< 0.1) %其中T为收敛阈值，不同的T值下，图像分割效果不同。
       U = 1;
    end
    T = TT;
end


%灰度转二值
img=im2bw(img,T);

%该函数用于填充图像区域和“空洞 v
img=imfill(~img,'hole');

figure
imshow(img)

%构造结构元素
str=strel('disk',6);
%形态学操作腐蚀
img=imerode(~img,str);
% 删除二值图像中面积小于P的对象，默认情况下conn使用8邻域
img=bwareaopen(~img,100);
%膨胀图像
img=imdilate(~img,str);
img=imdilate(img,str);
img=imerode(img,str);

figure
imshow(img)
% bwarea(img) 

str=strel('disk',2);
img1=imerode(img,str);
img2=img-img1;

%获取图像的局部属性
L=bwlabel(img2,8);%化为标志矩阵  
stat=regionprops(L,'all')%图像局部属性  
% 
% figure
% imshow(img2)