clear all;clc;
load canshu01.mat
x=c_eta;
y=c_lamda;
z=error;
[y,x]=meshgrid(y,x);
mesh(x,y,z*100);
xlabel('\eta');
ylabel('\lambda');
zlabel('����׼ȷ��/%');
grid off
% �Ҿ������Ԫ�ؼ�����
% [x,y]=find(error==max(max(error)))
set(gca,'TickDir','in')