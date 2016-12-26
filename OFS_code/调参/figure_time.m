clear all;clc;
% x=5:5:30;
load time.mat;
figure
plot(x,y1,'b--o')
hold on
plot(x,y3,'g--x')
hold on
plot(x,y4,'r-s')
figure_FontSize=12;
legend('Fisher','Variance','OFS');
xlabel('特征选择数量/个');
ylabel('运行时间/秒')
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','cap');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','bottom');
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
grid off
box off
