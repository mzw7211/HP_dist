clear;clc;
cd('E:\MSPaper\Data')
%% Basci Settings
load("Figure1\Hippo_RippleExample.mat")
%% Plot Example Wave
times = -2500:2:7150-2;
tidx = dsearchn(times',analysisTime');
plotRawdata = data(:,:,trialidx);
plotFilterdata = sdata(:,tidx,trialidx);
figure;
set(gcf,'Position',[558   490   874   165])
plot(analysisTime,plotRawdata,'k','LineWidth',2)
box off
axis off
xlim([250 4250])
xline(500:250:4000,'--')
save_plot_with_resolution_svg([pwd '\FinalFigure\'],'RippleRawSeries.svg',600)

plotcolor = [
    6, 115, 215;  
    235, 80, 93   
]./255;

Time1 = [250:2:500-2  750:2:1000-2  1250:2:1500-2  1750:2:2000-2  2250:2:2500-2  2750:2:3000-2  3250:2:3500-2  3750:2:4000-2];
Time2 = [500:2:750-2  1000:2:1250-2 1500:2:1750-2  2000:2:2250-2 2500:2:2750-2  3000:2:3250-2  3500:2:3750-2  4000:2:4250-2];

figure;
set(gcf,'Position',[-12         563        1924         347])
plot(analysisTime,plotFilterdata,'k','LineWidth',1)
xlim([250 4250])
box off
axis off
hold on
% yline(data_2std(trialidx),'Color',[150,120,180]./255,'LineStyle','-.','LineWidth', 2)
ridx = ripples_idx{1,trialidx};
for iri = 1:size(ridx,1)
    if ismember(analysisTime(ridx(iri,1)),Time1)
        plot(analysisTime(ridx(iri,1):ridx(iri,2)),plotFilterdata(ridx(iri,1):ridx(iri,2)),'Color',plotcolor(2,:),'LineWidth',2)
    elseif ismember(analysisTime(ridx(iri,1)),Time2)
        plot(analysisTime(ridx(iri,1):ridx(iri,2)),plotFilterdata(ridx(iri,1):ridx(iri,2)),'Color',plotcolor(1,:),'LineWidth',2)
    end
end
xline(500:250:4000,'--')
save_plot_with_resolution_svg([pwd '\FinalFigure\'],'RippleFilteredSeries.svg',600)
%%
clear;clc;
cd('E:\MSPaper\Data')
%% Basci Settings
load("Figure1\Hippo_RippleExamplePower.mat")

set(0, 'DefaultAxesFontName', 'Arial')
set(0, 'DefaultTextFontName', 'Arial')
set(0, 'DefaultAxesFontSize', 14)
set(0, 'DefaultTextFontSize', 10)
set(0, 'DefaultAxesLineWidth', 1.2)
set(0, 'DefaultFigureColor', 'w')

figure;
plot(time,avgRippleWave,'k','LineWidth',4)
set(gca,'linewidth',1,'tickdir','out','fontname','Arial','fontsize',24)
xlabel('Times (ms)')
ylabel('Amplitude (μV)')
axis square
xlim([-270 270])
ylim([-60 60])
box off
axis off


figure;
set(gcf,'Position',[769   137   544   740])
contourf(time,freq,RipplePower,40,'linecolor','none')
set(gca,'linewidth',2,'tickdir','out','fontname','Arial','fontsize',24,'YTick',[1,50,100,150])
xlabel('Times (ms)')
ylabel('Frequency (Hz)')
% axis square
box off

