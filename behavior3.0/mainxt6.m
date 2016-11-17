A = [];%148639*128��������
B = [];
Label = {'Phoning','PlayingGuitar','RidingBike','RidingHorse','Running','Shooting'};
trainlabel = [];
testlabel = [];
for i=1:6
    
   for j = 1:40
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        file = sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
         %����sift������ȡ
       [image, descrips, locs] = sift(file);
        A=[A;descrips];
   end 
   for k = 41:60
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
       file = sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %����sift������ȡ
       [image, descrips, locs] = sift(file);
       A=[A;descrips];
   end 

end

dic = CalDic(A,300);
A = [];

for i=1:6
    
   for j = 1:40
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        file = sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
         %����sift������ȡ
        [image, descrips, locs] = sift(file);
        %bowתΪһά����
        His = HardVoting(descrips,dic)
         A=[A;His];
        trainlabel = [trainlabel;i];
   end 
   for k = 41:60
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        file = sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %����sift������ȡ
        [image, descrips, locs] = sift(file);
        %bowתΪһά����
        His = HardVoting(descrips,dic)
         B=[B;His];
        testlabel = [testlabel;i];
   end 

end
trainlabel= double(trainlabel);
testlabel = double(testlabel);

data = [A;B];
label = [trainlabel;testlabel];

ctree = fitctree(data,label);
cmodel = crossval(ctree);
 L = kfoldLoss(cmodel);
 fprintf('ʶ����ȷ��:\n    %f%%\n', (1-L)*100);