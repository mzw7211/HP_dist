clear;clc;close
%% Basic Settings
fileName = dir(['F:\MSData\CleanedData\DataEpoched_New\']);fileName(1:2) = [];
baselineRange = [-500,-100];
cname = {'f','s'};cName = {'Face','Scene'};
seqName = {'TD','DT'};
load('E:\\MS_SEEG\trialSequence.mat')
load('eleInfo.mat');elesubName = fieldnames(eleInfo);
load('regionInfo.mat');regionName = fieldnames(region);
sname = {'FS','SF'};
load('delBadChannels_set.mat')
%% 
d = 1;
[z_scores,snr] = deal([]);
ccc = 1;
for isub = 1:length(elesubName)
    subName = elesubName{isub};
    fprintf('\r%s Loading...\n',subName)
    subnumbers = str2double(regexp(subName, '\d+', 'match'));
    allDat = [];
    for icond = 1:length(cname)
        EEGFile = dir(['F:\MSData\CleanedData\DataEpoched_New\' subName filesep cname{icond} '\*.set']);
        EEG = pop_loadset([EEGFile(1).folder filesep EEGFile(1).name]);
        EEG.times = -2500:2:7150-1;
        baseidx = dsearchn(EEG.times',baselineRange');
        EEG.data = double(EEG.data);
        baseline_mean = mean(EEG.data(:, baseidx(1):baseidx(2), :), 2);    
        baseline_mean = repmat(baseline_mean, [1, size(EEG.data, 2), 1]);    
        newdata = EEG.data - baseline_mean;
        EEG.data = newdata;
        chanName = {EEG.chanlocs.labels}';
        tidx = dsearchn(EEG.times',[250 4250]');
        if icond == 1
            allDat = EEG.data;
        else
            allDat = cat(3,allDat,EEG.data);
        end
    end
    for iregion = 1%:length(regionName)
        thisregionName = regionName{iregion};
        subregion = region.(thisregionName);
        for isubregion = 1:length(subregion)
            subregionName = subregion{isubregion};
            if isfield(eleInfo.(subName),subregionName)
                eleidx = get_eleIdx(eleInfo.(subName).(subregionName),chanName);
                data = [];
                if ~isempty(eleidx)
                    for ichan = 1:length(eleidx)
                        idx = eleidx(ichan);
                        data = squeeze(allDat(idx,tidx(1):tidx(2)-1,:));
                        nfft = size(data,1);
                        hz = linspace(0,EEG.srate/2,floor(nfft/2)+1);
                        data1 = mean(data,2);
                        chanpowr = 2*abs(fft(data1,nfft,1)/size(data1,1));
                        chanpowr = chanpowr(1:length(hz));
                        z_scores(ccc,:) = compute_zscore_fft(chanpowr);
                        snr(ccc,:) = compute_snr_fft(chanpowr);
                        ccc = ccc+1;
                    end
                end
            end
        end
    end
end
save('E:\MSPaper\Data\Figure1\Hippo_SNR.mat','z_scores','snr','hz')