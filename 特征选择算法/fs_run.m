close all;clc;clear all;
load Mawilab01.mat;
[n,d]=size(data);
X=data(:,2:d);
Y=data(:,1);
num_selected=10;
% tic
% [out] = fsFisher(X,Y);
% selected_f=out.fList(1:num_selected);
% time=toc
%  [out] = fsChiSquare(X,Y);
%  selected_c=out.fList(1:num_selected);
tic
[out] = fsGini(X,Y);
selected_g=out.fList(1:num_selected);
time=toc;
