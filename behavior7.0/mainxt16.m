%将图像分为16*16的patch，先提取sift特征点，如果可以sift特征，再提取hog特征，将其组合为一个Features

close all;


 patchSize=16;  
 HOGFeatures = [];
 SiftFeatures = [];
 Features = [];
 
 
A = [];
B = [];
C = [];
Label = {'Phoning','PlayingGuitar','RidingHorse'};
trainlabel = [];
testlabel_1 = [];

tic;
%提取所有图像的sift特征，并形成特征字典
for i=1:2
    
   for j = 1:40
       %转化为字符串，读取相对路径 strcat拼接字符串
        file = sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
       Features = block_extractHS(file);
        A=[A;Features];
   end 
   for k = 41:60
        file = sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
        Features = block_extractHS(file);
        A=[A;Features];
   end 

end

dic = CalDic(A,400);
A = [];

%通过特征字典形成每个图像的特征向量
for i=1:2
   for j = 1:40
       %转化为字符串，读取相对路径 strcat拼接字符串
        file = sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
         %进行sift特征提取
        Features = block_extractHS(file);
        %bow转为一维向量
        His = HardVoting(Features,dic);
         A=[A;His];
        trainlabel = [trainlabel;i];
   end 
   for k = 41:60
       %转化为字符串，读取相对路径 strcat拼接字符串
        file = sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %进行sift特征提取
        Features = block_extractHS(file);
        %bow转为一维向量
        His = HardVoting(Features,dic);
         B=[B;His];
        testlabel_1 = [testlabel_1;i];
   end 
end

% trainlabel= double(trainlabel);
% testlabel = double(testlabel);

model = svmtrain(trainlabel,A);

[predicted_label, accuracy, decision_values] = svmpredict(testlabel_1, B, model);
toc;