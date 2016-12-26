clear all;close all;clc;

% [train_y,train_x]=libsvmread('data');
% Train the model and get the primal variables w, b from the model
% Libsvm options
% -t 0 : linear kernel
% Leave other options as their defaults 
%% �������ݼ�
% load moore01.mat;
% profile on -memory;
load moore01.mat;
%% ����ѡ��
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
%% ����Ԥ����

stdX=std(X); %�����׼��
idx1=stdX~=0; %�ж�Ԫ���Ƿ�Ϊ0
centrX=X-repmat(mean(X),size(X,1),1); %��ȥƽ��ֵ
X(:,idx1)=centrX(:,idx1)./repmat(stdX(:,idx1),size(X,1),1); %���Ա�׼��
X=X./repmat(sqrt(sum(X.*X,2)),1, size(X,2));
data=[Y,X];

%% ����ѵ�����Ͳ��Լ�
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
if (model.Label(1) == -1)%�����߼��жϣ���������ʱע�͵�ĳЩ���
    w = -w; b = -b;
end

% [test_y,test_x]=libsvmread('email_test.txt');
%% ����
[predicted_label,accuracy,decision_values]=svmpredict(Y_ce,X_ce,model);
time=toc
% profile viewer;
