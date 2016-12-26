clear all;close all;clc;

% [train_y,train_x]=libsvmread('data');
% Train the model and get the primal variables w, b from the model
% Libsvm options
% -t 0 : linear kernel
% Leave other options as their defaults 
%% 导入数据集
% load moore01.mat;
% profile on -memory;
load moore01.mat;
%% 特征选择
[n,d] = size(data);
Y = data(1:n,1);
X = data(1:n,2:d);
num_selected=248;
tic
[out] = fsFisher(X,Y);
selected_f=out.fList(1:num_selected);
time=toc
% tic
% [out] = fsGini(X,Y);
% selected_g=out.fList(1:num_selected);

X=X(:,sort(selected_f));
% X=X(:,sort(selected_g));
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
%%
model=svmtrain(Y_xun,X_xun,'-s 1 -t 2');
w = model.SVs' * model.sv_coef;
b = -model.rho;
if (model.Label(1) == -1)%利用逻辑判断，解释运行时注释掉某些语句
    w = -w; b = -b;
end

% [test_y,test_x]=libsvmread('email_test.txt');
%% 测试
[predicted_label,accuracy,decision_values]=svmpredict(Y_ce,X_ce,model);
time=toc
% profile viewer;
