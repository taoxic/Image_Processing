%计算矩阵中数据的分布，为归一化数据提出决策
function datadis(data)

min = 0;
max = 10;

[rows , cols] = size(data);%得到图像矩阵的行、列数  
ZhiFang = zeros(min+1 , max+1);%初始化一个矩阵，用来存储频数  
for i = min:max 
    %length返回矩阵中行数和列数中的较大值，find返回所需要元素的所在位置,length(find(data == i))个数，
  ZhiFang(1 , i+1) = length(find(data == i)) / (rows * cols);%计算矩阵data中值与i相等的元素的比率
%      ZhiFang(1 , i+1) = length(find(i<data+5 < i+1)) / (rows * cols);%计算矩阵data中值与i相等的元素的比率
end   

figure(1);  
bar(0:max , ZhiFang , 'grouped');%根据bar绘制直方图  
xlabel('数值值');  
ylabel('出现次数');  
%axis([0 255 0 1]);%axis函数用来设置画面横坐标及纵坐标的上下限