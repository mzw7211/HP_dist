clear;clc
cd('E:\MSPaper\Data')
%% 
set(0, 'DefaultAxesFontName', 'Arial')
set(0, 'DefaultTextFontName', 'Arial')
set(0, 'DefaultAxesFontSize', 14)
set(0, 'DefaultTextFontSize', 10)
set(0, 'DefaultAxesLineWidth', 1.2)
set(0, 'DefaultFigureColor', 'w')
data = readtable('FigureS3\Detail_MS_ChanPos.xlsx');

plotColor = [204 0 102;153 204 0]./255;

regionName = [];
for ichan = 1:86
    thisName = strsplit(data{ichan,"Location"}{1},'-');
    regionName{ichan} = thisName{1};
end

CA1_data = data(ismember(regionName,'CA1'),:);
signCA1 = size(CA1_data(CA1_data.IsSign==1,:),1);
NosignCA1 = size(CA1_data(CA1_data.IsSign==0,:),1);

CA3_data = data(ismember(regionName,'CA3'),:);
signCA3 = size(CA3_data(CA3_data.IsSign==1,:),1);
NosignCA3 = size(CA3_data(CA3_data.IsSign==0,:),1);

CA4_data = data(ismember(regionName,'CA4'),:);
signCA4 = size(CA4_data(CA4_data.IsSign==1,:),1);
NosignCA4 = size(CA4_data(CA4_data.IsSign==0,:),1);

% HP_data = data(ismember(regionName,'HP'),:);
figure
data = [
        signCA1, NosignCA1;  % CA1
        signCA3, NosignCA3;  % CA3
        signCA4, NosignCA4   % CA4
    ];
    
regions = {'CA1', 'CA3', 'CA4'};
electrode_types = {'Entrained', 'Non-entrained'};

% 创建图形
% 分组条形图
h = bar(data, 'grouped');
h(1).FaceColor = plotColor(1,:);
h(2).FaceColor = plotColor(2,:);
set(gca, 'XTickLabel', regions);
ylabel('Contacts Number');
% title('各区域电极数量分布（分组条形图）');
legend(electrode_types, 'Location', 'best');
grid off;

% 添加数值标签
for i = 1:length(h)
    x_data = h(i).XEndPoints;
    y_data = h(i).YEndPoints;
    text(x_data, y_data, string(y_data), ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
        'FontSize', 16, 'FontWeight', 'bold');
end
set(gca,'FontSize',20,'TickDir','out', 'LineWidth', 2);box off