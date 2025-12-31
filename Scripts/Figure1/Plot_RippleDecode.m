clear;clc;
cd('E:\MSPaper\Data')
set(0, 'DefaultAxesFontName', 'Arial')
set(0, 'DefaultTextFontName', 'Arial')
set(0, 'DefaultAxesFontSize', 14)
set(0, 'DefaultTextFontSize', 10)
set(0, 'DefaultAxesLineWidth', 1.2)
set(0, 'DefaultFigureColor', 'w')
plotcolor = [
    6, 115, 215;  % 蓝色 - 条件A
    235, 80, 93   % 红色 - 条件B
]./255;
%% Plot Hippo
load('Figure1\Hippo_DecodeDat.mat')
sname = {{'FT','FD'},{'ST','SD'}};
figure('Position', [418    85   842   789], 'Color', 'w');
t1 = tiledlayout(2,1,"TileSpacing","compact","Padding","compact");
xlabel(t1,'Ripple Times (ms)','FontSize',26,'FontName','Arial')
ylabel(t1,'Decoding Acc (%)','FontSize',26,'FontName','Arial')
cname = {'Face','Scene'};
for j = 1:2
    nexttile;hold on
    for k = 1:2
        trueAcc = acc.(sname{j}{k});
        falseAcc = accperm.(sname{j}{k});
        if k == 1
            A = trueAcc;APerm = falseAcc;
        else
            B = trueAcc;BPerm = falseAcc;
        end
        nperm = size(falseAcc,2);
        zvalue = nan(length(time));
        zvalue = (trueAcc - mean(falseAcc,2)) ./ (std(falseAcc,[],2));
        pvalue = zvalue > 1.645;
    
        for iperm = 1:nperm
            temp = (falseAcc(:,iperm) - mean(falseAcc,2)) ./ (std(falseAcc,[],2));
            pvaluetemp = temp > 1.645;
            islands_false = bwconncomp(pvaluetemp);
            a = max(cellfun(@length,islands_false.PixelIdxList));
            if ~isempty(a)
                maxcluster(iperm) = a;
            else
                maxcluster(iperm) = 0;
            end
        end
        
        clusterThre = prctile(maxcluster,95);
    
        islands = bwconncomp(pvalue);
        for icluster = 1:islands.NumObjects
            if length(islands.PixelIdxList{icluster}) < clusterThre
                pvalue(islands.PixelIdxList{icluster}) = 0;
            end
        end
        if k == 1
            p(k) = plot(time,smooth_1d(trueAcc',10),'color',plotcolor(1,:),'LineWidth',6);
            scatter(time(pvalue),0.86,20,plotcolor(1,:),'filled')
            fill([time, fliplr(time)], [smooth_1d(trueAcc',10)+accstd.(sname{j}{k}),fliplr(smooth_1d(trueAcc',10) - accstd.(sname{j}{k}))], plotcolor(1,:),'EdgeColor', 'none','FaceAlpha', 0.3);
            sig_clusters_target = struct();
            if ~isempty(find(pvalue==1))
                [cluster_start, cluster_end] = find_cluster_boundaries(logical(pvalue), time);                
                for i = 1:length(cluster_start)
                    sig_clusters_target(i).id = i;
                    sig_clusters_target(i).start_ms = cluster_start(i);
                    sig_clusters_target(i).end_ms = cluster_end(i);
                    sig_clusters_target(i).duration_ms = cluster_end(i) - cluster_start(i);
                end           
            end

        else
            p(k) = plot(time,smooth_1d(trueAcc',10),'color',plotcolor(2,:),'LineWidth',6);
            scatter(time(pvalue),0.85,20,plotcolor(2,:),'filled')
            fill([time, fliplr(time)], [smooth_1d(trueAcc',10)+accstd.(sname{j}{k}),fliplr(smooth_1d(trueAcc',10) - accstd.(sname{j}{k}))], plotcolor(2,:),'EdgeColor', 'none','FaceAlpha', 0.3);
            
            sig_clusters_dis = struct();
            if ~isempty(find(pvalue==1))
                [cluster_start, cluster_end] = find_cluster_boundaries(logical(pvalue), time);                
                for i = 1:length(cluster_start)
                    sig_clusters_dis(i).id = i;
                    sig_clusters_dis(i).start_ms = cluster_start(i);
                    sig_clusters_dis(i).end_ms = cluster_end(i);
                    sig_clusters_dis(i).duration_ms = cluster_end(i) - cluster_start(i);
                end           
            end

        end
    end
    
    
    set(gca,'linewidth',2,'tickdir','out','fontname','Arial','fontsize',26)
    xline(0,'--','LineWidth',2)
    yline(0.5,'--','LineWidth',2)
    xlim([-270 270])
    ylim([0.3 0.9])
    set(gca,'ytick',[0.3,0.5,0.7,0.9])

    sign.(cname{j}).tar = sig_clusters_target;
    sign.(cname{j}).dis = sig_clusters_dis;
end
cb = legend(p,{'Target','Distractor'},'FontName','Arial','EdgeColor','none','Color','none','FontSize',24);
cb.Layout.Tile = 'north';
cb.Orientation = 'horizontal';
%% Plot PFC
load('Figure1\PFC_DecodeDat.mat')
sname = {{'FT','FD'},{'ST','SD'}};
figure('Position', [418    85   842   789], 'Color', 'w');
t1 = tiledlayout(2,1,"TileSpacing","compact","Padding","compact");
xlabel(t1,'Ripple Times (ms)','FontSize',26,'FontName','Arial')
ylabel(t1,'Decoding Acc (%)','FontSize',26,'FontName','Arial')
cname = {'Face','Scene'};
for j = 1:2
    nexttile;hold on
    for k = 1:2
        trueAcc = acc.(sname{j}{k});
        falseAcc = accperm.(sname{j}{k});
        if k == 1
            A = trueAcc;APerm = falseAcc;
        else
            B = trueAcc;BPerm = falseAcc;
        end
        nperm = size(falseAcc,2);
        zvalue = nan(length(time));
        zvalue = (trueAcc - mean(falseAcc,2)) ./ (std(falseAcc,[],2));
        pvalue = zvalue > 1.645;
    
        for iperm = 1:nperm
            temp = (falseAcc(:,iperm) - mean(falseAcc,2)) ./ (std(falseAcc,[],2));
            pvaluetemp = temp > 1.645;
            islands_false = bwconncomp(pvaluetemp);
            a = max(cellfun(@length,islands_false.PixelIdxList));
            if ~isempty(a)
                maxcluster(iperm) = a;
            else
                maxcluster(iperm) = 0;
            end
        end
        
        clusterThre = prctile(maxcluster,95);
    
        islands = bwconncomp(pvalue);
        for icluster = 1:islands.NumObjects
            if length(islands.PixelIdxList{icluster}) < clusterThre
                pvalue(islands.PixelIdxList{icluster}) = 0;
            end
        end
        if k == 1
            p(k) = plot(time,smooth_1d(trueAcc',10),'color',plotcolor(1,:),'LineWidth',6);
            scatter(time(pvalue),0.86,20,plotcolor(1,:),'filled')
            fill([time, fliplr(time)], [smooth_1d(trueAcc',10)+accstd.(sname{j}{k}),fliplr(smooth_1d(trueAcc',10) - accstd.(sname{j}{k}))], plotcolor(1,:),'EdgeColor', 'none','FaceAlpha', 0.3);
            sig_clusters_target = struct();
            if ~isempty(find(pvalue==1))
                [cluster_start, cluster_end] = find_cluster_boundaries(logical(pvalue), time);                
                for i = 1:length(cluster_start)
                    sig_clusters_target(i).id = i;
                    sig_clusters_target(i).start_ms = cluster_start(i);
                    sig_clusters_target(i).end_ms = cluster_end(i);
                    sig_clusters_target(i).duration_ms = cluster_end(i) - cluster_start(i);
                end           
            end

        else
            p(k) = plot(time,smooth_1d(trueAcc',10),'color',plotcolor(2,:),'LineWidth',6);
            scatter(time(pvalue),0.85,20,plotcolor(2,:),'filled')
            fill([time, fliplr(time)], [smooth_1d(trueAcc',10)+accstd.(sname{j}{k}),fliplr(smooth_1d(trueAcc',10) - accstd.(sname{j}{k}))], plotcolor(2,:),'EdgeColor', 'none','FaceAlpha', 0.3);
            
            sig_clusters_dis = struct();
            if ~isempty(find(pvalue==1))
                [cluster_start, cluster_end] = find_cluster_boundaries(logical(pvalue), time);                
                for i = 1:length(cluster_start)
                    sig_clusters_dis(i).id = i;
                    sig_clusters_dis(i).start_ms = cluster_start(i);
                    sig_clusters_dis(i).end_ms = cluster_end(i);
                    sig_clusters_dis(i).duration_ms = cluster_end(i) - cluster_start(i);
                end           
            end

        end
    end
    
    
    set(gca,'linewidth',2,'tickdir','out','fontname','Arial','fontsize',26)
    xline(0,'--','LineWidth',2)
    yline(0.5,'--','LineWidth',2)
    xlim([-270 270])
    ylim([0.3 0.9])
    set(gca,'ytick',[0.3,0.5,0.7,0.9])

    sign.(cname{j}).tar = sig_clusters_target;
    sign.(cname{j}).dis = sig_clusters_dis;
end
cb = legend(p,{'Target','Distractor'},'FontName','Arial','EdgeColor','none','Color','none','FontSize',24);
cb.Layout.Tile = 'north';
cb.Orientation = 'horizontal';



