   %��ˮ���㷨  
clc; clear all; close all;
rgb = imread('imagex/testing/RidingBike/RidingBike_0057.jpg');
if ndims(rgb) == 3
    I = rgb2gray(rgb);
else
    I = rgb;
end

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 2, 1); imshow(rgb); title('ԭͼ');
% subplot(1, 2, 2); imshow(I); title('�Ҷ�ͼ');



%  ʹ��Sobel��Ե���Ӷ�ͼ�����ˮƽ�ʹ�ֱ������˲���Ȼ����ȡģֵ��
% sobel�����˲����ͼ���ڱ߽紦����ʾ�Ƚϴ��ֵ����û�б߽紦��ֵ���С

%����һ����ά��Ԥ������˲�����hy��sobel���ڱ�Ե��ȡ���޲���
hy = fspecial('sobel');
hx = hy';
% ����������������άͼ������˲�����replicate��ͼ���Сͨ��������߽��ֵ����չ
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

figure('units', 'normalized', 'position', [0 0 1 1]);
subplot(1, 2, 1); imshow(I,[]), title('�Ҷ�ͼ��')
subplot(1, 2, 2); imshow(gradmag,[]), title('�ݶȷ�ֵͼ��')


 
L = watershed(gradmag);
Lrgb = label2rgb(L);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 2, 1); imshow(gradmag,[]), title('�ݶȷ�ֵͼ��')
% subplot(1, 2, 2); imshow(Lrgb); title('�ݶȷ�ֵ����ˮ��任')
 
se = strel('disk', 5);%20
Io = imopen(I, se);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 2, 1); imshow(I, []); title('�Ҷ�ͼ��');
% subplot(1, 2, 2); imshow(Io), title('ͼ�񿪲���')


Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
% 
% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 2, 1); imshow(I, []); title('�Ҷ�ͼ��');
% subplot(1, 2, 2); imshow(Iobr, []), title('���ڿ����ؽ�ͼ��')
 
Ioc = imclose(Io, se);
% Ic = imclose(I, se);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(2, 2, 1); imshow(I, []); title('�Ҷ�ͼ��');
% subplot(2, 2, 2); imshow(Io, []); title('������ͼ��');
% subplot(2, 2, 3); imshow(Ic, []); title('�ղ���ͼ��');
% subplot(2, 2, 4); imshow(Ioc, []), title('���ղ���');

 
Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(2, 2, 1); imshow(I, []); title('�Ҷ�ͼ��');
% subplot(2, 2, 2); imshow(Ioc, []); title('���ղ���');
% subplot(2, 2, 3); imshow(Iobr, []); title('���ڿ����ؽ�ͼ��');
% subplot(2, 2, 4); imshow(Iobrcbr, []), title('���ڱյ��ؽ�ͼ��');
 
fgm = imregionalmax(Iobrcbr);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 3, 1); imshow(I, []); title('�Ҷ�ͼ��');
% subplot(1, 3, 2); imshow(Iobrcbr, []); title('�����ؽ��Ŀ��ղ���');
% subplot(1, 3, 3); imshow(fgm, []); title('�ֲ�����ͼ��');
 
It1 = rgb(:, :, 1);
It2 = rgb(:, :, 2);
It3 = rgb(:, :, 3);
It1(fgm) = 255; It2(fgm) = 0; It3(fgm) = 0;
I2 = cat(3, It1, It2, It3);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(2, 2, 1); imshow(rgb, []); title('ԭͼ��');
% subplot(2, 2, 2); imshow(Iobrcbr, []); title('�����ؽ��Ŀ��ղ���');
% subplot(2, 2, 3); imshow(fgm, []); title('�ֲ�����ͼ��');
% subplot(2, 2, 4); imshow(I2); title('�ֲ�������ӵ�ԭͼ��');
 
se2 = strel(ones(5,5));
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(2, 2, 1); imshow(Iobrcbr, []); title('�����ؽ��Ŀ��ղ���');
% subplot(2, 2, 2); imshow(fgm, []); title('�ֲ�����ͼ��');
% subplot(2, 2, 3); imshow(fgm2, []); title('�ղ���');
% subplot(2, 2, 4); imshow(fgm3, []); title('��ʴ����');
 
fgm4 = bwareaopen(fgm3, 20);
It1 = rgb(:, :, 1);
It2 = rgb(:, :, 2);
It3 = rgb(:, :, 3);
It1(fgm4) = 255; It2(fgm4) = 0; It3(fgm4) = 0;
I3 = cat(3, It1, It2, It3);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(2, 2, 1); imshow(I2, []); title('�ֲ�������ӵ�ԭͼ��');
% subplot(2, 2, 2); imshow(fgm3, []); title('�ո�ʴ����');
% subplot(2, 2, 3); imshow(fgm4, []); title('ȥ��С�ߵ����');
% subplot(2, 2, 4); imshow(I3, []); title('�޸ľֲ�������ӵ�ԭͼ��');

 
bw = im2bw(Iobrcbr, graythresh(Iobrcbr));

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 2, 1); imshow(Iobrcbr, []); title('�����ؽ��Ŀ��ղ���');
% subplot(1, 2, 2); imshow(bw, []); title('��ֵ�ָ�');
 
D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(2, 2, 1); imshow(Iobrcbr, []); title('�����ؽ��Ŀ��ղ���');
% subplot(2, 2, 2); imshow(bw, []); title('��ֵ�ָ�');
% subplot(2, 2, 3); imshow(label2rgb(DL), []); title('��ˮ��任ʾ��ͼ');
% subplot(2, 2, 4); imshow(bgm, []); title('��ˮ��任����ͼ');
 
gradmag2 = imimposemin(gradmag, bgm | fgm4);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(2, 2, 1); imshow(bgm, []); title('��ˮ��任����ͼ');
% subplot(2, 2, 2); imshow(fgm4, []); title('ǰ�����');
% subplot(2, 2, 3); imshow(gradmag, []); title('�ݶȷ�ֵͼ��');
% subplot(2, 2, 4); imshow(gradmag2, []); title('�޸��ݶȷ�ֵͼ��');

L = watershed(gradmag2);

 
It1 = rgb(:, :, 1);
It2 = rgb(:, :, 2);
It3 = rgb(:, :, 3);
fgm5 = imdilate(L == 0, ones(3, 3)) | bgm | fgm4;
It1(fgm5) = 255; It2(fgm5) = 0; It3(fgm5) = 0;
I4 = cat(3, It1, It2, It3);

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 2, 1); imshow(rgb, []); title('ԭͼ��');
% subplot(1, 2, 2); imshow(I4, []); title('��ǺͶ����Ե���ӵ�ԭͼ��');
 
Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 2, 1); imshow(rgb, []); title('ԭͼ��');
% subplot(1, 2, 2); imshow(Lrgb); title('��ɫ��ˮ���Ǿ���');

% figure('units', 'normalized', 'position', [0 0 1 1]);
% subplot(1, 2, 1); imshow(rgb, []); title('ԭͼ��');
% subplot(1, 2, 2); imshow(rgb, []); hold on;
% himage = imshow(Lrgb);
% set(himage, 'AlphaData', 0.3);
% title('��Ǿ�����ӵ�ԭͼ��');