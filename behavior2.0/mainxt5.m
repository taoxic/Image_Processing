% 批量方式训练BP网络，实现行为识别

%% 清理
clear all 
clc 

%% 读入数据
[data,label]=getdatax;

%% 划分数据
[traind,trainl,testd,testl]=dividex(data,label);

%% 设置参数
rng('default') %控制随机数的生成
rng(0) %生成随机数的种子
nTrainNum = 60; % 60个训练样本
nSampDim = 300;   % 样本是300维的

%% 构造网络 使用net的结构体表示BP神经网络，用下列代码将权值初始化为一个较小的随机数
net.nIn=300;  % 输入层300个神经元
net.nHidden = 25;    % 25个隐含层节点
net.nOut = 1;       % 一个输出层节点

w = 2*(rand(net.nHidden,net.nIn)-1/2);  % nHidden * 300的矩阵， 一行代表一个隐含层节点
b = 2*(rand(net.nHidden,1)-1/2); %nHidden *1 的矩阵
net.w1 = [w,b]; 

W = 2*(rand(net.nOut,net.nHidden)-1/2); 
B = 2*(rand(net.nOut,1)-1/2); 
net.w2 = [W,B]; 

%% 训练数据归一化
mm=mean(traind); %表示求矩阵traind的均值，默认的是求各列的均值
% 均值平移
for i=1:300
    traind_s(:,i)=traind(:,i)-mm(i); 
end
% 方差标准化
for i = 1:300
    ml(i) = std(traind_s(:,i));
end
for i=1:300
   traind_s(:,i)=traind_s(:,i)/ml(i); 
end

%% 训练
SampInEx = [traind_s';ones(1,nTrainNum)]; 
expectedOut=trainl;

eb = 0.01;                   % 误差容限 
eta = 0.6;                   % 学习率 
mc = 0.8;                    % 动量因子 
maxiter = 2000;              % 最大迭代次数 
iteration = 0;               % 第一代
 
errRec = zeros(1,maxiter); 
outRec = zeros(nTrainNum, maxiter); 
NET=[]; % 记录
% 开始迭代
for i = 1 : maxiter 
    hid_input = net.w1 * SampInEx;     % 隐含层的输入
    hid_out = logsig(hid_input);       % 隐含层的输出 
    
    ou_input1 = [hid_out;ones(1,nTrainNum)];   % 输出层的输入
    ou_input2 = net.w2 * ou_input1;
    out_out = logsig(ou_input2);                  % 输出层的输出 
    
    outRec(:,i) = out_out';                       % 记录每次迭代的输出
     
    err = expectedOut - out_out;                  % 误差
    sse = sumsqr(err);       
    errRec(i) = sse;                              % 保存误差值  
    fprintf('第 %d 次迭代   误差:  %f\n', i, sse);
    iteration = iteration + 1;   
    % 判断是否收敛
    if sse<=eb
        break;
    end 
    
    % 误差反向传播
    % 隐含层与输出层之间的局部梯度
    DELTA = err.*dlogsig(ou_input2,out_out);      
    % 输入层与隐含层之间的局部梯度
    delta = net.w2(:,1:end-1)' * DELTA.*dlogsig(hid_input,hid_out);
     
    % 权值修改量
    dWEX = DELTA*ou_input1'; 
    dwex = delta*SampInEx'; 
     
    %  修改权值，如果不是第一次修改，则使用动量因子 
    if i == 1 
        net.w2 = net.w2 + eta * dWEX; 
        net.w1 = net.w1 + eta * dwex; 
    else    
        net.w2 = net.w2 + (1 - mc)*eta*dWEX + mc * dWEXOld; 
        net.w1 = net.w1 + (1 - mc)*eta*dwex + mc * dwexOld; 
    end 
    % 记录上一次的权值修改量 
    dWEXOld = dWEX; 
    dwexOld = dwex; 
    
end     
 
%% 测试
% 测试数据归一化
for i=1:300
    testd_s(:,i)=testd(:,i)-mm(i); 
end

for i=1:300
   testd_s(:,i)=testd_s(:,i)/ml(i); 
end

% 计算测试输出
InEx=[testd_s';ones(1,120-nTrainNum)]; 
hid_input = net.w1 * InEx;
hid_out = logsig(hid_input);       % output of the hidden layer nodes 
ou_input1 = [hid_out;ones(1,120-nTrainNum)];
ou_input2 = net.w2 * ou_input1;
out_out = logsig(ou_input2);
out_out1=out_out;

% 取整
out_out(out_out<0.5)=0;
out_out(out_out>=0.5)=1;
% 正确率
rate = sum(out_out == testl)/length(out_out);


fprintf('最终迭代次数\n    %d\n', iteration);
fprintf('正确率:\n    %f%%\n', rate*100);


