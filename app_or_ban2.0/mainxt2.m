A = [];
for i=1:20
    fprintf('The %d th image \n',i);  
    %ת��Ϊ�ַ�������ȡ���·��
    file = sprintf('images/training/a%i.jpg', i);
%     % �����file�ļ�imread��Ȼ����������
%     I_rgb = imread(file);
%     
%     figure(1);
% subplot(1,2,1);
% imshow(I_rgb); %��ʾԭͼ
% title('ԭʼͼ��');
%     
%     
%     C = makecform('srgb2lab'); %����ת����ʽ
%     I_lab = applycform(I_rgb, C);
% 
%     %����K-mean���ཫͼ��ָ��3������
%     ab = double(I_lab(:,:,2:3)); %ȡ��lab�ռ��a������b����
%     nrows = size(ab,1);
%     ncols = size(ab,2);
%     ab = reshape(ab,nrows*ncols,2);
% 
%     nColors = 4; %�ָ���������Ϊ
% 
%     [cluster_idx,cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',100); %�ظ�����3��
%     pixel_labels = reshape(cluster_idx,nrows,ncols);
% 
%     figure(1);
%     subplot(1,2,2);
%     imshow(pixel_labels,[]), title('������');
    
    
    %����sift������ȡ
%     im1 = pixel_labels;
    [image, descrips, locs] = sift(file);
    %bowתΪһά����
    m = CalDic(descrips,1);
    A=[A;m];
end