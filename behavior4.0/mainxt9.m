clear all
clc
close all

beav_count=6;%�����
kind_count_per_beav=60;%ÿ��������
Label = {'Phoning','PlayingGuitar','RidingBike','RidingHorse','Running','Shooting'};
%ÿ��ѵ����������,70%ʱʶ����ȷ��Ϊ96.67%,����Ϊ75%ʶ����ȷ�ʿɴ�100%
training_ratio=0.80;
% ���������ϴ�����ֵ֮��ռ��������ֵ֮�͵ı�����
energy=0.95;
% ÿ��ѵ��������
training_count=floor(kind_count_per_beav*training_ratio);

%ѵ���������ݣ�ÿ����һ������
training_samples=[];

% ѵ��
for i=1:beav_count
    
     for j = 1:40
       %ת��Ϊ�ַ�������ȡ���·�� strcatƴ���ַ���
        img=im2double(imread([sprintf('imagex/training/%s/%s_00%i.jpg',Label{i},Label{i}, j)]));
        img=imresize(img,[100 100]); % ͼ����������10*10
        if ndims(img)==3
            img=rgb2gray(img);
        end
        training_samples=[training_samples;img(:)'];
     end 
   
    for j=41:training_count
        img=im2double(imread([sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, j)]));
        img=imresize(img,[100 100]); % ͼ����������10*10
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

%Ѱ��ռ��energy�������±꣬�����ɷ־�ȡ����ô��ά
idx=find(cumsum(latent)./sum(latent)>energy,1);
coeff=coeff(:,1:idx);  %ȡ�������ɷ�ϵ������
scores=scores(:,1:idx);%ѵ������ͶӰ����

% ����
acc_count=0; %������
for i=1:beav_count
    for j=training_count+1:kind_count_per_beav
        img=im2double(imread([sprintf('imagex/testing/%s/%s_00%i.jpg',Label{i},Label{i}, j)]));
        img=imresize(img,[100 100]);
        if ndims(img)==3
            img=rgb2gray(img);
        end
        %����������ȥѵ��������ֵ��Ȼ��ͶӰ���õ�ͶӰ���������ʾ
        score=(img(:)'-mu)*coeff;
        %�������������ÿ��ѵ������֮���ŷʽ���루���ֻ����ƽ��ֵ���ɣ�
        %Ȼ����������ڷ������Բ����������з���
        [~,idx]=min(sum((scores-repmat(score,size(scores,1),1)).^2,2));
        if ceil(idx/training_count)==i
            acc_count=acc_count+1;
        end
    end
end
%������������
test_count=(beav_count*(kind_count_per_beav-training_count));
%����ʶ����
acc_ratio=acc_count/test_count;
%�����ʾ
fprintf('������������:%d,��ȷʶ����:%2.2f%%\n',test_count,acc_ratio*100)