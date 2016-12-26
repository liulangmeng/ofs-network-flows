function Experiment(dataset_name,data)
%%
% Experiment('test.mat',data)
% Experiment('Moore.mat',data)
% Experiment('moore07.mat',data)
% Experiment('a8a.mat',data)
% Experiment('entry1_norm.mat',data)
% Experiment('Mawi02.mat',data)
% Experiment('Mawilab01.mat',data)

%% load dataset
%       load(sprintf('Moore/%s',dataset_name));
% load(sprintf('data/%s',dataset_name));
%  load(sprintf('data_moore/%s',dataset_name));
     load(sprintf('%s',dataset_name));
%   load(sprintf('dataset/binary/lidong/%s',dataset_name));
%    load(sprintf('dataset/binary/wangyibing/%s',dataset_name));
%   load(sprintf('OFS_code/data_xiaomo/%s',dataset_name));
%   load(sprintf('OFS_code/data_mawilab/%s',dataset_name));

[n,d]       = size(data);
ID_list = ID_ALL;
Y = data(1:n,1);
X = data(1:n,2:d);

stdX=std(X); %计算标准差
idx1=stdX~=0; %判断元素是否为0
centrX=X-repmat(mean(X),size(X,1),1); %减去平均值
X(:,idx1)=centrX(:,idx1)./repmat(stdX(:,idx1),size(X,1),1); %除以标准差

%  X=(X-repmat(mean(X),size(X,1),1))./repmat(std(X),size(X,1),1);
X=X./repmat(sqrt(sum(X.*X,2)),1, size(X,2));

data=[Y,X];
options.t_tick=round(n/15);

%% 调选择特征数
% options.NumFeature=max(1,round(0.1*(d-1)));
options.NumFeature=max(1,round(1*(d-1)));
% eta = 1.9;
% lambda = 0.001;
%% run experiments:
for i=1:20,
    fprintf(1,'running on the %d-th trial...\n',i);
    ID = ID_list(i,:);
    
    %     [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = RND(X, Y, options, ID);
    %     fprintf(1,'Random selection: The number of mistakes = %d\n', err_count);
    %     nSV_RN(i) = length(classifier.SV);
    %     err_RN(i) = err_count;
    %     time_RN(i) = run_time;
    %     mistakes_list_RN(i,:) = mistakes;
    %     SVs_RN(i,:) = SVs;
    %     TMs_RN(i,:) = TMs;
    %
    %     [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = perceptron(X, Y,options,ID);
    %     fprintf(1,'Perceptron: The number of mistakes = %d\n', err_count);
    %     nSV_PE(i) = length(classifier.SV);
    %     err_PE(i) = err_count;
    %     time_PE(i) = run_time;
    %     mistakes_list_PE(i,:) = mistakes;
    %     SVs_PE(i,:) = SVs;
    %     TMs_PE(i,:) = TMs;
    
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = OFSGD(X, Y,options,ID);
    fprintf(1,'OFSD: The number of mistakes = %d\n', err_count);
    nSV_ODGD(i) = length(classifier.SV);
    err_ODGD(i) = err_count;
    time_ODGD(i) = run_time;
    mistakes_list_ODGD(i,:) = mistakes;
    SVs_ODGD(i,:) = SVs;
    TMs_ODGD(i,:) = TMs;
    %     w_ofs(i,:) =classifier.w;
    
end
% %% 测试
%     ID = ID_list(1,:);
%     w_ofs =mean(w_ofs);
%     [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = Predict_OFSGD(X, Y,options,ID,w_ofs);
%     fprintf(1,'Predict_OFSGD: The number of mistakes = %d\n', err_count);
%     nSV_Predict_OFSGD = length(classifier.SV);
%     err_Predict_OFSGD = err_count;
%     time_Predict_OFSGD = run_time;
%     mistakes_list_Predict_OFSGD = mistakes;
%     SVs_Predict_OFSGD = SVs;
%     TMs_Predict_OFSGD = TMs;
%%
mistakes_idx = 1:length(mistakes_idx);

%% print and plot results
figure
figure_FontSize=12;
% mean_mistakes_RN = mean(mistakes_list_RN);
% semilogx(2.^mistakes_idx, mean_mistakes_RN,'k.-'); %X轴取对数
% hold on
% mean_mistakes_PE = mean(mistakes_list_PE);
% semilogx(2.^mistakes_idx, mean_mistakes_PE,'b-x');

mean_mistakes_ODGD = mean(mistakes_list_ODGD);
semilogx(2.^mistakes_idx, mean_mistakes_ODGD,'r-s');

% legend('RAND_{sele}','PE_{trun}','OFS','OFS_{predict}');
legend('OFS');
xlabel('Number of samples');
ylabel('Online average rate of mistakes')

%  'baseline' | 'top' | 'cap' | 'middle' | 'bottom'.
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','cap');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','bottom');
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
grid on

fprintf(1,'---------------------------------------------------------------------------------------------------------\n');
% fprintf(1,'       RND: (number of mistakes     size of support vectors     cpu running time)\n');
% fprintf(1,'\t\t\t %.4f \t%.4f \t\t %.4f \t %.4f \t\t %.4f \t %.4f\n', mean(err_RN), std(err_RN), mean(nSV_RN), std(nSV_RN), mean(time_RN), std(time_RN));
% fprintf(1,'Perceptron: (number of mistakes     size of support vectors     cpu running time)\n');
% fprintf(1,'\t\t\t %.4f \t%.4f \t\t %.4f \t %.4f \t\t %.4f \t %.4f\n', mean(err_PE), std(err_PE), mean(nSV_PE), std(nSV_PE), mean(time_PE), std(time_PE));
fprintf(1,'OFSGD: (  number of mistakes        size of support vectors       cpu running time_ODG        accuracy     )\n');
fprintf(1,'  \t\t %.4f \t%.4f \t\t %.4f \t %.4f \t\t %.4f \t %.4f\t\t %.4f \t %.4f\n', mean(err_ODGD), std(err_ODGD), mean(nSV_ODGD), std(nSV_ODGD), mean(time_ODGD), std(time_ODGD),1-((mean(err_ODGD))/n), ((std(err_ODGD))/n));
fprintf(1,'---------------------------------------------------------------------------------------------------------\n');
%%
fid=['result','.txt'];
c=fopen(fid,'at');
fprintf(c,'---------------------------------------------------------------------------------------------------------\n');
% fprintf(1,'       RND: (number of mistakes     size of support vectors     cpu running time)\n');
% fprintf(1,'\t\t\t %.4f \t%.4f \t\t %.4f \t %.4f \t\t %.4f \t %.4f\n', mean(err_RN), std(err_RN), mean(nSV_RN), std(nSV_RN), mean(time_RN), std(time_RN));
% fprintf(1,'Perceptron: (number of mistakes     size of support vectors     cpu running time)\n');
% fprintf(1,'\t\t\t %.4f \t%.4f \t\t %.4f \t %.4f \t\t %.4f \t %.4f\n', mean(err_PE), std(err_PE), mean(nSV_PE), std(nSV_PE), mean(time_PE), std(time_PE));
fprintf(c,'OFSGD: (  number of mistakes        size of support vectors       cpu running time_ODG        accuracy     )\n');
fprintf(c,'  \t\t %.4f \t%.4f \t\t %.4f \t %.4f \t\t %.4f \t %.4f\t\t %.4f \t %.4f\n', mean(err_ODGD), std(err_ODGD), mean(nSV_ODGD), std(nSV_ODGD), mean(time_ODGD), std(time_ODGD),1-((mean(err_ODGD))/n), ((std(err_ODGD))/n));
fprintf(c,'---------------------------------------------------------------------------------------------------------\n');
fclose(c);