%������������ݵķֲ���Ϊ��һ�������������
function datadis(data)

min = 0;
max = 10;

[rows , cols] = size(data);%�õ�ͼ�������С�����  
ZhiFang = zeros(min+1 , max+1);%��ʼ��һ�����������洢Ƶ��  
for i = min:max 
    %length���ؾ����������������еĽϴ�ֵ��find��������ҪԪ�ص�����λ��,length(find(data == i))������
  ZhiFang(1 , i+1) = length(find(data == i)) / (rows * cols);%�������data��ֵ��i��ȵ�Ԫ�صı���
%      ZhiFang(1 , i+1) = length(find(i<data+5 < i+1)) / (rows * cols);%�������data��ֵ��i��ȵ�Ԫ�صı���
end   

figure(1);  
bar(0:max , ZhiFang , 'grouped');%����bar����ֱ��ͼ  
xlabel('��ֵֵ');  
ylabel('���ִ���');  
%axis([0 255 0 1]);%axis�����������û�������꼰�������������