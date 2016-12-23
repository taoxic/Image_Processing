% clc;
close all;
A = [];%148639*128��������
B = [];

Label = {'Phoning','RidingBike','RidingHorse','PlayingGuitar'};
trainlabel = [];
testlabel = [];
predicted_label_x = zeros(80,1);

Num = zeros(80,1);

%��ȡ����ͼ���sift���������γ������ֵ�
for i=1:4
    
   for j = 1:40
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        file = sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
         %����sift������ȡ
       [image, descrips, locs] = sift(file);
        A=[A;descrips];
   end 
   
end

dic = CalDic(A,400);

A = [];

%ͨ�������ֵ��γ�ÿ��ͼ�����������
for i=1:4
   for j = 1:40
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        file = sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
         %����sift������ȡ
        [image, descrips, locs] = sift(file);
        %bowתΪһά����
        His = HardVoting(descrips,dic);
         A=[A;His];
        trainlabel = [trainlabel;i];
   end 
   for k = 41:60
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        file = sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %����sift������ȡ
        [image, descrips, locs] = sift(file);
        %bowתΪһά����
        His = HardVoting(descrips,dic);
         B=[B;His];
        testlabel = [testlabel;i];
   end 
end

model = svmtrain(trainlabel,A);
[predicted_label, accuracy, decision_values] = svmpredict(testlabel, B, model);

%ȥ��'PlayingGuitar','RidingHorse'��������Ʊ
Vote_num = change_dec(decision_values,model);

%pac����
PCA_SVM;





acc_count=0; %������
x = 0;
for i = 1:80
    if predicted_label_x==1
        Vote_num(i,3) = Vote_num(i,3)+1;
    else
        Vote_num(i,4) = Vote_num(i,4)+1;
    end
    
    
    
    max_idx = 1;
    for j = 2:4
        if Vote_num(i,j)>Vote_num(i,max_idx)
            max_idx = j;
        end
    end
    Num(i,1) = max_idx;
    
    
    if max_idx == testlabel(i,1)
        acc_count=acc_count+1;
    end
    
    
    if max_idx == predicted_label(i,1)
        x=x+1;
    end
    
    
end


%������������
test_count=80;
%����ʶ����
acc_ratio=acc_count/test_count;
%�����ʾ
fprintf('������������:%d,��ȷʶ����:%2.2f%%\n',test_count,acc_ratio*100)


