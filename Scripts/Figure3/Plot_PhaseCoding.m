clear;clc;
cd('E:\MSPaper\Data')
%% Basic Settings
ccname = {'Face','Scene'};
cName = {'Face','Scene'};
plotcolor = [
    6, 115, 215;  % 蓝色 - 条件A
    235, 80, 93   % 红色 - 条件B
]./255;
thisregionName = 'Hippocampus';
typeName = {'target','distractor'};
n_surrogates = 1000;
ttypeName = {'Target','Distractor'};
%% Plot
load('Figure3\Hippo_nonentrained_PhaseDiff_face.mat')
for icond = 1
    for itype = 1:2
        for ibin = 1:8
            realPhases = squeeze(maxPreferPhase.(thisregionName).(cName{icond}).(typeName{itype})(ibin,:));
            surrogatePhases = squeeze(maxPreferPhase.(thisregionName).(cName{icond}).([typeName{itype} '_surr'])(ibin,:,:));
            
            if max(realPhases) > pi*2
                realPhases = deg2rad(realPhases);
                surrogatePhases = deg2rad(surrogatePhases);
            end
            
            nChannels = size(realPhases, 2);
            pValues = zeros(nChannels, 1);
    
            for ch = 1:nChannels
                realPhase = realPhases(ch);
                chSurrogate = squeeze(surrogatePhases(ch, :));
                
                medianSurrogate = circ_median(chSurrogate,2);
                
                realDist = circ_dist(chSurrogate, realPhase);
                 
                nullDist = circ_dist(chSurrogate, medianSurrogate);
                
                [~, p_kstest] = kstest2(realDist, nullDist);
                pValues(ch) = p_kstest;
            
            end
            
            adjP = mafdr(pValues,'BHFDR',true);
            isSignificant = adjP < 0.05;
            
            sigChannels = find(isSignificant);
            maxPhaseSignChannels.(thisregionName).(cName{icond}).(typeName{itype}){ibin} = sigChannels;
        end
    end
end

set(0, 'DefaultAxesFontName', 'Arial')
set(0, 'DefaultTextFontName', 'Arial')
set(0, 'DefaultAxesFontSize', 14)
set(0, 'DefaultTextFontSize', 10)
set(0, 'DefaultAxesLineWidth', 1.2)
set(0, 'DefaultFigureColor', 'w')

colorFunc=colorFuncFactory([122, 199, 226;255,255,255;227, 113, 110]./255);
newcolor = colorFunc(linspace(-1,1,17));

for icond = 1
    figure;
    set(gcf,'Position',[0         0        1920         1080])
    t1 = tiledlayout(3,8,"TileSpacing","compact","Padding","compact");
    pData = [];
    for itype = 1:2
        for ibin = 1:8
            nexttile
            signChannels = maxPhaseSignChannels.(thisregionName).(ccname{icond}).(typeName{itype}){ibin};
            plotDat = maxPreferPhase.(thisregionName).(ccname{icond}).(typeName{itype})(ibin,signChannels);
            h1 = polarhistogram(plotDat, 12, 'FaceColor', plotcolor(itype,:), 'EdgeColor', 'none');
            % if itype == 1
            %     h1 = polarhistogram(plotDat, 12, 'FaceColor', newcolor(9-ibin,:), 'EdgeColor', 'none');
            % else
            %     h1 = polarhistogram(plotDat, 12, 'FaceColor', newcolor(ibin+9,:), 'EdgeColor', 'none');
            % end
            set(gca,'RTick',[])
            set(gca,'ThetaTick',[0,90,180,270],'ThetaTicklabel',{'0','π/2','π','3π/2'},'fontname','Arial','fontsize',22)
            % set(gca,"FontName",'Arial','FontSize',10)
            hold on
            meanPhase_target = circ_mean(plotDat,[],2);
            pData(itype,ibin) = (circ_mean(plotDat,[],2));
            
            maxR = max(h1.BinCounts);
            polarplot([meanPhase_target, meanPhase_target], [0, maxR], 'k-', 'LineWidth', 4)
            % title([ttypeName{itype}  newline num2str(round(rad2deg(meanPhase_target))) '°'],'fontname','Arial','fontsize',14)
            % title([num2str(round(rad2deg(meanPhase_target))) '°'],'fontname','Arial','fontsize',14)
            set(gca, 'ThetaAxisUnits', 'degrees') 

            for iperm = 1:n_surrogates
                surrogatePhases = squeeze(maxPreferPhase.(thisregionName).(ccname{icond}).([typeName{itype} '_surr'])(ibin,signChannels,iperm));
                pData_s(itype,ibin,iperm) = (circ_mean(surrogatePhases,[],2));
            end
        end
    end

    nexttile([1 8])
    thisp = circ_dist(pData(1,:),pData(2,:));
    plot(1:8,abs(thisp),'Color',[150,120,180]./255,'LineWidth',4)
    p = polyfit(1:8, abs(thisp), 1);
    x = 1:8;
    x_fit = linspace(min(x), max(x), 100);
    
    y_fit = polyval(p, x_fit);
    hold on
    plot(x_fit, y_fit, 'k--', 'LineWidth', 2);

    mdl = fitlm(x, abs(thisp));
    
    p_value = mdl.Coefficients{'x1', 'pValue'};

    xlabel('Encoding Times (ms)','fontname','Arial','fontsize',24)
    ylabel('Phase Diff (abs)','fontname','Arial','fontsize',24)
    box off
    

    set(gca,'tickdir','out','xtick',[1:8],'xticklabel',{'0~500','500~1000','1000~1500','1500~2000',...
        '2000~2500','2500~3000','3000~3500','3500~4000',},'fontname','Arial','fontsize',24,'LineWidth',2)
    set(gca,'TickLength',[0.003,0.003])
    xlim([0.7 8.3])
    hold on
    ylim([0 3.5])
  

    for ibin = 1:8
        phasediff_s(ibin,:) = circ_dist(squeeze(pData_s(1,ibin,:)),squeeze(pData_s(2,ibin,:)));
    end

    for ibin = 1:8
        p_right = sum(phasediff_s(ibin,:) >= thisp(ibin)) / 1000;
        p_left  = sum(phasediff_s(ibin,:) <= thisp(ibin)) / 1000;
        p_twosided = min(1, 2 * min(p_left, p_right));
        is_significant(ibin) = (p_twosided <= 0.05); 
        pvalue(ibin) = p_twosided; 
    end

    pfix = mafdr(pvalue,'BHFDR',true);
    for ibin = 1:8
        if pfix(ibin) <= 0.05
           text(ibin, 3.3, '*', 'FontSize', 32, 'HorizontalAlignment', 'center');
        end
    end
end