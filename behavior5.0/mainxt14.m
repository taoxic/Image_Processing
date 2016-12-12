clear all;
clc;
A = [];%148639*128��������
B = [];
C = [];
Label ={'RidingHorse','PlayingGuitar','Phoning','RidingBike','Running','Shooting'};
trainlabel = [];
testlabel_1 = [];
testlabel_2 = [];
beav_count=4;%�����
kind_count_per_beav=60;%ÿ��������

%��ȡ����ͼ���sift���������γ������ֵ�
for i=1:beav_count
    
   for j = 1:40
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        file = sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j);
         %����sift������ȡ
       [image, descrips, locs] = sift(file);
        A=[A;descrips];
   end 
   for k = 41:48  %48��ѵ������
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
       file = sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %����sift������ȡ
       [image, descrips, locs] = sift(file);
       A=[A;descrips];
   end 

end

dic = CalDic(A,400);
A = [];

%ͨ�������ֵ��γ�ÿ��ͼ�����������
for i=1:beav_count
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
   for k = 41:48
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        file = sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %����sift������ȡ
        [image, descrips, locs] = sift(file);
        %bowתΪһά����
        His = HardVoting(descrips,dic);
         A=[A;His];
        trainlabel = [trainlabel;i];
   end 
      for k = 49:60
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        file = sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, k);
         %����sift������ȡ
        [image, descrips, locs] = sift(file);
        %bowתΪһά����
        His = HardVoting(descrips,dic);
         C=[C;His];
        testlabel_2 = [testlabel_2;i];
   end 
end


model = svmtrain(trainlabel,A);

[predicted_label, accuracy, decision_values] = svmpredict(testlabel_2, C, model);


%%%%%%%%%%%%%%%%%%%%%%% ����PCA��ѵ��

training_ratio=0.80;
% ���������ϴ�����ֵ֮��ռ��������ֵ֮�͵ı�����
energy=0.95;
% ÿ��ѵ��������
training_count=floor(kind_count_per_beav*training_ratio);

%ѵ���������ݣ�ÿ����һ������
training_samples=[];

%����������score
test_scores = [];
%Ԥ���ǩ
p_label = [];
%����ֵ
decision_values_PCA = [];

% ѵ��
for i=1:beav_count
%     for i=4:5
     for j = 1:40
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        img=im2double(imread([sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j)]));
        img=imresize(img,[100 100]); % ͼ����������100*100
        if ndims(img)==3
            img=rgb2gray(img);
        end
        training_samples=[training_samples;img(:)'];
     end 
   
    for j=41:training_count   %48��ѵ������
        img=im2double(imread([sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, j)]));
        img=imresize(img,[100 100]); % ͼ����������100*100
        %���ǲ�ɫͼ����ҶȻ�
        if ndims(img)==3
            img=rgb2gray(img);
        end
        training_samples=[training_samples;img(:)'];
    end
end
%��ȡѵ��������ֵ��ÿ��һ��������ÿ��һ������
mu=mean(training_samples);

%����princomp����
%coeff�����ɷ�ϵ�����󣬼��任��ͶӰ������
%scores��ѵ������ͶӰ��ľ���
%latent��Э������������ֵ����������
%tsquare, which contains Hotelling's T2 statistic for each data point.
[coeff,scores,latent,tsquare]=princomp(training_samples);

%Ѱ��ռ��energy�������±꣬�����ɷ־�ȡ����ô��ά��find������������ҪԪ�ص�����λ�� 
idx=find(cumsum(latent)./sum(latent)>energy,1);

coeff=coeff(:,1:idx);  %ȡ�������ɷ�ϵ������
scores=scores(:,1:idx);%ѵ������ͶӰ����







%ȡ������ֵdecision_values��һ����Χ�ڵ�����λ�ã�Ԥ���ȷ���Բ���
idx = find(decision_values>-0.2&decision_values<0.2);


for i = 1:length(idx)
    
    if idx(i)<12
        x = idx(i)+48;
        img=im2double(imread([sprintf('imagex/testing/%s/%s_00%i.jpg',Label{1},Label{1}, x)]));
        elseif idx(i)>12&idx(i)<24
            x = idx(i)+36;
            img=im2double(imread([sprintf('imagex/testing/%s/%s_00%i.jpg',Label{2},Label{2}, x)]));
            elseif idx(i)>24&idx(i)<36
                x = idx(i)+24;
                img=im2double(imread([sprintf('imagex/testing/%s/%s_00%i.jpg',Label{3},Label{3},x)]));
                elseif idx(i)>36&idx(i)<48
                    x = idx(i)+12;
                    img=im2double(imread([sprintf('imagex/testing/%s/%s_00%i.jpg',Label{4},Label{4}, x)]));
    end
    img=imresize(img,[100 100]);
    if ndims(img)==3
        img=rgb2gray(img);
    end
    %����������ȥѵ��������ֵ��Ȼ��ͶӰ���õ�ͶӰ���������ʾ
    score=(img(:)'-mu)*coeff;
    
    [dec,idxa]=min(sum((scores-repmat(score,size(scores,1),1)).^2,2));
    a = ceil(idxa/training_count);
    predicted_label(idx,1) = a;
end

%accuracy  testlabel_2
acc_count=0; %������
test_count=(beav_count*(kind_count_per_beav-training_count));

for i = 1:length(testlabel_2)
    if predicted_label(i,1) ==testlabel_2(i,1)
         acc_count=acc_count+1;
    end
end 
accuracy = acc_count/test_count;
sprintf('��ȷ��Ϊ��%2.2f%%', accuracy*100);





