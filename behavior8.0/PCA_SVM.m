% clear all
% clc



beav_count=2;%�����
kind_count_per_beav=60;%ÿ��������
Label ={'Phoning','RidingBike','RidingHorse','PlayingGuitar'};



%training_ratio=0.80;
% ���������ϴ�����ֵ֮��ռ��������ֵ֮�͵ı�����
energy=0.95;
% ÿ��ѵ��������
training_count= 40;
%training_count=floor(kind_count_per_beav*training_ratio);

%ѵ���������ݣ�ÿ����һ������
training_samples=[];

pca_predicted_label = zeros(80,1);


% ѵ��
for i=3:beav_count+2
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

% ����
acc_count=0; %������
p = 1;
for i=1:beav_count+2
%   for i=4:5
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
        
        pca_predicted_label(p) = ceil(idx/training_count);
%         if ceil(idx/training_count)==i
%             acc_count=acc_count+1;
%         end
        p= p+1;
    end
end


% %������������
% test_count=(beav_count*(kind_count_per_beav-training_count));
% %����ʶ����
% acc_ratio=acc_count/test_count;
% %�����ʾ
% fprintf('������������:%d,��ȷʶ����:%2.2f%%\n',test_count,acc_ratio*100)

