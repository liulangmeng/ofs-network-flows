function [classifier, err_count, run_time, mistakes, pre_mistakes_idx] = Predict_OFS(X, Y,options,id_list,w_ce)
%% ≥ı ºªØ
 ID = id_list;
err_count = 0;
t_tick = options.t_tick;
mistakes = [];
pre_mistakes_idx = [];

%%
k = 2;
w=w_ce;
%% loop
tic
for t = 1:length(ID),
    id = ID(t);    
    %% prediction
    x_t=X(id,:)';
    f_t=w'*x_t;
    y_t=Y(id);
   
    if y_t*f_t<=0,
        err_count=err_count+1;
    end
    %%
    run_time = toc;
    if (t==k)
        k = 2*k;
        mistakes = [mistakes (t-err_count)/t];
        pre_mistakes_idx = [pre_mistakes_idx t];
    end
end
classifier.w=w;
run_time = toc;

