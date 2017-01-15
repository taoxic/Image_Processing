img=imread('c_lm_29.bmp');
%   img=imread('c_gc_40.bmp');
% img=imread('c_cqj_37.bmp');

k = 1;
% 增强对比度
J = imadjust(img,[0.05 0.45],[]);

imwrite(J,strcat('result',num2str(k),'.bmp'));
figure,imshow(J), title('result1')

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
k= k+1;
imwrite(I,strcat('result',num2str(k),'.bmp'));
figure,imshow(I), title('result2')


%灰度转二值
I = imadjust(I,[0.05 0.8],[]);
img=im2bw(I,0.5);
k= k+1;
imwrite(img,strcat('result',num2str(k),'.bmp'));
figure,imshow(img), title('result3')


%去掉图像中面积小于8的区域
f=bwareaopen(img,8);

k= k+1;
imwrite(f,strcat('result',num2str(k),'.bmp'));

figure,imshow(f), title('result4')


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
k= k+1;
imwrite(im,strcat('result',num2str(k),'.bmp'));
figure,imshow(im), title('result5')


% 对图像进行膨胀处理，使所有的血管连为整体
se = strel('disk',3);
I = imdilate(im,se);
k= k+1;
imwrite(I,strcat('result',num2str(k),'.bmp'));
figure,imshow(I), title('result6')


% 去除孤立于血管外的点
T=bwareaopen(I,10000);%去掉图像中面积小于1500的区域
k= k+1;
imwrite(T,strcat('result',num2str(k),'.bmp'));
figure,imshow(T), title('result7')

% 两个图像相减取绝对值，得到去除的图像块
[rows, cols] = size(I); 
X = abs(I-T-ones(rows, cols));
k= k+1;
imwrite(X,strcat('result',num2str(k),'.bmp'));
figure,imshow(X), title('result8')

% 将已经去除的图像块应用到im上
re = im.*X;
k= k+1;
imwrite(re,strcat('result',num2str(k),'.bmp'));
figure,imshow(re), title('result9')

