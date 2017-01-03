img=imread('37.jpg');

if ndims(img) == 3
    img = rgb2gray(img);
end

% % 灰度直方图波谷中的最小值
% img(img<100&img>50) = 254;
% figure,imshow(img);

% 增强对比度,可以根据直方图确定值
J = imadjust(img,[0.05 0.45],[]);
% figure,imshow(J);
I = J;




% I = Iobr;
%创建一个二维的预定义的滤波算子hy，sobel用于边缘提取，无参数
hy = fspecial('sobel');
hx = hy';
% 对任意类型数组或多维图像进行滤波，‘replicate’图像大小通过复制外边界的值来扩展
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

I = uint8(gradmag);
% figure,imshow(I);

% imshow(gradmag,[0 848])


            

% h=medfilt2(img);                 %对椒盐躁声中值滤波

% figure;
% hist_im=imhist(I); %计算直方图
% bar(hist_im);%画直方图

% 灰度直方图波谷中的最小值
% img(img<100&img>50) = 254;
% figure,imshow(img);

% J = imadjust(I,[0.5 0.7],[]);
% figure,imshow(J);
% 
% I = J;
%灰度转二值
img=im2bw(I,0.6);

% h=medfilt2(img);                 %对椒盐躁声中值滤波

figure,imshow(img)


f=bwareaopen(h,2);%去掉图像中面积小于10的区域


figure,imshow(f)

% g=imdilate(f,strel('disk',2));figure,imshow(g)

% se = strel('disk',2);
% imgclosed=imclose(img,se);
% figure,imshow(imgclosed);


