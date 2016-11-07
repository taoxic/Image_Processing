close all;
%%���в������� 
intervals = 3;%ÿ��Ĳ���
scl = 1.5;
dist_ratio = 0.8;
contrast_threshold = 0.02;
curvature_threshold = 10;
interactive = 2;

A = [];
for i=1:20
    fprintf('The %d th image \n',i);  
    %ת��Ϊ�ַ�������ȡ���·��
    file = sprintf('images/training/a%i.jpg', i);
    % �����file�ļ�imread��Ȼ����������
    I_rgb = imread(file);
    C = makecform('srgb2lab'); %����ת����ʽ
    I_lab = applycform(I_rgb, C);

    %����K-mean���ཫͼ��ָ��3������
    ab = double(I_lab(:,:,2:3)); %ȡ��lab�ռ��a������b����
    nrows = size(ab,1);
    ncols = size(ab,2);
    ab = reshape(ab,nrows*ncols,2);

    nColors = 4; %�ָ���������Ϊ

    [cluster_idx,cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',100); %�ظ�����3��
    pixel_labels = reshape(cluster_idx,nrows,ncols);

    %����sift������ȡ
    im1 = pixel_labels;
    octaves1 = floor(log(min(size(im1)))/log(2)- 2);
    object_mask1  = ones(size(im1));

    [pos1,scale1,orient1,desc1 ] = features_detection( im1, octaves1, intervals, object_mask1, contrast_threshold, curvature_threshold, interactive);
    %bowתΪһά����
    m = CalDic(desc1,1);
    A=[A;m];
end
