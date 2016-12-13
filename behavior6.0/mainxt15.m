clc;
close all;

A = [];%1*20736特征矩阵
B = [];
trainlabel = [];
testlabel_1 = [];
Label = {'RidingHorse','PlayingGuitar','Phoning'};

%提取所有图像的sift特征，并形成特征字典
for i=1:3
    
   for j = 1:40
       %转化为字符串，读取相对路径 strcat拼接字符串
        file = sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
        img = imread(file);
        I = rgb2gray(img);
         %进行HOG特征提取
       [featureVector,~] = extractHOGFeatures(I);%1*22032
        A=[A;double(featureVector)];
        trainlabel = [trainlabel;i];
   end 
   for k = 41:60
       %转化为字符串，读取相对路径 strcat拼接字符串
       file = sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
        img = imread(file);
       I = rgb2gray(img);
       %进行HOG特征提取
      [featureVector,~] = extractHOGFeatures(I);%1*22032
       B=[B;double(featureVector)];
       testlabel_1 = [testlabel_1;i];
   end 

end


model = svmtrain(trainlabel,A);
[predicted_label, accuracy, decision_values] = svmpredict(testlabel_1, B, model);


