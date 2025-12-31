clear;clc
cd('E:\MSPaper\Data')
%% Basic Settings
load('FigureS4\PFC_SNR.mat')
load('FigureS4\PFC_SNR_P.mat')
%% Plot SNR Hippo
set(0, 'DefaultAxesFontName', 'Arial')
set(0, 'DefaultTextFontName', 'Arial')
set(0, 'DefaultAxesFontSize', 14)
set(0, 'DefaultTextFontSize', 10)
set(0, 'DefaultAxesLineWidth', 2)
set(0, 'DefaultFigureColor', 'w')

figure;
plot(hz,mean(snr,1),'k','LineWidth',4)
set(gca,'xlim',[1,20],'FontName','Arial');xlabel('Frequency (Hz)');ylabel('SNR');xline(4,'r--','LineWidth',2);
xticks([1,4,8,12,16,20]);box off;
set(gca, 'FontSize', 26 , 'LineWidth', 2, 'TickDir', 'out');
ylim([0,3])


figure;
sidx = signIdx.p005;
set(gcf,'Position',[680   225   480   653])
plot(hz,mean(snr(sidx,:),1),'k','LineWidth',4,'Color','k')
set(gca,'xlim',[1,20],'FontName','Arial');xlabel('Frequency (Hz)');ylabel('SNR');xline(4,'k--','LineWidth',2);
xticks([1,4,8,12,16,20]);box off;
set(gca, 'FontSize', 26 , 'LineWidth', 2, 'TickDir', 'out');
ylim([0,3])

figure;
sidx = nonsignIdx.p005;
set(gcf,'Position',[680   225   480   653])
plot(hz,mean(snr(sidx,:),1),'k','LineWidth',4,'Color','k')
set(gca,'xlim',[1,20],'FontName','Arial');xlabel('Frequency (Hz)');ylabel('SNR');xline(4,'k--','LineWidth',2);
xticks([1,4,8,12,16,20]);box off;
set(gca, 'FontSize', 26 , 'LineWidth', 2, 'TickDir', 'out');
ylim([0,3])


colors = [
    104, 158, 72;  % 蓝色 - 条件A
    167, 118, 197   % 红色 - 条件B
]./255;
electrode_type1 = length(signIdx.p005);
electrode_type2 = length(nonsignIdx.p005);
labels = {'Significant','Non-significant'};
% 极简专业饼图
electrode_counts = [electrode_type1, electrode_type2]; % 两类电极的数量

% 创建图形
figure('Position', [100, 100, 500, 500], 'Color', 'white');
set(gca, 'FontName', 'Arial', 'FontSize', 12); % 使用Arial字体

% 绘制饼图
h = pie(electrode_counts);


for i = 1:length(electrode_counts)
    set(h(2*i-1), 'FaceColor', colors(i, :),'FaceAlpha',0.7);
    set(h(2*i-1), 'EdgeColor', 'white', 'LineWidth', 2); % 白色细边框
    set(h(2*i), 'FontWeight', 'bold', 'FontSize', 12);   % 标签加粗
end
axis equal
box off



