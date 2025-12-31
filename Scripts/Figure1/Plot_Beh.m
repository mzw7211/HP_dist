clear;clc;
cd('E:\MSPaper\Data')
%% load Dat
load('BehDat.mat')
cName = {'Face','Scene'};
subName = fieldnames(RT);tempRT = [];
for isub = 1:length(subName)
    for icond = 1:length(cName)
        tempRT(isub,icond) = RT.(subName{isub}).(cName{icond}).correct;
    end
end

subName = fieldnames(ACC);tempacc = [];
for isub = 1:length(subName)
    for icond = 1:length(cName)
        tempacc(isub,icond) = ACC.(subName{isub}).(cName{icond});
    end
end
%% Plot RT
[h,p_RT,ci,stats] = ttest(tempRT(:,1),tempRT(:,2));
[h,p_ACC,ci,stats] = ttest(tempacc(:,1),tempacc(:,2));
nSubjects = size(tempRT,1);
RT_A = tempRT(:,1);
RT_B = tempRT(:,2);

set(0, 'DefaultAxesFontName', 'Arial')
set(0, 'DefaultTextFontName', 'Arial')
set(0, 'DefaultAxesFontSize', 14)
set(0, 'DefaultTextFontSize', 10)
set(0, 'DefaultAxesLineWidth', 1.2)
set(0, 'DefaultFigureColor', 'w')


meanRT = [mean(RT_A), mean(RT_B)];
stdRT = [std(RT_A), std(RT_B)] ./ sqrt(nSubjects-1);
figure('Position', [404   152   524   707], 'Color', 'w')
pcolor = [39,168,197;249,141,55]./255;
hBar = bar(1:2, meanRT, 0.6, 'EdgeColor', 'none', 'FaceColor', 'flat');
hBar.CData = pcolor;
hold on
errorbar(1:2, meanRT, stdRT, 'k.', 'LineWidth', 1.5, 'CapSize', 15)
scatter(ones(nSubjects,1)*1 + randn(nSubjects,1)*0.05, RT_A,...
        40, 'MarkerFaceColor', [0.7, 0.7, 0.9], 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.7)
scatter(ones(nSubjects,1)*2 + randn(nSubjects,1)*0.05, RT_B,...
        40, 'MarkerFaceColor', [0.9, 0.7, 0.7], 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.7)
set(gca, 'XTick', 1:2, 'XTickLabel', cName, 'Box', 'off','fontsize',26)
ylabel('RT (ms)', 'FontSize', 26)
set(gca, 'TickDir', 'out', 'LineWidth', 2)

save_plot_with_resolution_svg([pwd '\Figure\'], 'RT.svg', 600)
%% Plot Acc
nSubjects = size(tempacc,1);
RT_A = tempacc(:,1);
RT_B = tempacc(:,2);

set(0, 'DefaultAxesFontName', 'Arial')
set(0, 'DefaultTextFontName', 'Arial')
set(0, 'DefaultAxesFontSize', 14)
set(0, 'DefaultTextFontSize', 10)
set(0, 'DefaultAxesLineWidth', 1.2)
set(0, 'DefaultFigureColor', 'w')


meanRT = [mean(RT_A), mean(RT_B)];
stdRT = [std(RT_A), std(RT_B)] ./ sqrt(nSubjects-1);
figure('Position', [404   152   524   707], 'Color', 'w')
pcolor = [39,168,197;249,141,55]./255;
hBar = bar(1:2, meanRT, 0.6, 'EdgeColor', 'none', 'FaceColor', 'flat');
hBar.CData = pcolor;
hold on
errorbar(1:2, meanRT, stdRT, 'k.', 'LineWidth', 1.5, 'CapSize', 15)
scatter(ones(nSubjects,1)*1 + randn(nSubjects,1)*0.05, RT_A,...
        40, 'MarkerFaceColor', [0.7, 0.7, 0.9], 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.7)
scatter(ones(nSubjects,1)*2 + randn(nSubjects,1)*0.05, RT_B,...
        40, 'MarkerFaceColor', [0.9, 0.7, 0.7], 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.7)
set(gca, 'XTick', 1:2, 'XTickLabel', cName, 'Box', 'off','fontsize',26)
ylabel('Acc (%)', 'FontSize', 26)
set(gca, 'TickDir', 'out', 'LineWidth', 2)
ylim([65 100])

save_plot_with_resolution_svg([pwd '\Figure\'], 'ACC.svg', 600)