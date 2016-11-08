data = A;
species = {'app';'app';'app';'app';'app';'app';'app';'app';'app';'app';'ban';'ban';'ban';'ban';'ban';'ban';'ban';'ban';'ban';'ban'};
groups = ismember(species,'app');
[train,test] = crossvalind('holdOut',groups);
cp = classperf(groups);
svm_struct = svmtrain(data(train,:),groups(train));
classes = svmclassify(svm_struct,data(test,:));
classperf(cp,classes,test);
cp.CorrectRate;