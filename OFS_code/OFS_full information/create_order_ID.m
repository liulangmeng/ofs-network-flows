function [ID_ALL] = create_order_ID(n, t)
%generate random permutation of training instances
% n - dataset size
% t - number of trials, usually set to 20
ID_ALL=[];
for i=1:t,
    ID_ALL = [ID_ALL; 1:n];
end
