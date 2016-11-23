clear;
clc;

A = [];%148639*128��������
B = [];
C = [];
Label = {'Phoning','RidingHorse','RidingBike','PlayingGuitar'};
x = [45 50 43 47];
trainlabel = [];
testlabel_1 = [];
testlabel_2 = [];

%��ȡ����ͼ���sift���������γ������ֵ�
for i=3:4
    
   for j = 1:40
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        file = sprintf('imaget/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
         %����sift������ȡ
       [image, descrips, locs] = sift(file);
        A=[A;descrips];
   end 
   for k = 41:60
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
       file = sprintf('imaget/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %����sift������ȡ
       [image, descrips, locs] = sift(file);
       A=[A;descrips];
   end 

end

dic = CalDic(A,400);
A = [];

%ͨ�������ֵ��γ�ÿ��ͼ�����������
for i=3:4
   for j = 1:x(i)
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        file = sprintf('imaget/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
         %����sift������ȡ
        [image, descrips, locs] = sift(file);
        %bowתΪһά����
        His = HardVoting(descrips,dic);
         A=[A;His];
        trainlabel = [trainlabel;i];
   end 
   for k = 51:60
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        file = sprintf('imaget/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %����sift������ȡ
        [image, descrips, locs] = sift(file);
        %bowתΪһά����
        His = HardVoting(descrips,dic);
         C=[C;His];
        testlabel_2 = [testlabel_2;i];
   end 
end
% trainlabel= double(trainlabel);
% testlabel = double(testlabel);


model = svmtrain(trainlabel,A);
[predicted_label, accuracy, decision_values] = svmpredict(testlabel_2, C, model);


