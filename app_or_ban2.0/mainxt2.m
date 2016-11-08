A = [];
for i=1:20
    fprintf('The %d th image \n',i);  
    %转化为字符串，读取相对路径
    file = sprintf('images/training/a%i.jpg', i);
%     % 后面对file文件imread，然后做处理即可
%     I_rgb = imread(file);
%     
%     figure(1);
% subplot(1,2,1);
% imshow(I_rgb); %显示原图
% title('原始图像');
%     
%     
%     C = makecform('srgb2lab'); %设置转换格式
%     I_lab = applycform(I_rgb, C);
% 
%     %进行K-mean聚类将图像分割成3个区域
%     ab = double(I_lab(:,:,2:3)); %取出lab空间的a分量和b分量
%     nrows = size(ab,1);
%     ncols = size(ab,2);
%     ab = reshape(ab,nrows*ncols,2);
% 
%     nColors = 4; %分割的区域个数为
% 
%     [cluster_idx,cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',100); %重复聚类3次
%     pixel_labels = reshape(cluster_idx,nrows,ncols);
% 
%     figure(1);
%     subplot(1,2,2);
%     imshow(pixel_labels,[]), title('聚类结果');
    
    
    %进行sift特征提取
%     im1 = pixel_labels;
    [image, descrips, locs] = sift(file);
    %bow转为一维向量
    m = CalDic(descrips,1);
    A=[A;m];
end