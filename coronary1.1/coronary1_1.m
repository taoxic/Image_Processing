img=imread('c_lm_29.jpg');

if ndims(img) == 3
    img = rgb2gray(img);
end


% 增强对比度,可以根据直方图确定值
J = imadjust(img,[0.05 0.45],[]);
I = J;

se = strel('disk', 5);%20
Io = imopen(I, se);


Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
figure, imshow(Iobr, []), title('基于开的重建图像')


%创建一个二维的预定义的滤波算子hy，sobel用于边缘提取，无参数
hy = fspecial('sobel');
hx = hy';
% 对任意类型数组或多维图像进行滤波，‘replicate’图像大小通过复制外边界的值来扩展
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

I = uint8(gradmag);

%灰度转二值
img=im2bw(I,0.6);

% h=medfilt2(img);                 %对椒盐躁声中值滤波

figure,imshow(img)

f=bwareaopen(img,2);%去掉图像中面积小于2的区域

figure,imshow(f)

im = double(f);


%将图像进行分块去噪处理
patchSize = 16;
patchSize1 = 8;
[rows, cols] = size(im); 

 numpatch = floor(rows/patchSize);


for i = 1:numpatch-1
    for j = 1:numpatch-1
         block = im(i*patchSize+1:(i+1)*patchSize,j*patchSize+1:(j+1)*patchSize);
%          block1 = im(i*patchSize+1:(i+1)*patchSize,j*patchSize+1:(j+1)*patchSize);
%      block = img(1:patchSize,1:patchSize);
      a = sum(sum(block));
      if a<10
        im(i*patchSize+1:(i+1)*patchSize,j*patchSize+1:(j+1)*patchSize) = zeros(16,16);
      end
    end

end 

figure,imshow(im);


