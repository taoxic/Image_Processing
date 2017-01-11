img=imread('c_lm_29.jpg');

if ndims(img) == 3
    img = rgb2gray(img);
end


% ��ǿ�Աȶ�,���Ը���ֱ��ͼȷ��ֵ
J = imadjust(img,[0.05 0.45],[]);
I = J;

se = strel('disk', 5);%20
Io = imopen(I, se);


Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
figure, imshow(Iobr, []), title('���ڿ����ؽ�ͼ��')


%����һ����ά��Ԥ������˲�����hy��sobel���ڱ�Ե��ȡ���޲���
hy = fspecial('sobel');
hx = hy';
% ����������������άͼ������˲�����replicate��ͼ���Сͨ��������߽��ֵ����չ
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

I = uint8(gradmag);

%�Ҷ�ת��ֵ
img=im2bw(I,0.6);

% h=medfilt2(img);                 %�Խ���������ֵ�˲�

figure,imshow(img)

f=bwareaopen(img,2);%ȥ��ͼ�������С��2������

figure,imshow(f)

im = double(f);


%��ͼ����зֿ�ȥ�봦��
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


