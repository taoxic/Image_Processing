% image=imread('c_lm_29.bmp');
%   image=imread('c_gc_40.bmp');
image=imread('c_cqj_37.bmp');


k = 1;
% 增强对比度
J = imadjust(image,[0.05 0.45],[]);

figure,imshow(image), title('result')
I = J;

% 使用sobel提取边缘
%创建一个二维的预定义的滤波算子hy，sobel用于边缘提取，无参数
hy = fspecial('sobel');
hx = hy';
% 对任意类型数组或多维图像进行滤波，‘replicate’图像大小通过复制外边界的值来扩展
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
I = uint8(gradmag);

%灰度转二值
I = imadjust(I,[0.05 0.8],[]);
img=im2bw(I,0.5);

%去掉图像中面积小于8的区域
f=bwareaopen(img,8);

% 根据patch块中图像值和的大小去噪
im = double(f);
patchSize = 16;%16
patchSize1 = 12;
[rows, cols] = size(im); 
 numpatch = floor(rows/patchSize);

%先用16*16的块，10的阈值处理
for i = 1:numpatch-1
    for j = 1:numpatch-1
         block = im(i*patchSize+1:(i+1)*patchSize,j*patchSize+1:(j+1)*patchSize);
%          block1 = im(i*patchSize+1:(i+1)*patchSize,j*patchSize+1:(j+1)*patchSize);
%      block = img(1:patchSize,1:patchSize);
      a = sum(sum(block));
      if a<30%10
        im(i*patchSize+1:(i+1)*patchSize,j*patchSize+1:(j+1)*patchSize) = zeros(patchSize,patchSize);
%         figure,imshow(im);
      end
    end
end 

% 对图像进行膨胀处理，使所有的血管连为整体
se = strel('disk',3);
I = imdilate(im,se);

% 去除孤立于血管外的点
T=bwareaopen(I,10000);%去掉图像中面积小于1500的区域

% 两个图像相减取绝对值，得到去除的图像块
[rows, cols] = size(I); 
X = abs(I-T-ones(rows, cols));

% 将已经去除的图像块应用到im上
re = im.*X;

k = 1;
% 对图像进行膨胀处理，使所有的血管连为整体
se = strel('disk',5);
I = imdilate(re,se);

imwrite(I,strcat('result',num2str(k),'.bmp'));

%将血管块T应用到原图image
im = im2double(image);
T = im.*I;

k= k+1;
imwrite(T,strcat('result',num2str(k),'.bmp'));

%对整张图进行均值滤波,取出除血管外的图像块
A = filter2(fspecial('average',15),image)/255; 
I1= abs(I-ones(rows, cols));
T1 = A.*I1;

k= k+1;
imwrite(T1,strcat('result',num2str(k),'.bmp'));

%将T和T1进行组合
T2 = T+T1;
figure, imshow(T2);

k= k+1;
imwrite(T2,strcat('result',num2str(k),'.bmp'));

%frangi滤波器
I = T2.*255;
options  = struct('FrangiScaleRange', [1 10], 'FrangiScaleRatio', 2, 'FrangiBetaOne', 0.5, 'FrangiBetaTwo', 15, 'verbose',true,'BlackWhite',true);
Ivessel=FrangiFilter2D(I,options);


k= k+1;
imwrite(Ivessel,strcat('result',num2str(k),'.bmp'));

figure,
subplot(1,2,1), imshow(I,[]);
subplot(1,2,2), imshow(Ivessel);





