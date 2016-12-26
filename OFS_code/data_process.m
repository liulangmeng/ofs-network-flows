function[data,ID_ALL]=data_process(dataset_name,data)
%%
% load(sprintf('Moore/mawilab/%s',dataset_name));
[n,d]       = size(data);
Y = data(1:n,249);
X = data(1:n,1:d-1);
index_ordi=find(Y==0);
index_anom=find(Y~=0);
Y(index_ordi)=1;
Y(index_anom)=-1;
data=[Y,X];
%%
% ID_ALL=create_rand_ID(n, 20);

end

