img=imread('37.jpg');

if ndims(img) == 3
    img = rgb2gray(img);
end

% % �Ҷ�ֱ��ͼ�����е���Сֵ
% img(img<100&img>50) = 254;
% figure,imshow(img);

% ��ǿ�Աȶ�,���Ը���ֱ��ͼȷ��ֵ
J = imadjust(img,[0.05 0.45],[]);
% figure,imshow(J);
I = J;




% I = Iobr;
%����һ����ά��Ԥ������˲�����hy��sobel���ڱ�Ե��ȡ���޲���
hy = fspecial('sobel');
hx = hy';
% ����������������άͼ������˲�����replicate��ͼ���Сͨ��������߽��ֵ����չ
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

I = uint8(gradmag);
% figure,imshow(I);

% imshow(gradmag,[0 848])


            

% h=medfilt2(img);                 %�Խ���������ֵ�˲�

% figure;
% hist_im=imhist(I); %����ֱ��ͼ
% bar(hist_im);%��ֱ��ͼ

% �Ҷ�ֱ��ͼ�����е���Сֵ
% img(img<100&img>50) = 254;
% figure,imshow(img);

% J = imadjust(I,[0.5 0.7],[]);
% figure,imshow(J);
% 
% I = J;
%�Ҷ�ת��ֵ
img=im2bw(I,0.6);

% h=medfilt2(img);                 %�Խ���������ֵ�˲�

figure,imshow(img)


f=bwareaopen(h,2);%ȥ��ͼ�������С��10������


figure,imshow(f)

% g=imdilate(f,strel('disk',2));figure,imshow(g)

% se = strel('disk',2);
% imgclosed=imclose(img,se);
% figure,imshow(imgclosed);


