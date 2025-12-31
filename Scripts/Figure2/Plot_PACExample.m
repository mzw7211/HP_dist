clear;clc;
cd('E:\MSPaper\Data')
%% Basci Settings
load("Figure2\PAC_Example.mat")

figure;
t1 = tiledlayout(1,1,"TileSpacing","compact","Padding","compact");
set(gcf,'Position',[181         356        1530         456])
nexttile
yyaxis left
plot(wave.gamma,'LineWidth',1.2,'Color','k')
yyaxis right
plot(wave.theta,'LineWidth',2,'Color','r')
axis off
cb = legend({'High Gamma Wave','4 Hz Wave'},'FontName','Arial','EdgeColor','none','Color','none','FontSize',24);
cb.Layout.Tile = 'north';
cb.Orientation = 'horizontal';


phase_degrees = rad2deg(hist.phase); % Phases in degrees
% Bining the phases
step_length = 360/18;
phase_bins = -180:step_length:180;
[~,phase_bins_ind] = histc(phase_degrees,phase_bins);
% clear phase_degrees

% Averaging amplitude time series over phase bins
amplitude_bins = nan(18,1);

for bin = 1:18
    amplitude_bins(bin,1) = mean(hist.amplitude(phase_bins_ind==bin));
end

figure;
set(gcf,'Position',[859   261   747   611])
bar(phase_bins(2:end),amplitude_bins,'k')
set(gca,'linewidth',2,'tickdir','out','fontname','Arial','fontsize',30)
set(gca,'xtick',[-120 -60 0 60 120 180])
box off
xlabel('4 Hz Phase angle (°)')
ylabel('High Gamma Power (μV)')