clear;clc;
cd('E:\MSPaper\Data')
%% Plot TF
load("FigureS1\Hippo_TF.mat")
load('Figure1\Hippo_SNR_P.mat')
figure;
set(gcf,'Position',[449         256        1284         551])
t1 = tiledlayout(1,1,"TileSpacing","compact","Padding","compact");
xlabel(t1,'Time (ms)','fontsize',30)
ylabel(t1,'Frequency (Hz)','fontsize',30)
nexttile
thisChan = signIdx.p005;  
contourf(NewTime,freq,squeeze(mean(tfPower(thisChan,:,:),1)),100,'linecolor','none')
xline([250 4250 4750],'--');
colormap(flipud(mymap('RdBu')));
xticks([0,250,4250,4750])
set(gca,'TickDir','out','XTickLabel',{'F','E','D','R'},'fontsize',30)
box off
set(gca,'TickDir','out')
clim([-5 5])


figure;
set(gcf,'Position',[449         256        1284         551])
t1 = tiledlayout(1,1,"TileSpacing","compact","Padding","compact");
xlabel(t1,'Time (ms)','fontsize',30)
ylabel(t1,'Frequency (Hz)','fontsize',30)
nexttile
thisChan = nonsignIdx.p005;  
contourf(NewTime,freq,squeeze(mean(tfPower(thisChan,:,:),1)),100,'linecolor','none')
xline([250 4250 4750],'--');
colormap(flipud(mymap('RdBu')));
xticks([0,250,4250,4750])
set(gca,'TickDir','out','XTickLabel',{'F','E','D','R'},'fontsize',30)
box off
set(gca,'TickDir','out')
clim([-5 5])