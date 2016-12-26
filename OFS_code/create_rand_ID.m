function [ID_ALL] = create_rand_ID(n, t)
%generate random permutation of training instances
% n - dataset size
% t - number of trials, usually set to 20
ID_ALL=[];
for i=1:t,
    ID_ALL = [ID_ALL; randperm(n)];
end
