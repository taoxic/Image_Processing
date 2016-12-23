% clc;
close all;
A = [];%148639*128特征矩阵
B = [];

Label = {'Phoning','RidingBike','RidingHorse','PlayingGuitar'};
trainlabel = [];
testlabel = [];
predicted_label_x = zeros(80,1);

Num = zeros(80,1);

%提取所有图像的sift特征，并形成特征字典
for i=1:4
    
   for j = 1:40
       %转化为字符串，读取相对路径 strcat拼接字符串
        file = sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
         %进行sift特征提取
       [image, descrips, locs] = sift(file);
        A=[A;descrips];
   end 
   
end

dic = CalDic(A,400);

A = [];

%通过特征字典形成每个图像的特征向量
for i=1:4
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
   for k = 41:60
       %转化为字符串，读取相对路径 strcat拼接字符串
        file = sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %进行sift特征提取
        [image, descrips, locs] = sift(file);
        %bow转为一维向量
        His = HardVoting(descrips,dic);
         B=[B;His];
        testlabel = [testlabel;i];
   end 
end

model = svmtrain(trainlabel,A);
[predicted_label, accuracy, decision_values] = svmpredict(testlabel, B, model);

%去掉'PlayingGuitar','RidingHorse'二类分类的票
Vote_num = change_dec(decision_values,model);

%pac分类
PCA_SVM;





acc_count=0; %计数器
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


%测试样本总数
test_count=80;
%计算识别率
acc_ratio=acc_count/test_count;
%输出显示
fprintf('测试样本数量:%d,正确识别率:%2.2f%%\n',test_count,acc_ratio*100)


