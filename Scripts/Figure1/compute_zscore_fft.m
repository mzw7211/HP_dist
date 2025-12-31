function z_scores = compute_zscore_fft(spectrum)
    n_bins = length(spectrum);
    z_scores = zeros(size(spectrum));
    
    for i = 1:n_bins
        exclude_start = max(1, i-2);
        exclude_end = min(n_bins, i+2);
        exclude_range = exclude_start:exclude_end;
        
        window_start = max(1, i-27);
        window_end = min(n_bins, i+27);
        valid_bins = setdiff(window_start:window_end, exclude_range);
        
        if length(valid_bins) > 48
            valid_bins = valid_bins(1:48);
        end
        
        mu = mean(spectrum(valid_bins));
        sigma = std(spectrum(valid_bins));
        z_scores(i) = (spectrum(i) - mu) / sigma;
    end
end