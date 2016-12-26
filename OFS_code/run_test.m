%%
clear all;close all;clc;
%% OFS_full
addpath('E:\网络流分类实验_OFS\OFS\OFS(code_datasets)\OFS_code\OFS_full information')
addpath('E:\网络流分类实验_OFS\OFS\OFS(code_datasets)\OFS_code\data_mawilab')
%%
% fid=['result50','.txt'];
% c=fopen(fid,'at');
% fprintf(c,'\n参数:\noptions.NumFeature=25\neta = 15\nlambda = 0.0001\n\n');
% %%
for i=1:6
%      fprintf(c,sprintf('数据集：Mawilab0%d\n',i));
    Experiment(sprintf('Mawilab0%d',i));
%     saveas(gcf,sprintf('X15_moore0%d',i),'jpg')
%     saveas(gcf,sprintf('25_Mawilab0%d',i),'jpg')
end
%%
rmpath('E:\网络流分类实验\OFS\OFS(code_datasets)\OFS_code\OFS_full information')
rmpath('E:\网络流分类实验\OFS\OFS(code_datasets)\OFS_code\data_mawilab')