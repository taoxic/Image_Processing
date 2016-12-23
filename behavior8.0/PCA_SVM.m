% clear all
% clc



beav_count=2;%类别数
kind_count_per_beav=60;%每类样本数
Label ={'Phoning','RidingBike','RidingHorse','PlayingGuitar'};



%training_ratio=0.80;
% 能量，即较大特征值之和占所有特征值之和的比例。
energy=0.95;
% 每类训练样本数
training_count= 40;
%training_count=floor(kind_count_per_beav*training_ratio);

%训练样本数据，每行是一个样本
training_samples=[];

pca_predicted_label = zeros(80,1);


% 训练
for i=3:beav_count+2
%     for i=4:5
     for j = 1:40
       %转化为字符串，读取相对路径 strcat拼接字符串
        img=im2double(imread([sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j)]));
        img=imresize(img,[100 100]); % 图像缩放至至100*100
        if ndims(img)==3
            img=rgb2gray(img);
        end
        training_samples=[training_samples;img(:)'];
     end 
end
%求取训练样本均值，每行一个样本，每列一类特征
mu=mean(training_samples);

%调用princomp函数
%coeff是主成分系数矩阵，即变换（投影）矩阵
%scores是训练样本投影后的矩阵
%latent是协方差矩阵的特征值，降序排列
%tsquare, which contains Hotelling's T2 statistic for each data point.
[coeff,scores,latent,tsquare]=princomp(training_samples);

%寻找占了energy比例的下标，即主成分就取到这么多维。find函数返回所需要元素的所在位置 
idx=find(cumsum(latent)./sum(latent)>energy,1);
coeff=coeff(:,1:idx);  %取出的主成分系数矩阵
scores=scores(:,1:idx);%训练样本投影矩阵

% 测试
acc_count=0; %计数器
p = 1;
for i=1:beav_count+2
%   for i=4:5
    for j=training_count+1:kind_count_per_beav
        img=im2double(imread([sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, j)]));
        img=imresize(img,[100 100]);
        if ndims(img)==3
            img=rgb2gray(img);
        end
        %测试样本减去训练样本均值，然后投影，得到投影后的样本表示
        score=(img(:)'-mu)*coeff;

        %计算测试样本和每个训练样本之间的欧式距离（这儿只计算平方值即可）
        %然后利用最近邻分类器对测试样本进行分类
        [~,idx]=min(sum((scores-repmat(score,size(scores,1),1)).^2,2));
        
        pca_predicted_label(p) = ceil(idx/training_count);
%         if ceil(idx/training_count)==i
%             acc_count=acc_count+1;
%         end
        p= p+1;
    end
end


% %测试样本总数
% test_count=(beav_count*(kind_count_per_beav-training_count));
% %计算识别率
% acc_ratio=acc_count/test_count;
% %输出显示
% fprintf('测试样本数量:%d,正确识别率:%2.2f%%\n',test_count,acc_ratio*100)

