function snr_spectrum = compute_snr_fft(amp_spectrum, freq_resolution)
    n_bins = length(amp_spectrum);
    snr_spectrum = zeros(size(amp_spectrum));
    
    for i = 1:n_bins
        win_start = max(1, i-27);
        win_end = min(n_bins, i+27);
        exclude_idx = [i-1, i, i+1];
        valid_idx = setdiff(win_start:win_end, exclude_idx);
        
        if length(valid_idx) > 48
            valid_idx = valid_idx(1:48);
        end
        
        baseline_mean = mean(amp_spectrum(valid_idx));
        snr_spectrum(i) = amp_spectrum(i) / baseline_mean;
    end
end