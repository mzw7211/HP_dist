function allcomdlgrm_z = computePAC(cdata)
    rawTime = -2500:2:7150-1;
    Time1 = [250:2:500-2  750:2:1000-2  1250:2:1500-2  1750:2:2000-2  2250:2:2500-2  2750:2:3000-2  3250:2:3500-2  3750:2:4000-2];
    Time2 = [500:2:750-2  1000:2:1250-2 1500:2:1750-2  2000:2:2250-2 2500:2:2750-2  3000:2:3250-2  3500:2:3750-2  4000:2:4250-2];
    Time1idx = dsearchn(rawTime',Time1');Time2idx = dsearchn(rawTime',Time2');
    nChan = size(cdata.FS,1);
    for ichan = 1:nChan
        datMat_FS = squeeze(cdata.FS(ichan,:,:));
        datMat_SF = squeeze(cdata.SF(ichan,:,:));
        datMat = cat(2,datMat_FS,datMat_SF);
        dataLabel = [ones(size(datMat_FS,2),1);ones(size(datMat_SF,2),1)*2];
        %%
        % % datMat: samples x trials
        srate = 500; 
        n_surrogates = 1000;
        n_bins = 18;
        LF_steps = 2:2:12;
        LF_bw = 2;
        HF_steps = 60:5:150;
        %% initalize output matrix
        n_trials       = size(datMat,2);
        n_samples_long = size(datMat,1);
        n_HF = length(HF_steps);
        n_LF = length(LF_steps);

        comdlgrm_target = nan(n_LF,n_HF);
        comdlgrm_surr_mean_target = nan(n_LF,n_HF);
        comdlgrm_surr_std_target = nan(n_LF,n_HF);
        phase2power_target = nan(n_LF,n_HF,n_bins);

        comdlgrm_distractor = nan(n_LF,n_HF);
        comdlgrm_surr_mean_distractor = nan(n_LF,n_HF);
        comdlgrm_surr_std_distractor = nan(n_LF,n_HF);
        phase2power_distractor = nan(n_LF,n_HF,n_bins);

        pcomdlgrm_target = nan(n_LF,n_HF);
        pcomdlgrm_surr_mean_target = nan(n_LF,n_HF);
        pcomdlgrm_surr_std_target = nan(n_LF,n_HF);
        pphase2power_target = nan(n_LF,n_HF,n_bins);

        pcomdlgrm_distractor = nan(n_LF,n_HF);
        pcomdlgrm_surr_mean_distractor = nan(n_LF,n_HF);
        pcomdlgrm_surr_std_distractor = nan(n_LF,n_HF);
        pphase2power_distractor = nan(n_LF,n_HF,n_bins);
        %% Prepare filter input
        EEG = [];
        EEG.srate  = srate;
        EEG.pnts   = n_samples_long;
        EEG.trials = n_trials;
        EEG.nbchan = 1;
        EEG.data   = datMat;
        %% Loop through all frequency pairs
        for i_phase = 1:n_LF
            disp('Filtering and computing hilbert transform for phase signal...');
        
            % filter phase signal
            LF_bp = [LF_steps(i_phase)-LF_bw/2 LF_steps(i_phase)+LF_bw/2];
            EEG_p = pop_eegfiltnew(EEG,LF_bp(1),LF_bp(2));
            %% Hilbert
            phase_long = angle(hilbert(squeeze(EEG_p.data)));
            % clear EEG_p
            %% Cutting out time window of interest
            phase_target = reshape(cat(2,phase_long(Time1idx,dataLabel==1),phase_long(Time2idx,dataLabel==2)),[],1);
            phase_distractor = reshape(cat(2,phase_long(Time2idx,dataLabel==1),phase_long(Time1idx,dataLabel==2)),[],1);
            parfor i_amplitude = 1:n_HF
                fprintf('Computing PAC between %dHz amplitude and %dHz phase frequency...\n',HF_steps(i_amplitude),LF_steps(i_phase));
                
                HF_bp = [HF_steps(i_amplitude)-LF_steps(i_phase) HF_steps(i_amplitude)+LF_steps(i_phase)];
                EEG_A = pop_eegfiltnew(EEG,HF_bp(1),HF_bp(2));
                
                %% Hilbert
                amplitude_long = abs(hilbert(squeeze(EEG_A.data)));
                % clear EEG_A
                %% Cutting out time window of interest
                amplitude_target = reshape(cat(2,amplitude_long(Time1idx,dataLabel==1),amplitude_long(Time2idx,dataLabel==2)),[],1);
                amplitude_distractor = reshape(cat(2,amplitude_long(Time2idx,dataLabel==1),amplitude_long(Time1idx,dataLabel==2)),[],1);
                %% Code for calculating MI like Tort
        %% For Target
                phase_degrees = rad2deg(phase_target); % Phases in degrees
                % Bining the phases
                step_length = 360/n_bins;
                phase_bins = -180:step_length:180;
                [~,phase_bins_ind] = histc(phase_degrees,phase_bins);
                % clear phase_degrees
                
                % Averaging amplitude time series over phase bins
                amplitude_bins = nan(n_bins,1);
                
                for bin = 1:n_bins
                    amplitude_bins(bin,1) = mean(amplitude_target(phase_bins_ind==bin));
                end
                
                % Normalize amplitudes
                P = amplitude_bins./repmat(sum(amplitude_bins),n_bins,1);
                
                % Compute modulation index and store in comodulogram
                mi = 1+sum(P.*log(P))./log(n_bins);
                comdlgrm_target(i_phase,i_amplitude) = mi;
                phase2power_target(i_phase,i_amplitude,:) = P;
                
                % clear amplitude_bins mi P
                %% Compute surrogates
                if n_surrogates
                    
                    mi_surr = nan(n_surrogates,1);
                    
                    % reshape back to trials for shuffling
                    amplitude_trials = reshape(amplitude_target,[],n_trials);
                    % clear amplitude.target
                    
                    %% compute surrogate values
                    disp('Computing surrogate data...');
                    for s=1:n_surrogates
                        randind = randperm(n_trials);
                        surrogate_amplitude = reshape(amplitude_trials(:,randind),[],1);
                        amplitude_bins_surr = zeros(n_bins,1);
                        for bin = 1:n_bins
                            amplitude_bins_surr(bin,1) = mean(surrogate_amplitude(phase_bins_ind==bin));
                        end
                        P_surr = amplitude_bins_surr./repmat(sum(amplitude_bins_surr),n_bins,1);
                        mi_surr(s) = 1+sum(P_surr.*log(P_surr))./log(n_bins);
                    end
                    
                    %% fit gaussian to surrogate data, uses normfit.m from MATLAB Statistics toolbox
                    [surrogate_mean,surrogate_std]=normfit(mi_surr);
                    
                    comdlgrm_surr_mean_target(i_phase,i_amplitude) = surrogate_mean;
                    comdlgrm_surr_std_target(i_phase,i_amplitude) = surrogate_std;
                    
                    % clear mi_surr
                end
        %% For Distractor
                phase_degrees = rad2deg(phase_distractor); % Phases in degrees
                % Bining the phases
                step_length = 360/n_bins;
                phase_bins = -180:step_length:180;
                [~,phase_bins_ind] = histc(phase_degrees,phase_bins);
                % clear phase_degrees
                
                % Averaging amplitude time series over phase bins
                amplitude_bins = nan(n_bins,1);
                
                for bin = 1:n_bins
                    amplitude_bins(bin,1) = mean(amplitude_distractor(phase_bins_ind==bin));
                end
                
                % Normalize amplitudes
                P = amplitude_bins./repmat(sum(amplitude_bins),n_bins,1);
                
                % Compute modulation index and store in comodulogram
                mi = 1+sum(P.*log(P))./log(n_bins);
                comdlgrm_distractor(i_phase,i_amplitude) = mi;
                phase2power_distractor(i_phase,i_amplitude,:) = P;
                
                % clear amplitude_bins mi P
                %% Compute surrogates
                if n_surrogates
                    
                    mi_surr = nan(n_surrogates,1);
                    
                    % reshape back to trials for shuffling
                    amplitude_trials = reshape(amplitude_distractor,[],n_trials);
                    % clear amplitude.distractor
                    
                    %% compute surrogate values
                    disp('Computing surrogate data...');
                    for s=1:n_surrogates
                        randind = randperm(n_trials);
                        surrogate_amplitude = reshape(amplitude_trials(:,randind),[],1);
                        amplitude_bins_surr = zeros(n_bins,1);
                        for bin = 1:n_bins
                            amplitude_bins_surr(bin,1) = mean(surrogate_amplitude(phase_bins_ind==bin));
                        end
                        P_surr = amplitude_bins_surr./repmat(sum(amplitude_bins_surr),n_bins,1);
                        mi_surr(s) = 1+sum(P_surr.*log(P_surr))./log(n_bins);
                    end
                    
                    %% fit gaussian to surrogate data, uses normfit.m from MATLAB Statistics toolbox
                    [surrogate_mean,surrogate_std]=normfit(mi_surr);
                    
                    comdlgrm_surr_mean_distractor(i_phase,i_amplitude) = surrogate_mean;
                    comdlgrm_surr_std_distractor(i_phase,i_amplitude) = surrogate_std;
                    
                    % clear mi_surr
                end
            end
        end
        % z-transform raw comod
        comdlgrm_z_target(ichan,:,:) = (comdlgrm_target - comdlgrm_surr_mean_target) ./ comdlgrm_surr_std_target;
        disp('Done')
        % z-transform raw comod
        comdlgrm_z_distractor(ichan,:,:) = (comdlgrm_distractor - comdlgrm_surr_mean_distractor) ./ comdlgrm_surr_std_distractor;
        disp('Done')                     
    end
    comdlgrm_z.target = comdlgrm_z_target;
    comdlgrm_z.distractor = comdlgrm_z_distractor;
    allcomdlgrm_z = comdlgrm_z;
    clear comdlgrm_z_target comdlgrm_z_distractor pcomdlgrm_z_target pcomdlgrm_z_distractor
end