clear;clc;
cd('E:\MSPaper\Data')
%% Plot Hippo % PFC
load("Figure2\Hippo_PAC.mat")
load("Figure2\whiteRed.mat")

crange = [0 6];ylimRange = [60,150]; 
figure;
set(gcf,'Position',[990    12   748   993])
t1 = tiledlayout(2,2,"TileSpacing","compact","Padding","compact");
xlabel(t1,'Frequency for Phase (Hz)','fontsize',26,'fontname','Arial')
ylabel(t1,'Frequency for Amplitude (Hz)','fontsize',26,'fontname','Arial')

nexttile
thisdata = allcomdlgrm_z_PS.Face.target;
contourf(LF_steps, HF_steps, squeeze(mean(thisdata,1))',100,'linecolor','none')
clim(crange)
title(['Face - Target'])
box off
set(gca,'tickdir','out','fontname','Arial','fontsize',26)
hold on;
tempa = squeeze(mean(thisdata,1));
ps = tempa>3.1;
threclusted = 3;
islands = bwconncomp(ps);
for i = 1:length(islands.PixelIdxList)
    if length(islands.PixelIdxList{i}) < threclusted
        ps(islands.PixelIdxList{i}) = 0;
    end
end
[B, L] = bwboundaries(ps', 'noholes'); % 注意转置以匹配坐标    
    for k = 1:length(B)
        boundary = B{k};
        x_coords = interp1(1:length(LF_steps), LF_steps, boundary(:,2));
        y_coords = interp1(1:length(HF_steps), HF_steps, boundary(:,1));
        plot(x_coords, y_coords, 'k', 'LineWidth', 2);
    end
ylim(ylimRange)
xlim([2 12])
% setPivot(0)

nexttile
thisdata = allcomdlgrm_z_PS.Scene.target;
contourf(LF_steps, HF_steps, squeeze(mean(thisdata,1))',100,'linecolor','none')
clim(crange)
title(['Scene - Target'])
box off
set(gca,'tickdir','out','fontname','Arial','fontsize',26)
hold on;
tempa = squeeze(mean(thisdata,1));
ps = tempa>3.1;
threclusted = 3;
islands = bwconncomp(ps);
for i = 1:length(islands.PixelIdxList)
    if length(islands.PixelIdxList{i}) < threclusted
        ps(islands.PixelIdxList{i}) = 0;
    end
end
[B, L] = bwboundaries(ps', 'noholes'); % 注意转置以匹配坐标    
    for k = 1:length(B)
        boundary = B{k};
        x_coords = interp1(1:length(LF_steps), LF_steps, boundary(:,2));
        y_coords = interp1(1:length(HF_steps), HF_steps, boundary(:,1));
        plot(x_coords, y_coords, 'k', 'LineWidth', 2);
    end
ylim(ylimRange)
xlim([2 12])
% setPivot(0)

nexttile
thisdata1 = allcomdlgrm_z_PS.Face.distractor;
contourf(LF_steps, HF_steps, squeeze(mean(thisdata1,1))',100,'linecolor','none')
clim(crange)
title(['Face - Distractor'])
box off
set(gca,'tickdir','out','fontname','Arial','fontsize',26)
hold on;
tempa = squeeze(mean(thisdata,1));
ps = tempa>3.1;
threclusted = 3;
islands = bwconncomp(ps);
for i = 1:length(islands.PixelIdxList)
    if length(islands.PixelIdxList{i}) < threclusted
        ps(islands.PixelIdxList{i}) = 0;
    end
end
[B, L] = bwboundaries(ps', 'noholes'); % 注意转置以匹配坐标    
    for k = 1:length(B)
        boundary = B{k};
        x_coords = interp1(1:length(LF_steps), LF_steps, boundary(:,2));
        y_coords = interp1(1:length(HF_steps), HF_steps, boundary(:,1));
        plot(x_coords, y_coords, 'k', 'LineWidth', 2);
    end
ylim(ylimRange)
xlim([2 12])
% setPivot(0)

nexttile
thisdata = allcomdlgrm_z_PS.Scene.distractor;
contourf(LF_steps, HF_steps, squeeze(mean(thisdata,1))',100,'linecolor','none')
clim(crange)
title(['Scene - Distractor'])
box off
set(gca,'tickdir','out','fontname','Arial','fontsize',26)
hold on;
tempa = squeeze(mean(thisdata,1));
ps = tempa>3.1;
threclusted = 3;
islands = bwconncomp(ps);
for i = 1:length(islands.PixelIdxList)
    if length(islands.PixelIdxList{i}) < threclusted
        ps(islands.PixelIdxList{i}) = 0;
    end
end
[B, L] = bwboundaries(ps', 'noholes'); % 注意转置以匹配坐标    
    for k = 1:length(B)
        boundary = B{k};
        x_coords = interp1(1:length(LF_steps), LF_steps, boundary(:,2));
        y_coords = interp1(1:length(HF_steps), HF_steps, boundary(:,1));
        plot(x_coords, y_coords, 'k', 'LineWidth', 2);
    end
ylim(ylimRange)
xlim([2 12])
% setPivot(0)
colormap(flipud(nmap))
% setPivot(0)
c = colorbar;
c.Layout.Tile = 'east';
%% Plot Diff
crange = [-1 1];
ylimRange = [60,150];
figure;
set(gcf,'Position',[1191          68         840   878])
t1 = tiledlayout(1,2,"TileSpacing","compact","Padding","compact");
% title(t1,thisregionName,'fontsize',16,'fontname','Arial')
xlabel(t1,'Frequency for phase (Hz)','fontsize',26,'fontname','Arial')
ylabel(t1,'Frequency for amplitude (Hz)','fontsize',26,'fontname','Arial')

nexttile
permutedDiffs = [];maxclusted = [];
A = allcomdlgrm_z_PS.Face.target;
B = allcomdlgrm_z_PS.Face.distractor;
thisdata = B - A;
contourf(LF_steps, HF_steps, squeeze(mean(thisdata,1))',100,'linecolor','none')
clim(crange);
colormap(flipud(mymap('RdBu')));
hold on;
nperm = 1000;
for iper = 1:nperm
    diffvalue = [];
  for isub = 1:size(thisdata,1)
      tempdata = reshape(squeeze(thisdata(isub,:,:)),1,[]);
      signrand = (randi([0, 1], 1, length(tempdata)) * 2 - 1);
      tempdata = tempdata .* signrand;
      tempdata = reshape(tempdata,size(squeeze(thisdata(1,:,:))));
      diffvalue(isub,:,:) = tempdata - 0;
  end
  permutedDiffs(iper,:,:) = squeeze(mean(diffvalue,1));
end
tempDiffs = thisdata - 0;
trueDiffs = squeeze(mean(tempDiffs,1));
zdiff = ( trueDiffs - squeeze(mean(permutedDiffs,1)) ) ./ squeeze(std(permutedDiffs,[],1));
ps = abs(zdiff) > 1.96;
for iperm = 1:nperm
    zdiff = squeeze(( permutedDiffs(iperm,:,:) - mean(permutedDiffs,1) ) ./ std(permutedDiffs,[],1));
    zps = abs(zdiff) > 1.96;
    islands = bwconncomp(zps);
    if ~isempty(islands.PixelIdxList)
        maxclusted(iperm) = max(cellfun(@(x) length(x),islands.PixelIdxList));
    else
        maxclusted(iperm) = 0;
    end
end
threclusted = prctile(maxclusted,95);
islands = bwconncomp(ps);
for i = 1:length(islands.PixelIdxList)
    if length(islands.PixelIdxList{i}) < threclusted
        ps(islands.PixelIdxList{i}) = 0;
    end
end
[X1,Y1] = meshgrid(LF_steps,HF_steps);
contour(X1,Y1,ps',1,'k+','linewidth',2);
title(['Face' newline 'Distractor - Target'])
box off
set(gca,'tickdir','out','fontname','Arial','fontsize',26)
ylim(ylimRange)
xlim([2 12])


nexttile
permutedDiffs = [];maxclusted = [];
A = allcomdlgrm_z_PS.Scene.target;
B = allcomdlgrm_z_PS.Scene.distractor;
thisdata = B - A;
contourf(LF_steps, HF_steps, squeeze(mean(thisdata,1))',100,'linecolor','none')
clim(crange);
xlim([2 12])
colormap(flipud(mymap('RdBu')));

hold on;
nperm = 1000;
for iper = 1:nperm
    diffvalue = [];
  for isub = 1:size(thisdata,1)
      tempdata = reshape(squeeze(thisdata(isub,:,:)),1,[]);
      signrand = (randi([0, 1], 1, length(tempdata)) * 2 - 1);
      tempdata = tempdata .* signrand;
      tempdata = reshape(tempdata,size(squeeze(thisdata(1,:,:))));
      diffvalue(isub,:,:) = tempdata - 0;
  end
  permutedDiffs(iper,:,:) = squeeze(mean(diffvalue,1));
end
tempDiffs = thisdata - 0;
trueDiffs = squeeze(mean(tempDiffs,1));
zdiff = ( trueDiffs - squeeze(mean(permutedDiffs,1)) ) ./ squeeze(std(permutedDiffs,[],1));
ps = abs(zdiff) > 1.96;
for iperm = 1:nperm
    zdiff = squeeze(( permutedDiffs(iperm,:,:) - mean(permutedDiffs,1) ) ./ std(permutedDiffs,[],1));
    zps = abs(zdiff) > 1.96;
    islands = bwconncomp(zps);
    if ~isempty(islands.PixelIdxList)
        maxclusted(iperm) = max(cellfun(@(x) length(x),islands.PixelIdxList));
    else
        maxclusted(iperm) = 0;
    end
end
threclusted = prctile(maxclusted,95);
islands = bwconncomp(ps);
for i = 1:length(islands.PixelIdxList)
    if length(islands.PixelIdxList{i}) < threclusted
        ps(islands.PixelIdxList{i}) = 0;
    end
end
[X1,Y1] = meshgrid(LF_steps,HF_steps);
contour(X1,Y1,ps',1,'k+','linewidth',2);
title(['Scene' newline 'Distractor - Target'])
box off
set(gca,'tickdir','out','fontname','Arial','fontsize',26)
ylim(ylimRange)
c = colorbar;
c.Layout.Tile = 'east';
c.Ticks = [-1,-0.5,0,0.5,1];

