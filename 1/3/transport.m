
load trees%װ��ͼ�񣬹���������caption,X,map����
I = ind2gray(X,map);%��ͼ��ת��Ϊ�Ҷ�ͼ��ȥ��ɫ���ͱ��Ͷ���Ϣ
imshow(X,map)%��ʾԭʼͼ��
figure,imshow(I);

load trees %װ��ͼ��
%converts the indexed image X with colormap map to a binary image
BW = im2bw(X,map,0.4);%������ɫͼ�������ֵΪ0.4�Ķ�ֵ������
imshow(X,map)
figure, imshow(BW)

I8 = imread('snowflakes.png');%����ͼ��
X8 = grayslice(I8,16);%���Ҷ�ͼ��ת��Ϊ����ɫͼ��
imshow(I8) 
%jet��M���Ԥ�����ɫͼ���󣬱�ʾ��ͷ��β����ɫ map
figure,imshow(X8,jet(16))


