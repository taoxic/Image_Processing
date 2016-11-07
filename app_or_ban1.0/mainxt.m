close all;
%%进行参数设置 
intervals = 3;%每组的层数
scl = 1.5;
dist_ratio = 0.8;
contrast_threshold = 0.02;
curvature_threshold = 10;
interactive = 2;

A = [];
for i=1:20
    fprintf('The %d th image \n',i);  
    %转化为字符串，读取相对路径
    file = sprintf('images/training/a%i.jpg', i);
    % 后面对file文件imread，然后做处理即可
    I_rgb = imread(file);
    C = makecform('srgb2lab'); %设置转换格式
    I_lab = applycform(I_rgb, C);

    %进行K-mean聚类将图像分割成3个区域
    ab = double(I_lab(:,:,2:3)); %取出lab空间的a分量和b分量
    nrows = size(ab,1);
    ncols = size(ab,2);
    ab = reshape(ab,nrows*ncols,2);

    nColors = 4; %分割的区域个数为

    [cluster_idx,cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',100); %重复聚类3次
    pixel_labels = reshape(cluster_idx,nrows,ncols);

    %进行sift特征提取
    im1 = pixel_labels;
    octaves1 = floor(log(min(size(im1)))/log(2)- 2);
    object_mask1  = ones(size(im1));

    [pos1,scale1,orient1,desc1 ] = features_detection( im1, octaves1, intervals, object_mask1, contrast_threshold, curvature_threshold, interactive);
    %bow转为一维向量
    m = CalDic(desc1,1);
    A=[A;m];
end
