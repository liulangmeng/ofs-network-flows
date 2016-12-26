function [model,overalltime] = cvsvm(data,dataset_name)

label=zeros(2,1);                               %   Find and save in 'label' class label from training and testing data sets
label(1,1)=-1;
label(2,1) = 1;
j=1;
number_class=2;
Perfomces = zeros(number_class,5);        %TPR,FPR,Pre,Recall,Fmeasure
Perfomces_std = zeros(number_class,5);        %TPR,FPR,Pre,Recall,Fmeasure
NumberofOutputNeurons=number_class;
% dataset = dir('.\mawilab\*.mat');
% for dataid = 2:4
% dataid=1;
% load(['.\mawilab\',dataset(dataid).name]);
% load 'data/Moore_complete.mat';
% load(sprintf('data/%s.mat',dataset_name));
feature=data(:,2:end);
label=data(:,1);
data=[feature,label];
positivesample = sum(data(:, end)==1);
negativesample = sum(data(:, end)==-1);
% x = find(data(:, 249));
% data(x,249)=-1;
% x = find(data(:, 249)==0);
% data(x,249)=1;
% clear x;

[m n] = size(data);
indices = crossvalind('Kfold',m,10);
acc = zeros(10,1);
total_time=zeros(10,1);%算法运行总时间统计，训练时间加上测试时间
training_time=zeros(10,1);

Perfomces = zeros(number_class,5);        %TPR,FPR,Pre,Recall,Fmeasure

TPR = zeros(2,10);
FPR = zeros(2,10);
PRE = zeros(2,10);
FM = zeros(2,10);
for kv =1:10
    test = (indices == kv); train = ~test;
    train_data = data(train,:);
    test_data = data(test,:);
    T=train_data(:,size(train_data,2));
    P=train_data(:,1:size(train_data,2)-1);
    clear train_data;
    TV.T=test_data(:,size(test_data,2));
    TV.P=test_data(:,1:size(test_data,2)-1);
    clear test_data;
    start_time_train=cputime;
    model = svmtrain(T, P);
    end_time_train=cputime;
    TrainingTime=end_time_train-start_time_train
    training_time(kv,1)=TrainingTime(1);
    start_time_test = cputime;
    [predict_label, accuracy, dec_valueH_tests] = svmpredict(TV.T, TV.P, model);
    end_time_test=cputime;
    TestingTime=end_time_test-start_time_test         %   Calculate CPU time (seconds) spent by ELM predicting the whole testing data
    time=TrainingTime+TestingTime
    total_time(kv,1)=time(1);
    acc(kv,1) = accuracy(1);
    
    eachclassdetail=zeros(2,4);        %TP,FN,FP,TN
    MissClassificationRate_Testing=0;
    for i = 1 : size(TV.T, 1)
        label_index_expected=TV.T(i,:);                     % -1 or 1
        label_index_actual=sign(predict_label(i,:));        % -1 or 1
        if label_index_actual~=label_index_expected
            eachclassdetail(indexs(label_index_expected),2) = eachclassdetail(indexs(label_index_expected),2)+1;
            eachclassdetail(indexs(label_index_actual),3) = eachclassdetail(indexs(label_index_actual),3)+1;
            MissClassificationRate_Testing=MissClassificationRate_Testing+1;
        else
            eachclassdetail(indexs(label_index_actual),1) = eachclassdetail(indexs(label_index_actual),1)+1;
            for kind = 1:NumberofOutputNeurons
                if kind ~=indexs(label_index_actual)
                    eachclassdetail(kind,4) = eachclassdetail(kind,4)+1;
                end
            end
            %eachclassrate(label_index_actual,1) = eachclassrate(label_index_actual,1)+1;
        end
    end
    TestingAccuracy = 1-MissClassificationRate_Testing/size(TV.T,1)
    recall = eachclassdetail(:,1)./(eachclassdetail(:,1)+eachclassdetail(:,2));
    precession = eachclassdetail(:,1)./(eachclassdetail(:,1)+eachclassdetail(:,3));
    
    TPR(:,kv) = recall;
    FPR(:,kv) = eachclassdetail(:,3)./(eachclassdetail(:,3)+eachclassdetail(:,4));
    PRE(:,kv) = precession;
    FM(:,kv) = 2*precession.*recall./(precession+recall);
end

Perfomces(:,1) = mean(TPR,2);
Perfomces(:,2) = mean(FPR,2);
Perfomces(:,3) = mean(PRE,2);
Perfomces(:,5) = mean(FM,2);
Perfomces(:,4) = Perfomces(:,1);

Perfomces_std(:,1) = std(TPR,0,2);
Perfomces_std(:,2) = std(FPR,0,2);
Perfomces_std(:,3) = std(PRE,0,2);
Perfomces_std(:,5) = std(FM,0,2);
Perfomces_std(:,4) = Perfomces_std(:,1);
fprintf(1,'-------------results-----------\n');

%10-fold交叉验证后的平均错误及标准差
overallaccuracy = mean(acc/100)
overallaccuracy_std = std(acc/100)

%10-fold交叉验证后的平均错误及标准差
mistake_rate=(100-acc)/100;
overallmistake = mean(mistake_rate)
overallmistake_std = std(mistake_rate)


%10-fold交叉验证后的平均运行时间及标准差，包括训练和测试时间
overalltime = mean( total_time)
overalltime_std = std( total_time)

%10-fold交叉验证后的平均训练时间和标准差
trainingtime = mean( training_time)
trainingtime_std = std(training_time)

% savefile = ['.\resultsvmcomparewithonline\result_',dataset(dataid).name];
% save(savefile);
% save('Moore_complete_model','model');
% load handel
% sound(y,Fs)
% fid = fopen('results_svm.txt','at'); 
% fprintf(fid,'Dataset name: %s   overalltime=%0.4f ', dataset_name,overalltime);
% fclose(fid);
end











