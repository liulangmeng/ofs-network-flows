function [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = OFS(X, Y, options, id_list,c_eta,c_lamda)
NumFeature=options.NumFeature;

ID = id_list;
err_count = 0;
t_tick = options.t_tick;
mistakes = [];
mistakes_idx = [];
SV = [];
SVs = [];
TMs=[];
%%   调参数
% eta = 0.2;
% lambda = 0.01;
eta =c_eta;
lambda =c_lamda;
%%
k = 1;
w=zeros(size(X,2),1);     % initialize the weight vector
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
%%  重点
        if y_t*f_t<=1,
    
            w= w+eta*y_t*x_t;
    %          w= (1-lambda*eta)*w+eta*y_t*x_t;
            w = w*min(1,1/(sqrt(lambda)*norm(w)));
            w=truncate(w,NumFeature);
            SV = [SV id];
        end
%     e=exp(-y_t*f_t);
%     l_e=log(1+e);
%     if l_e>0,
%             w= w+eta*y_t*x_t*e/(1+e);
%             w = w*min(1,1/(sqrt(lambda)*norm(w)));
%             w=truncate(w,NumFeature);
%             SV = [SV id];
%         end
%%
    run_time = toc;
    if (t==k)
        k = 2*k;
        mistakes = [mistakes (t-err_count)/t];
        mistakes_idx = [mistakes_idx t];
        SVs = [SVs length(SV)];
        TMs=[TMs run_time];
    end
end

classifier.SV = SV;
classifier.w = w;
run_time = toc;

