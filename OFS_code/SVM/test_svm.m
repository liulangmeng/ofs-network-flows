clear all;close all;clc;
%  profile on -memory;

%% 导入数据集
load 'Mawilab01';
%% 特征选择
[n,d] = size(data);
Y = data(1:n,1);
X_y = data(1:n,2:d);

n_m=5:10:45;
for i=1:size(n_m,2)
    num_selected= n_m(i);
    %     tic
    %     [out] = fsFisher(X_y,Y);
    %     selected_f=out.fList(1:num_selected);
    %     time_st=toc
    %     tic
    %     [out] = fsGini(X_y,Y);
    %     selected_g=out.fList(1:num_selected);
    %     time_st=toc
    % %     X=X_y(:,sort(selected_f));
    %     X=X_y(:,sort(selected_g));
    % selected_g=out.fList(1:num_selected);
    tic
    [selected_features,score] = VarianceScore(X_y,num_selected);
    X=X_y(:,selected_features);
    time_st=toc;
    %% 数据预处理
    
    stdX=std(X); %计算标准差
    idx1=stdX~=0; %判断元素是否为0
    centrX=X-repmat(mean(X),size(X,1),1); %减去平均值
    X(:,idx1)=centrX(:,idx1)./repmat(stdX(:,idx1),size(X,1),1); %除以标准差
    X=X./repmat(sqrt(sum(X.*X,2)),1, size(X,2));
    data=[Y,X];
    
    %% 划分训练集和测试集
    data_xun=data(1:round(0.8*n),:);
    data_ce=data(round(0.8*n)+1:end,:);
    [n_xun,d]= size(data_xun);
    [n_ce,d]= size(data_ce);
    Y_xun = data_xun(1:n_xun,1);
    X_xun = data_xun(1:n_xun,2:d);
    Y_ce = data_ce(1:n_ce,1);
    X_ce = data_ce(1:n_ce,2:d);
    data=[Y_xun,X_xun];
    data_test=[Y_ce,X_ce];
    dataset_name = 'Mawilab01';
    % load(sprintf('data/%s.mat',dataset_name));
    [model,overalltime] = cvsvm(data,dataset_name);
    svm_test(model,data_test,dataset_name,overalltime,time_st);
end
%  profile viewer