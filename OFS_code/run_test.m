%%
clear all;close all;clc;
%% OFS_full
addpath('E:\����������ʵ��_OFS\OFS\OFS(code_datasets)\OFS_code\OFS_full information')
addpath('E:\����������ʵ��_OFS\OFS\OFS(code_datasets)\OFS_code\data_mawilab')
%%
% fid=['result50','.txt'];
% c=fopen(fid,'at');
% fprintf(c,'\n����:\noptions.NumFeature=25\neta = 15\nlambda = 0.0001\n\n');
% %%
for i=1:6
%      fprintf(c,sprintf('���ݼ���Mawilab0%d\n',i));
    Experiment(sprintf('Mawilab0%d',i));
%     saveas(gcf,sprintf('X15_moore0%d',i),'jpg')
%     saveas(gcf,sprintf('25_Mawilab0%d',i),'jpg')
end
%%
rmpath('E:\����������ʵ��\OFS\OFS(code_datasets)\OFS_code\OFS_full information')
rmpath('E:\����������ʵ��\OFS\OFS(code_datasets)\OFS_code\data_mawilab')