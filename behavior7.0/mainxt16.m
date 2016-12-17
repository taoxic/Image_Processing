%��ͼ���Ϊ16*16��patch������ȡsift�����㣬�������sift����������ȡhog�������������Ϊһ��Features

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
%��ȡ����ͼ���sift���������γ������ֵ�
for i=1:2
    
   for j = 1:40
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
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

%ͨ�������ֵ��γ�ÿ��ͼ�����������
for i=1:2
   for j = 1:40
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        file = sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
         %����sift������ȡ
        Features = block_extractHS(file);
        %bowתΪһά����
        His = HardVoting(Features,dic);
         A=[A;His];
        trainlabel = [trainlabel;i];
   end 
   for k = 41:60
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        file = sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %����sift������ȡ
        Features = block_extractHS(file);
        %bowתΪһά����
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