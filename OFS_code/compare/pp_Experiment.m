function[Recall,FPR,Precision,F_measure]= pp_Experiment(dataset_name,data)
%%

% [Recall,FPR,Precision,F_measure]=pp_Experiment('Mawilab01.mat',data)

%% load dataset
%     load(sprintf('data_moore/%s',dataset_name));
        load(sprintf('%s',dataset_name));
%      load(sprintf('data_mawilab/%s',dataset_name));
%% 数据预处理
[n,d] = size(data);
Y = data(1:n,1);
X = data(1:n,2:d);
stdX=std(X); %计算标准差
idx1=stdX~=0; %判断元素是否为0
centrX=X-repmat(mean(X),size(X,1),1); %减去平均值
X(:,idx1)=centrX(:,idx1)./repmat(stdX(:,idx1),size(X,1),1); %除以标准差
X=X./repmat(sqrt(sum(X.*X,2)),1, size(X,2));
data=[Y,X];
options.t_tick=round(n/15);

%% 划分训练集和测试集
data_xun=data(1:round(0.8*n),:);
data_ce=data(round(0.8*n)+1:end,:);
[n_xun,d]= size(data_xun);
[n_ce,d]= size(data_ce);
Y_xun = data_xun(1:n_xun,1);
X_xun = data_xun(1:n_xun,2:d);
Y_ce = data_ce(1:n_ce,1);
X_ce = data_ce(1:n_ce,2:d);
n_z=sum(Y_ce()==1);
n_f=sum(Y_ce()==-1);
% [ID_xun]=create_rand_ID(n_xun, 1);
% [ID_ce]=create_rand_ID(n_ce, 1);
[ID_xun]=create_order_ID(n_xun, 1);
[ID_ce]=create_order_ID(n_ce, 1);

%% 调选择特征数
options.NumFeature=45;
%% run experiments:
%% 训练
for i=1:1,
    ID = ID_xun(i,:);
    [classifier, err_count,run_time, mistakes, mistakes_idx, SVs, TMs] = OFS(X_xun, Y_xun,options,ID);
    w_ofs=classifier.w;
end
%% 测试
for i=1:1,
    ID = ID_ce(i,:);
    w_ce=w_ofs;
    [classifier, err_count,err_count_z,err_count_f ,run_time, mistakes, pr_mistakes_idx] = Predict_OFS(X_ce, Y_ce,options,ID,w_ce);
    err(i) = err_count;
    err_z(i)=err_count_z;
    err_f(i)=err_count_f;
end
err=err(i);
err_z=err_z(i);
err_f=err_f(i);
P=n_z;
N=n_f;
TP=n_z-err_z;
TN=n_f-err_f;
FP=err_f;
FN=err_z;
Recall=TP/(TP+FN);
FPR=FP/(FP+TN);
Precision=TP/(TP+FP);
F_measure=(2*Precision*Recall)/(Precision+Recall);
