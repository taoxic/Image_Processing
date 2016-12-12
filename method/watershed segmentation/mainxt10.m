   %分水岭算法  
clc; clear all; close all;
rgb = imread('imagex/testing/RidingBike/RidingBike_0057.jpg');
if ndims(rgb) == 3
    I = rgb2gray(rgb);
else
    I = rgb;
end

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 2, 1); imshow(rgb); title('原图');
% subplot(1, 2, 2); imshow(I); title('灰度图');



%  使用Sobel边缘算子对图像进行水平和垂直方向的滤波，然后求取模值，
% sobel算子滤波后的图像在边界处会显示比较大的值，在没有边界处的值会很小

%创建一个二维的预定义的滤波算子hy，sobel用于边缘提取，无参数
hy = fspecial('sobel');
hx = hy';
% 对任意类型数组或多维图像进行滤波，‘replicate’图像大小通过复制外边界的值来扩展
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

figure('units', 'normalized', 'position', [0 0 1 1]);
subplot(1, 2, 1); imshow(I,[]), title('灰度图像')
subplot(1, 2, 2); imshow(gradmag,[]), title('梯度幅值图像')


 
L = watershed(gradmag);
Lrgb = label2rgb(L);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 2, 1); imshow(gradmag,[]), title('梯度幅值图像')
% subplot(1, 2, 2); imshow(Lrgb); title('梯度幅值做分水岭变换')
 
se = strel('disk', 5);%20
Io = imopen(I, se);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 2, 1); imshow(I, []); title('灰度图像');
% subplot(1, 2, 2); imshow(Io), title('图像开操作')


Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
% 
% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 2, 1); imshow(I, []); title('灰度图像');
% subplot(1, 2, 2); imshow(Iobr, []), title('基于开的重建图像')
 
Ioc = imclose(Io, se);
% Ic = imclose(I, se);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(2, 2, 1); imshow(I, []); title('灰度图像');
% subplot(2, 2, 2); imshow(Io, []); title('开操作图像');
% subplot(2, 2, 3); imshow(Ic, []); title('闭操作图像');
% subplot(2, 2, 4); imshow(Ioc, []), title('开闭操作');

 
Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(2, 2, 1); imshow(I, []); title('灰度图像');
% subplot(2, 2, 2); imshow(Ioc, []); title('开闭操作');
% subplot(2, 2, 3); imshow(Iobr, []); title('基于开的重建图像');
% subplot(2, 2, 4); imshow(Iobrcbr, []), title('基于闭的重建图像');
 
fgm = imregionalmax(Iobrcbr);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 3, 1); imshow(I, []); title('灰度图像');
% subplot(1, 3, 2); imshow(Iobrcbr, []); title('基于重建的开闭操作');
% subplot(1, 3, 3); imshow(fgm, []); title('局部极大图像');
 
It1 = rgb(:, :, 1);
It2 = rgb(:, :, 2);
It3 = rgb(:, :, 3);
It1(fgm) = 255; It2(fgm) = 0; It3(fgm) = 0;
I2 = cat(3, It1, It2, It3);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(2, 2, 1); imshow(rgb, []); title('原图像');
% subplot(2, 2, 2); imshow(Iobrcbr, []); title('基于重建的开闭操作');
% subplot(2, 2, 3); imshow(fgm, []); title('局部极大图像');
% subplot(2, 2, 4); imshow(I2); title('局部极大叠加到原图像');
 
se2 = strel(ones(5,5));
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(2, 2, 1); imshow(Iobrcbr, []); title('基于重建的开闭操作');
% subplot(2, 2, 2); imshow(fgm, []); title('局部极大图像');
% subplot(2, 2, 3); imshow(fgm2, []); title('闭操作');
% subplot(2, 2, 4); imshow(fgm3, []); title('腐蚀操作');
 
fgm4 = bwareaopen(fgm3, 20);
It1 = rgb(:, :, 1);
It2 = rgb(:, :, 2);
It3 = rgb(:, :, 3);
It1(fgm4) = 255; It2(fgm4) = 0; It3(fgm4) = 0;
I3 = cat(3, It1, It2, It3);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(2, 2, 1); imshow(I2, []); title('局部极大叠加到原图像');
% subplot(2, 2, 2); imshow(fgm3, []); title('闭腐蚀操作');
% subplot(2, 2, 3); imshow(fgm4, []); title('去除小斑点操作');
% subplot(2, 2, 4); imshow(I3, []); title('修改局部极大叠加到原图像');

 
bw = im2bw(Iobrcbr, graythresh(Iobrcbr));

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 2, 1); imshow(Iobrcbr, []); title('基于重建的开闭操作');
% subplot(1, 2, 2); imshow(bw, []); title('阈值分割');
 
D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(2, 2, 1); imshow(Iobrcbr, []); title('基于重建的开闭操作');
% subplot(2, 2, 2); imshow(bw, []); title('阈值分割');
% subplot(2, 2, 3); imshow(label2rgb(DL), []); title('分水岭变换示意图');
% subplot(2, 2, 4); imshow(bgm, []); title('分水岭变换脊线图');
 
gradmag2 = imimposemin(gradmag, bgm | fgm4);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(2, 2, 1); imshow(bgm, []); title('分水岭变换脊线图');
% subplot(2, 2, 2); imshow(fgm4, []); title('前景标记');
% subplot(2, 2, 3); imshow(gradmag, []); title('梯度幅值图像');
% subplot(2, 2, 4); imshow(gradmag2, []); title('修改梯度幅值图像');

L = watershed(gradmag2);

 
It1 = rgb(:, :, 1);
It2 = rgb(:, :, 2);
It3 = rgb(:, :, 3);
fgm5 = imdilate(L == 0, ones(3, 3)) | bgm | fgm4;
It1(fgm5) = 255; It2(fgm5) = 0; It3(fgm5) = 0;
I4 = cat(3, It1, It2, It3);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 2, 1); imshow(rgb, []); title('原图像');
% subplot(1, 2, 2); imshow(I4, []); title('标记和对象边缘叠加到原图像');
 
Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 2, 1); imshow(rgb, []); title('原图像');
% subplot(1, 2, 2); imshow(Lrgb); title('彩色分水岭标记矩阵');

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 2, 1); imshow(rgb, []); title('原图像');
% subplot(1, 2, 2); imshow(rgb, []); hold on;
% himage = imshow(Lrgb);
% set(himage, 'AlphaData', 0.3);
% title('标记矩阵叠加到原图像');