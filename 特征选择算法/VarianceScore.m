function [selected_features,score] = VarianceScore(X,num_selected)
%
% X - The data,every row is a sample每行为一个样本
% num_selected - The number to be selected
% selected_features - The index of the selected features 

[n,d] = size(X);
score = zeros(d,1);
for r=1:d
    
   % X(:,r) = X(:,r)./norm( X(:,r),2);
    
    Ur = mean(X(:,r));
    Vr=0;
    for i=1:n
        Vr = Vr + (X(i,r)-Ur).^2;
    end
    score(r) = Vr;
end
 [sorted_score, sorted_index] = sort(score,'descend');
 selected_features = sorted_index(1:num_selected);
end