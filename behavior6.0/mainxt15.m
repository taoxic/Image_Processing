clc;
close all;

A = [];%1*20736��������
B = [];
trainlabel = [];
testlabel_1 = [];
Label = {'RidingHorse','PlayingGuitar','Phoning'};

%��ȡ����ͼ���sift���������γ������ֵ�
for i=1:3
    
   for j = 1:40
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        file = sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
        img = imread(file);
        I = rgb2gray(img);
         %����HOG������ȡ
       [featureVector,~] = extractHOGFeatures(I);%1*22032
        A=[A;double(featureVector)];
        trainlabel = [trainlabel;i];
   end 
   for k = 41:60
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
       file = sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
        img = imread(file);
       I = rgb2gray(img);
       %����HOG������ȡ
      [featureVector,~] = extractHOGFeatures(I);%1*22032
       B=[B;double(featureVector)];
       testlabel_1 = [testlabel_1;i];
   end 

end


model = svmtrain(trainlabel,A);
[predicted_label, accuracy, decision_values] = svmpredict(testlabel_1, B, model);


