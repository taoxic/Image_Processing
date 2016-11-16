% ������ʽѵ��BP���磬ʵ����Ϊʶ��

%% ����
clear all 
clc 

%% ��������
[data,label]=getdatax;

%% ��������
[traind,trainl,testd,testl]=dividex(data,label);

%% ���ò���
rng('default') %���������������
rng(0) %���������������
nTrainNum = 60; % 60��ѵ������
nSampDim = 300;   % ������300ά��

%% �������� ʹ��net�Ľṹ���ʾBP�����磬�����д��뽫Ȩֵ��ʼ��Ϊһ����С�������
net.nIn=300;  % �����300����Ԫ
net.nHidden = 25;    % 25��������ڵ�
net.nOut = 1;       % һ�������ڵ�

w = 2*(rand(net.nHidden,net.nIn)-1/2);  % nHidden * 300�ľ��� һ�д���һ��������ڵ�
b = 2*(rand(net.nHidden,1)-1/2); %nHidden *1 �ľ���
net.w1 = [w,b]; 

W = 2*(rand(net.nOut,net.nHidden)-1/2); 
B = 2*(rand(net.nOut,1)-1/2); 
net.w2 = [W,B]; 

%% ѵ�����ݹ�һ��
mm=mean(traind); %��ʾ�����traind�ľ�ֵ��Ĭ�ϵ�������еľ�ֵ
% ��ֵƽ��
for i=1:300
    traind_s(:,i)=traind(:,i)-mm(i); 
end
% �����׼��
for i = 1:300
    ml(i) = std(traind_s(:,i));
end
for i=1:300
   traind_s(:,i)=traind_s(:,i)/ml(i); 
end

%% ѵ��
SampInEx = [traind_s';ones(1,nTrainNum)]; 
expectedOut=trainl;

eb = 0.01;                   % ������� 
eta = 0.6;                   % ѧϰ�� 
mc = 0.8;                    % �������� 
maxiter = 2000;              % ���������� 
iteration = 0;               % ��һ��
 
errRec = zeros(1,maxiter); 
outRec = zeros(nTrainNum, maxiter); 
NET=[]; % ��¼
% ��ʼ����
for i = 1 : maxiter 
    hid_input = net.w1 * SampInEx;     % �����������
    hid_out = logsig(hid_input);       % ���������� 
    
    ou_input1 = [hid_out;ones(1,nTrainNum)];   % ����������
    ou_input2 = net.w2 * ou_input1;
    out_out = logsig(ou_input2);                  % ��������� 
    
    outRec(:,i) = out_out';                       % ��¼ÿ�ε��������
     
    err = expectedOut - out_out;                  % ���
    sse = sumsqr(err);       
    errRec(i) = sse;                              % �������ֵ  
    fprintf('�� %d �ε���   ���:  %f\n', i, sse);
    iteration = iteration + 1;   
    % �ж��Ƿ�����
    if sse<=eb
        break;
    end 
    
    % ���򴫲�
    % �������������֮��ľֲ��ݶ�
    DELTA = err.*dlogsig(ou_input2,out_out);      
    % �������������֮��ľֲ��ݶ�
    delta = net.w2(:,1:end-1)' * DELTA.*dlogsig(hid_input,hid_out);
     
    % Ȩֵ�޸���
    dWEX = DELTA*ou_input1'; 
    dwex = delta*SampInEx'; 
     
    %  �޸�Ȩֵ��������ǵ�һ���޸ģ���ʹ�ö������� 
    if i == 1 
        net.w2 = net.w2 + eta * dWEX; 
        net.w1 = net.w1 + eta * dwex; 
    else    
        net.w2 = net.w2 + (1 - mc)*eta*dWEX + mc * dWEXOld; 
        net.w1 = net.w1 + (1 - mc)*eta*dwex + mc * dwexOld; 
    end 
    % ��¼��һ�ε�Ȩֵ�޸��� 
    dWEXOld = dWEX; 
    dwexOld = dwex; 
    
end     
 
%% ����
% �������ݹ�һ��
for i=1:300
    testd_s(:,i)=testd(:,i)-mm(i); 
end

for i=1:300
   testd_s(:,i)=testd_s(:,i)/ml(i); 
end

% ����������
InEx=[testd_s';ones(1,120-nTrainNum)]; 
hid_input = net.w1 * InEx;
hid_out = logsig(hid_input);       % output of the hidden layer nodes 
ou_input1 = [hid_out;ones(1,120-nTrainNum)];
ou_input2 = net.w2 * ou_input1;
out_out = logsig(ou_input2);
out_out1=out_out;

% ȡ��
out_out(out_out<0.5)=0;
out_out(out_out>=0.5)=1;
% ��ȷ��
rate = sum(out_out == testl)/length(out_out);


fprintf('���յ�������\n    %d\n', iteration);
fprintf('��ȷ��:\n    %f%%\n', rate*100);


