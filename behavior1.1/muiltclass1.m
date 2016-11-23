clear;
clc;

A = [];%148639*128特征矩阵
B = [];
C = [];
Label = {'Phoning','RidingHorse','RidingBike','PlayingGuitar'};
x = [45 50 43 47];
trainlabel = [];
testlabel_1 = [];
testlabel_2 = [];

%提取所有图像的sift特征，并形成特征字典
for i=3:4
    
   for j = 1:40
       %转化为字符串，读取相对路径 strcat拼接字符串
        file = sprintf('imaget/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
         %进行sift特征提取
       [image, descrips, locs] = sift(file);
        A=[A;descrips];
   end 
   for k = 41:60
       %转化为字符串，读取相对路径 strcat拼接字符串
       file = sprintf('imaget/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %进行sift特征提取
       [image, descrips, locs] = sift(file);
       A=[A;descrips];
   end 

end

dic = CalDic(A,400);
A = [];

%通过特征字典形成每个图像的特征向量
for i=3:4
   for j = 1:x(i)
       %转化为字符串，读取相对路径 strcat拼接字符串
        file = sprintf('imaget/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
         %进行sift特征提取
        [image, descrips, locs] = sift(file);
        %bow转为一维向量
        His = HardVoting(descrips,dic);
         A=[A;His];
        trainlabel = [trainlabel;i];
   end 
   for k = 51:60
       %转化为字符串，读取相对路径 strcat拼接字符串
        file = sprintf('imaget/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %进行sift特征提取
        [image, descrips, locs] = sift(file);
        %bow转为一维向量
        His = HardVoting(descrips,dic);
         C=[C;His];
        testlabel_2 = [testlabel_2;i];
   end 
end
% trainlabel= double(trainlabel);
% testlabel = double(testlabel);


model = svmtrain(trainlabel,A);
[predicted_label, accuracy, decision_values] = svmpredict(testlabel_2, C, model);


