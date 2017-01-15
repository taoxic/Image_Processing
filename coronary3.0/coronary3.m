% image=imread('c_lm_29.bmp');
%   image=imread('c_gc_40.bmp');
image=imread('c_cqj_37.bmp');


k = 1;
% ��ǿ�Աȶ�
J = imadjust(image,[0.05 0.45],[]);

figure,imshow(image), title('result')
I = J;

% ʹ��sobel��ȡ��Ե
%����һ����ά��Ԥ������˲�����hy��sobel���ڱ�Ե��ȡ���޲���
hy = fspecial('sobel');
hx = hy';
% ����������������άͼ������˲�����replicate��ͼ���Сͨ��������߽��ֵ����չ
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
I = uint8(gradmag);

%�Ҷ�ת��ֵ
I = imadjust(I,[0.05 0.8],[]);
img=im2bw(I,0.5);

%ȥ��ͼ�������С��8������
f=bwareaopen(img,8);

% ����patch����ͼ��ֵ�͵Ĵ�Сȥ��
im = double(f);
patchSize = 16;%16
patchSize1 = 12;
[rows, cols] = size(im); 
 numpatch = floor(rows/patchSize);

%����16*16�Ŀ飬10����ֵ����
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

% ��ͼ��������ʹ���ʹ���е�Ѫ����Ϊ����
se = strel('disk',3);
I = imdilate(im,se);

% ȥ��������Ѫ����ĵ�
T=bwareaopen(I,10000);%ȥ��ͼ�������С��1500������

% ����ͼ�����ȡ����ֵ���õ�ȥ����ͼ���
[rows, cols] = size(I); 
X = abs(I-T-ones(rows, cols));

% ���Ѿ�ȥ����ͼ���Ӧ�õ�im��
re = im.*X;

k = 1;
% ��ͼ��������ʹ���ʹ���е�Ѫ����Ϊ����
se = strel('disk',5);
I = imdilate(re,se);

imwrite(I,strcat('result',num2str(k),'.bmp'));

%��Ѫ�ܿ�TӦ�õ�ԭͼimage
im = im2double(image);
T = im.*I;

k= k+1;
imwrite(T,strcat('result',num2str(k),'.bmp'));

%������ͼ���о�ֵ�˲�,ȡ����Ѫ�����ͼ���
A = filter2(fspecial('average',15),image)/255; 
I1= abs(I-ones(rows, cols));
T1 = A.*I1;

k= k+1;
imwrite(T1,strcat('result',num2str(k),'.bmp'));

%��T��T1�������
T2 = T+T1;
figure, imshow(T2);

k= k+1;
imwrite(T2,strcat('result',num2str(k),'.bmp'));

%frangi�˲���
I = T2.*255;
options  = struct('FrangiScaleRange', [1 10], 'FrangiScaleRatio', 2, 'FrangiBetaOne', 0.5, 'FrangiBetaTwo', 15, 'verbose',true,'BlackWhite',true);
Ivessel=FrangiFilter2D(I,options);


k= k+1;
imwrite(Ivessel,strcat('result',num2str(k),'.bmp'));

figure,
subplot(1,2,1), imshow(I,[]);
subplot(1,2,2), imshow(Ivessel);





