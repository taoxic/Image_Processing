clear all;
clc;
A = [];%148639*128特征矩阵
B = [];
C = [];
Label ={'RidingHorse','PlayingGuitar','Phoning','RidingBike','Running','Shooting'};
trainlabel = [];
testlabel_1 = [];
testlabel_2 = [];
beav_count=4;%类别数
kind_count_per_beav=60;%每类样本数

%提取所有图像的sift特征，并形成特征字典
for i=1:beav_count
    
   for j = 1:40
       %转化为字符串，读取相对路径 strcat拼接字符串
        file = sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
         %进行sift特征提取
       [image, descrips, locs] = sift(file);
        A=[A;descrips];
   end 
   for k = 41:48  %48个训练样本
       %转化为字符串，读取相对路径 strcat拼接字符串
       file = sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %进行sift特征提取
       [image, descrips, locs] = sift(file);
       A=[A;descrips];
   end 

end

dic = CalDic(A,400);
A = [];

%通过特征字典形成每个图像的特征向量
for i=1:beav_count
   for j = 1:40
       %转化为字符串，读取相对路径 strcat拼接字符串
        file = sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
         %进行sift特征提取
        [image, descrips, locs] = sift(file);
        %bow转为一维向量
        His = HardVoting(descrips,dic);
         A=[A;His];
        trainlabel = [trainlabel;i];
   end 
   for k = 41:48
       %转化为字符串，读取相对路径 strcat拼接字符串
        file = sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %进行sift特征提取
        [image, descrips, locs] = sift(file);
        %bow转为一维向量
        His = HardVoting(descrips,dic);
         A=[A;His];
        trainlabel = [trainlabel;i];
   end 
      for k = 49:60
       %转化为字符串，读取相对路径 strcat拼接字符串
        file = sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %进行sift特征提取
        [image, descrips, locs] = sift(file);
        %bow转为一维向量
        His = HardVoting(descrips,dic);
         C=[C;His];
        testlabel_2 = [testlabel_2;i];
   end 
end


model = svmtrain(trainlabel,A);

[predicted_label, accuracy, decision_values] = svmpredict(testlabel_2, C, model);


%%%%%%%%%%%%%%%%%%%%%%% 基于PCA的训练

training_ratio=0.80;
% 能量，即较大特征值之和占所有特征值之和的比例。
energy=0.95;
% 每类训练样本数
training_count=floor(kind_count_per_beav*training_ratio);

%训练样本数据，每行是一个样本
training_samples=[];

%测试样本的score
test_scores = [];
%预测标签
p_label = [];
%决策值
decision_values_PCA = [];

% 训练
for i=1:beav_count
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
   
    for j=41:training_count   %48个训练样本
        img=im2double(imread([sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, j)]));
        img=imresize(img,[100 100]); % 图像缩放至至100*100
        %若是彩色图像，则灰度化
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







%取出决策值decision_values在一定范围内的样本位置，预测的确定性不高
idx = find(decision_values>-0.2&decision_values<0.2);


for i = 1:length(idx)
    
    if idx(i)<12
        x = idx(i)+48;
        img=im2double(imread([sprintf('imagex/testing/%s/%s_00%i.jpg',Label{1},Label{1}, x)]));
        elseif idx(i)>12&idx(i)<24
            x = idx(i)+36;
            img=im2double(imread([sprintf('imagex/testing/%s/%s_00%i.jpg',Label{2},Label{2}, x)]));
            elseif idx(i)>24&idx(i)<36
                x = idx(i)+24;
                img=im2double(imread([sprintf('imagex/testing/%s/%s_00%i.jpg',Label{3},Label{3},x)]));
                elseif idx(i)>36&idx(i)<48
                    x = idx(i)+12;
                    img=im2double(imread([sprintf('imagex/testing/%s/%s_00%i.jpg',Label{4},Label{4}, x)]));
    end
    img=imresize(img,[100 100]);
    if ndims(img)==3
        img=rgb2gray(img);
    end
    %测试样本减去训练样本均值，然后投影，得到投影后的样本表示
    score=(img(:)'-mu)*coeff;
    
    [dec,idxa]=min(sum((scores-repmat(score,size(scores,1),1)).^2,2));
    a = ceil(idxa/training_count);
    predicted_label(idx,1) = a;
end

%accuracy  testlabel_2
acc_count=0; %计数器
test_count=(beav_count*(kind_count_per_beav-training_count));

for i = 1:length(testlabel_2)
    if predicted_label(i,1) ==testlabel_2(i,1)
         acc_count=acc_count+1;
    end
end 
accuracy = acc_count/test_count;
sprintf('正确率为：%2.2f%%', accuracy*100);





