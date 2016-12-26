function [w_B]=truncate(w,NumFeature)  %保留大的，去掉小的

if sum(w~=0)>NumFeature,
    [sw,index] = sort(abs(w),'descend');
    sw(NumFeature+1:end)=0;
    [sw1,index1]=sort(index);
    w_B=sw(index1).*sign(w);
else
    w_B=w;
end