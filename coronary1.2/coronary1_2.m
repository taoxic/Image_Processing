img=imread('c_lm_29.bmp');
%   img=imread('c_gc_40.bmp');
% img=imread('c_cqj_37.bmp');

k = 1;
% ��ǿ�Աȶ�
J = imadjust(img,[0.05 0.45],[]);

imwrite(J,strcat('result',num2str(k),'.bmp'));
figure,imshow(J), title('result1')

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
k= k+1;
imwrite(I,strcat('result',num2str(k),'.bmp'));
figure,imshow(I), title('result2')


%�Ҷ�ת��ֵ
I = imadjust(I,[0.05 0.8],[]);
img=im2bw(I,0.5);
k= k+1;
imwrite(img,strcat('result',num2str(k),'.bmp'));
figure,imshow(img), title('result3')


%ȥ��ͼ�������С��8������
f=bwareaopen(img,8);

k= k+1;
imwrite(f,strcat('result',num2str(k),'.bmp'));

figure,imshow(f), title('result4')


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
k= k+1;
imwrite(im,strcat('result',num2str(k),'.bmp'));
figure,imshow(im), title('result5')


% ��ͼ��������ʹ���ʹ���е�Ѫ����Ϊ����
se = strel('disk',3);
I = imdilate(im,se);
k= k+1;
imwrite(I,strcat('result',num2str(k),'.bmp'));
figure,imshow(I), title('result6')


% ȥ��������Ѫ����ĵ�
T=bwareaopen(I,10000);%ȥ��ͼ�������С��1500������
k= k+1;
imwrite(T,strcat('result',num2str(k),'.bmp'));
figure,imshow(T), title('result7')

% ����ͼ�����ȡ����ֵ���õ�ȥ����ͼ���
[rows, cols] = size(I); 
X = abs(I-T-ones(rows, cols));
k= k+1;
imwrite(X,strcat('result',num2str(k),'.bmp'));
figure,imshow(X), title('result8')

% ���Ѿ�ȥ����ͼ���Ӧ�õ�im��
re = im.*X;
k= k+1;
imwrite(re,strcat('result',num2str(k),'.bmp'));
figure,imshow(re), title('result9')

