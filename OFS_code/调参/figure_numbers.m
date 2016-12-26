clear all;clc;
% x=5:5:30;
% load FPR.mat;
% load recall.mat;
% load precision.mat;
load f_measure.mat;
figure
plot(x,y1*100,'r-d')
hold on
plot(x,y2*100,'b--o')
hold on
plot(x,y3*100,'g--+')
hold on
plot(x,y4*100,'m--x')
figure_FontSize=12;
legend('OFS','Fisher+SVM','Gini+SVM','Variance+SVM');
xlabel('特征选择数量/个');
% ylabel('FPR /%')
% ylabel('Recall /%')
% ylabel('Precision /%')
ylabel('F-measure /%')
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','cap');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','bottom');
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
grid off
box off
