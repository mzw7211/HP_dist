clear;clc;
cd('E:\MSPaper\Data')
%% Plot Hippo
load("Figure1\Hippo_RippleRate.mat")
colors = [
    122, 199, 226;  % 蓝色 - 条件A
    227, 113, 110   % 红色 - 条件B
]./255;

cName = {'Face','Scene'};
figure('Position', [874    45   931   901], 'Color', 'w');
t1 = tiledlayout(1,2,"TileSpacing","compact","Padding","compact");
ylabel(t1,'Ripple Rate (Hz)','fontname','Arial','fontsize',26);

for icond = 1:length(cName)
    A = RippleRate.(cName{icond}).Tar;
    B = RippleRate.(cName{icond}).Dis;

    [h,p,ci,stats] = ttest(A,B);
    nexttile
    hold on;
    box off;
    memoryLoad = [1, 2];
    for i = 1:length(A)
        plot(1:2, [A(i), B(i)], ...
            'Color', [0.7 0.7 0.7], 'LineWidth', 0.8); % 浅灰连线   
    end
    
    scatter(repmat(memoryLoad(1), length(A), 1), A, ...
            70, 'filled', 'MarkerFaceColor', colors(1,:),'MarkerEdgeColor','none'); % 粉色
    scatter(repmat(memoryLoad(2), length(B), 1), B, ...
            70, 'filled', 'MarkerFaceColor', colors(2,:),'MarkerEdgeColor','none'); % 粉色
    
    xlim([0.5 2.5]);
    xticks(memoryLoad);
    set(gca, 'FontSize', 26, 'LineWidth', 2, 'TickDir', 'out','xticklabel',{'Target','Distractor'},'fontname','Arial');
    title([cName{icond}],'fontsize',26)
    set(gca,'ytick',[0,0.01,0.02,0.03,0.04,0.05],'yticklabel',[0,0.01,0.02,0.03,0.04,0.05])

        
    hold on
    plot(memoryLoad, [0.05 0.05], 'k-', 'LineWidth', 1.5); % 横线
    if p<= 0.05 && p>0.01
        text(1.5, 0.05015, '*', 'FontSize', 24, 'HorizontalAlignment', 'center'); % 星号
    elseif p<= 0.01 && p> 0.001
        text(1.5, 0.0211, '**', 'FontSize', 24, 'HorizontalAlignment', 'center'); % 星号
    elseif p<=0.001
        text(1.5, 0.0211, '***', 'FontSize', 24, 'HorizontalAlignment', 'center'); % 星号
    else
        text(1.5, 0.0507, 'NS', 'FontSize', 14, 'HorizontalAlignment', 'center'); % 星号
    end
    plot([memoryLoad(1)-0.2 memoryLoad(1)+0.2],[mean(A) mean(A)],'k','LineWidth',4)
    plot([memoryLoad(2)-0.2 memoryLoad(2)+0.2],[mean(B) mean(B)],'k','LineWidth',4)
    ylim([0 0.052])
end
%% Plot PFC
load("Figure1\PFC_RippleRate.mat")
colors = [
    122, 199, 226;  % 蓝色 - 条件A
    227, 113, 110   % 红色 - 条件B
]./255;

cName = {'Face','Scene'};
figure('Position', [874    45   931   901], 'Color', 'w');
t1 = tiledlayout(1,2,"TileSpacing","compact","Padding","compact");
ylabel(t1,'Ripple Rate (Hz)','fontname','Arial','fontsize',26);

for icond = 1:length(cName)
    A = RippleRate.(cName{icond}).Tar;
    B = RippleRate.(cName{icond}).Dis;

    [h,p,ci,stats] = ttest(A,B);
    nexttile
    hold on;
    box off;
    memoryLoad = [1, 2];
    for i = 1:length(A)
        plot(1:2, [A(i), B(i)], ...
            'Color', [0.7 0.7 0.7], 'LineWidth', 0.8); % 浅灰连线   
    end
    
    scatter(repmat(memoryLoad(1), length(A), 1), A, ...
            70, 'filled', 'MarkerFaceColor', colors(1,:),'MarkerEdgeColor','none'); % 粉色
    scatter(repmat(memoryLoad(2), length(B), 1), B, ...
            70, 'filled', 'MarkerFaceColor', colors(2,:),'MarkerEdgeColor','none'); % 粉色
    
    xlim([0.5 2.5]);
    xticks(memoryLoad);
    set(gca, 'FontSize', 26, 'LineWidth', 2, 'TickDir', 'out','xticklabel',{'Target','Distractor'},'fontname','Arial');
    title([cName{icond}],'fontsize',26)
    set(gca,'ytick',[0,0.01,0.02,0.03,0.04,0.05],'yticklabel',[0,0.01,0.02,0.03,0.04,0.05])

        
    hold on
    plot(memoryLoad, [0.05 0.05], 'k-', 'LineWidth', 1.5); % 横线
    if p<= 0.05 && p>0.01
        text(1.5, 0.05015, '*', 'FontSize', 24, 'HorizontalAlignment', 'center'); % 星号
    elseif p<= 0.01 && p> 0.001
        text(1.5, 0.0211, '**', 'FontSize', 24, 'HorizontalAlignment', 'center'); % 星号
    elseif p<=0.001
        text(1.5, 0.0211, '***', 'FontSize', 24, 'HorizontalAlignment', 'center'); % 星号
    else
        text(1.5, 0.0507, 'NS', 'FontSize', 14, 'HorizontalAlignment', 'center'); % 星号
    end
    plot([memoryLoad(1)-0.2 memoryLoad(1)+0.2],[mean(A) mean(A)],'k','LineWidth',4)
    plot([memoryLoad(2)-0.2 memoryLoad(2)+0.2],[mean(B) mean(B)],'k','LineWidth',4)
    ylim([0 0.052])
end