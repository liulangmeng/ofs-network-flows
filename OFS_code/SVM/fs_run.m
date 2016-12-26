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
%   [selected_features,score] = FisherScore(X,Y,num_selected);
%  [out] = fsChiSquare(X,Y);
%  selected_c=out.fList(1:num_selected);
tic
[selected_features,score] = VarianceScore(X,5);
% selected_g=out.fList(1:num_selected);
time=toc;
