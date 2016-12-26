function Experiment(dataset_name,data)
%%
% Experiment('moore07.mat',data)
% Experiment('Mawilab01.mat',data)

%% load dataset
%     load(sprintf('data_moore/%s',dataset_name));
        load(sprintf('%s',dataset_name));
%      load(sprintf('data_mawilab/%s',dataset_name));
%% ����Ԥ����
[n,d] = size(data);
Y = data(1:n,1);
X = data(1:n,2:d);
stdX=std(X); %�����׼��
idx1=stdX~=0; %�ж�Ԫ���Ƿ�Ϊ0
centrX=X-repmat(mean(X),size(X,1),1); %��ȥƽ��ֵ
X(:,idx1)=centrX(:,idx1)./repmat(stdX(:,idx1),size(X,1),1); %���Ա�׼��
X=X./repmat(sqrt(sum(X.*X,2)),1, size(X,2));
data=[Y,X];
options.t_tick=round(n/15);

%% ����ѵ�����Ͳ��Լ�
data_xun=data(1:round(0.8*n),:);
data_ce=data(round(0.8*n)+1:end,:);
[n_xun,d]= size(data_xun);
[n_ce,d]= size(data_ce);
Y_xun = data_xun(1:n_xun,1);
X_xun = data_xun(1:n_xun,2:d);
Y_ce = data_ce(1:n_ce,1);
X_ce = data_ce(1:n_ce,2:d);
% [ID_xun]=create_rand_ID(n_xun, 1);
% [ID_ce]=create_rand_ID(n_ce, 1);
[ID_xun]=create_order_ID(n_xun, 1);
[ID_ce]=create_order_ID(n_ce, 1);

%% ��ѡ��������
options.NumFeature=45;
%% run experiments:
%% ѵ��
for i=1:1,
%     fprintf(1,'ѵ��:running on the %d-th trial...\n',i);
    ID = ID_xun(i,:);
    [classifier, err_count,run_time, mistakes, mistakes_idx, SVs, TMs] = OFS(X_xun, Y_xun,options,ID);
%     fprintf(1,'OFSD: The number of mistakes = %d\n', err_count);
    nSV_OFS(i) = length(classifier.SV);
    err_OFS(i) = err_count;
    time_OFS(i) = run_time;
    mistakes_list_OFS(i,:) = mistakes;
    SVs_OFS(i,:) = SVs;
    TMs_OFS(i,:) = TMs;
    w_ofs=classifier.w;
end
%% ����
for i=1:1,
%     fprintf(1,'���ԣ�running on the %d-th trial...\n',i);
    ID = ID_ce(i,:);
    w_ce=w_ofs;
    [classifier, err_count, run_time, mistakes, pr_mistakes_idx] = Predict_OFS(X_ce, Y_ce,options,ID,w_ce);
%     fprintf(1,'Predict_OFS: The number of mistakes = %d\n', err_count);
    err_Predict_OFS(i) = err_count;
    time_Predict_OFS(i) = run_time;
    mistakes_list_Predict_OFS(i,:) = mistakes;
end
%%

%% ��ѵ�����ͼ
% mistakes_idx = 1:length(mistakes_idx);
% figure
% figure_FontSize=12;
% 
% mean_mistakes_OFS = mean(mistakes_list_OFS,1);
% % semilogx(2.^(mistakes_idx-1), mean_mistakes_OFS,'r-s'); %X��ȡ����
% semilogx(2.^mistakes_idx, mean_mistakes_OFS,'b-o'); %X��ȡ����
% % legend('RAND_{sele}','PE_{trun}','OFS','OFS_{predict}');
% hold on;
% mistakes_idx = 1:length(pr_mistakes_idx);
% mean_mistakes_Predict_OFS = mean(mistakes_list_Predict_OFS,1);
% semilogx(2.^mistakes_idx, mean_mistakes_Predict_OFS,'r-s'); %X��ȡ����
% legend('OFS_{train}','OFS_{test}');
% xlabel('������ģ');
% ylabel('׼ȷ��')
% 
% %  'baseline' | 'top' | 'cap' | 'middle' | 'bottom'.
% set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','cap');
% set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','bottom');
% set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
% grid on
% 


%% ��ӡ���

fprintf(1,'���Խ����\n');
fprintf(1,'----------------------------------------------------------------------------------------------------\n');
fprintf(1,'Predict_OFS:( number of mistakes \t  cpu running time_OFS \t accuracy_Predict_OFS\t\t)\n');
fprintf(1,' \t \t\t %.4f \t%.4f \t\t %.4f \t %.4f\t\t %.4f \t %.4f\n', mean(err_Predict_OFS,1), std(err_Predict_OFS,1), ...
    mean(time_Predict_OFS,1), std(time_Predict_OFS,1),1-((mean(err_Predict_OFS,1))/n_ce), ((std(err_Predict_OFS))/n_ce));
fprintf(1,'----------------------------------------------------------------------------------------------------\n');