clear all;close all;clc;
% load Moore_binary;
% x=X{11};
% y = Y{11};
% [n,d]       = size(x);
% data=[y,x];
% %%
% ID_ALL=create_rand_ID(n, 20);
%%
load mooreXY.mat;
x=X{11};
 y = Y{11};
[n,d]       = size(x);
% Y = data(1:n,249);
% X = data(1:n,1:d-1);
% index_ordi=find(Y==0);
index_anom=find(y~=1);
% Y(index_ordi)=1;
y(index_anom)=-1;
data=[y,x];
%%
ID_ALL=create_rand_ID(n, 20);