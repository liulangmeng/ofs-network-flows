clear all;close all;clc;

% [train_y,train_x]=libsvmread('data');
% Train the model and get the primal variables w, b from the model
% Libsvm options
% -t 0 : linear kernel
% Leave other options as their defaults 
%% 
load svm.mat;
[n,d]       = size(data);
% ID_list = ID_ALL;
Y = data(1:n,1);
X = data(1:n,2:d);

stdX=std(X); %计算标准差
idx1=stdX~=0; %判断元素是否为0
centrX=X-repmat(mean(X),size(X,1),1); %减去平均值
X(:,idx1)=centrX(:,idx1)./repmat(stdX(:,idx1),size(X,1),1); %除以标准差

% X=(X-repmat(mean(X),size(X,1),1))./repmat(std(X),size(X,1),1);
 X=X./repmat(sqrt(sum(X.*X,2)),1, size(X,2));
%%
model=svmtrain(Y,X,'-t 0');
w = model.SVs' * model.sv_coef;
b = -model.rho;
if (model.Label(1) == -1)%利用逻辑判断，解释运行时注释掉某些语句
    w = -w; b = -b;
end

% [test_y,test_x]=libsvmread('email_test.txt');
%%
load Mawilab01.mat;
[n,d]       = size(data);
% ID_list = ID_ALL;
Y = data(1:n,1);
X = data(1:n,2:d);

stdX=std(X); %计算标准差
idx1=stdX~=0; %判断元素是否为0
centrX=X-repmat(mean(X),size(X,1),1); %减去平均值
X(:,idx1)=centrX(:,idx1)./repmat(stdX(:,idx1),size(X,1),1); %除以标准差

% X=(X-repmat(mean(X),size(X,1),1))./repmat(std(X),size(X,1),1);
 X=X./repmat(sqrt(sum(X.*X,2)),1, size(X,2));
%%
[predicted_label,accuracy,decision_values]=svmpredict(Y,X,model);
