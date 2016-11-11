% ========================================================================
% Image Classification using Bag of Words and Spatial Pyramid BoW
% Created by Piji Li (peegeelee@gmail.com)  
% Blog: http://www.zhizhihu.com
% QQ: 379115886
% IRLab. : http://ir.sdu.edu.cn     
% Shandong University,Jinan,China
% 10/24/2011
%% classification script using SVM

fprintf('\nClassification using Pyramid BOW histogram intersection kernel svm\n');
% load the BOW representations, the labels, and the train and test set
load(pg_opts.trainset);
load(pg_opts.testset);
load(pg_opts.labels);


%% sift
load([pg_opts.globaldatapath,'/',pyramid_opts.name])
train_labels    = labels(trainset);          % contains the labels of the trainset
train_data      = pyramid_all(:,trainset)';          % contains the train data
[train_labels,sindex]=sort(train_labels);    % we sort the labels to ensure that the first label is '1', the second '2' etc
train_data=train_data(sindex,:);
test_labels     = labels(testset);           % contains the labels of the testset
test_data       = pyramid_all(:,testset)';           % contains the test data


%% here you should of course use crossvalidation !
%% train kernal
kernel_train = hist_isect(train_data,train_data);
kernel_train = [(1:size(kernel_train,1))',kernel_train];
%%
bestcv = 0;
bestc=200;bestg=2;
% for log2c = -1:10,
%   for log2g = -1:0.1:1.5,
%     cmd = ['-v 2 -t 4 -c ', num2str(bestc), ' -g ', num2str(bestg)];
%     %cv = svmtrain(train_labels, train_data, cmd);
%     cv = svmtrain(train_labels, kernel_train, cmd);
%     if (cv >= bestcv),
%       bestcv = cv; 
%     end
%     fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
%   end
% end


options=sprintf('-s 0 -t 4 -c %f -b 1 -g %f -q',bestc,bestg);
%model=svmtrain(train_labels,train_data,options);
model=svmtrain(train_labels,kernel_train,options);

%[tmp svindex]=ismember(model.SVs, train_data,'rows');

%% kernel test
kernel_test = hist_isect(test_data,train_data);
kernel_test = [(1:size(kernel_test,1))',kernel_test];

%[predict_label, accuracy , dec_values] = svmpredict(test_labels,test_data, model,'-b 1');
[predict_label, accuracy , dec_values] = svmpredict(test_labels,kernel_test, model,'-b 1');

confusion_matrix = confusionmat(test_labels,predict_label);
