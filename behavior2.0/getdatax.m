function [data,label] = getdatax
A = [];%148639*128特征矩阵
B = [];
Label = {'Phoning','PlayingGuitar','RidingBike','RidingHorse','Running','Shooting'};
trainlabel = [];
testlabel = [];
for i=1:2
    
   for j = 1:40
       %转化为字符串，读取相对路径 strcat拼接字符串
        file = sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
         %进行sift特征提取
       [image, descrips, locs] = sift(file);
        A=[A;descrips];
   end 
   for k = 41:60
       %转化为字符串，读取相对路径 strcat拼接字符串
       file = sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %进行sift特征提取
       [image, descrips, locs] = sift(file);
       A=[A;descrips];
   end 

end
%，通过所有的特征向量，形成数据直方图
dic = CalDic(A,300);
A = [];

for i=1:2
    
   for j = 1:40
       %转化为字符串，读取相对路径 strcat拼接字符串
        file = sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
         %进行sift特征提取
        [image, descrips, locs] = sift(file);
        %转为一维向量
        His = HardVoting(descrips,dic)
         A=[A;His];
        trainlabel = [trainlabel;i];
   end 
   for k = 41:60
       %转化为字符串，读取相对路径 strcat拼接字符串
        file = sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %进行sift特征提取
        [image, descrips, locs] = sift(file);
        %bow转为一维向量
        His = HardVoting(descrips,dic)
         B=[B;His];
        testlabel = [testlabel;i];
   end 

end

data = [A;B];
label = [trainlabel;testlabel];



% 
% trainlabel= double(trainlabel);
% testlabel = double(testlabel);