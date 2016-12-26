
function svm_test(model,data_test,dataset_name,overalltime,time_st)

% load 'data/Moore_complete.mat';
% load Moore_complete_model.mat;

start_time_test = cputime;
[predict_label, accuracy, dec_valueH_tests] = svmpredict(data_test(:,1),data_test(:,2:end),model);
end_time_test=cputime;
%% 计算recall和percision
Y=data_test(:,1);
tp=sum(predict_label(Y==1)==Y(Y==1));
tn=sum(predict_label(Y==-1)==Y(Y==-1))
fn=sum(predict_label(Y==1)~=Y(Y==1));
fp=sum(predict_label(Y==-1)~=Y(Y==-1));
recall=tp/(tp+fn);
FPR=fp/(fp+tn);
precision=tp/(tp+fp);
f_mesure=2*recall*precision/(recall+precision);
%%
mistake=(100-accuracy)/100
TestingTime=end_time_test-start_time_test+overalltime+time_st;
%% 写文件
% TODO
fid = fopen('results_VS.txt','at'); 
fprintf(fid,'Dataset name: %s  accuracy=%0.4f  TestingTime=%0.4f precision=%0.4f recall=%0.4f f_mesure=%0.4f  FPR=%0.4f\n\n', dataset_name,accuracy(1)/100,TestingTime,precision,recall,f_mesure,FPR);
fclose(fid);
end
