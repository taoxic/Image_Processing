% ������ȡ

%��ȡͼ��
img=imread('imagex/testing/RidingBike/RidingBike_0058.jpg');
%ת�Ҷ�
% img=rgb2gray(img);
if ndims(img) == 3
    img = rgb2gray(img);
end

% ��������ֵ�ָ��ȷ����ֵ
I = im2double(img);
T = 0.5 * (min(I(:))+max(I(:)));%������ֵ
U = false;
while ~U
    g = I >= T;
    TT = 0.5 * (mean(I(g))+mean(I(~g)));
    if (abs(T - TT)< 0.1) %����TΪ������ֵ����ͬ��Tֵ�£�ͼ��ָ�Ч����ͬ��
       U = 1;
    end
    T = TT;
end


%�Ҷ�ת��ֵ
img=im2bw(img,T);

%�ú����������ͼ������͡��ն� v
img=imfill(~img,'hole');

figure
imshow(img)

%����ṹԪ��
str=strel('disk',6);
%��̬ѧ������ʴ
img=imerode(~img,str);
% ɾ����ֵͼ�������С��P�Ķ���Ĭ�������connʹ��8����
img=bwareaopen(~img,100);
%����ͼ��
img=imdilate(~img,str);
img=imdilate(img,str);
img=imerode(img,str);

figure
imshow(img)
% bwarea(img) 

str=strel('disk',2);
img1=imerode(img,str);
img2=img-img1;

%��ȡͼ��ľֲ�����
L=bwlabel(img2,8);%��Ϊ��־����  
stat=regionprops(L,'all')%ͼ��ֲ�����  
% 
% figure
% imshow(img2)