% The script performs sampling algorithm described in 1985 by
% Lee et al. in their article. The algorithm performs additional
% sampling until exit criterion is met. The criterion is derived
% accoridng to per-pixel sample variance estimation.

% Worst case variance
if exist('max_var', 'var') ~= 1
    max_var = 1/128;
end

% Chance of stopping
if exist('beta', 'var') ~= 1
    beta = 0.05;
end

% Chi2 distribution
chi_beta = chi2inv(beta, max_spp-1);

% Sampling threshold
T = max_var / chi_beta;
LUT = arrayfun(@(x)chi2inv(beta, x), (1:max_spp-1).') * T;

% Minimum number of sampling grids used
base_grids = 1;
grid = [2 4];
run('../utils/stratify');

sum_samples = zeros(size(M,1),size(M,2), 3);
sum_squares = zeros(size(M,1),size(M,2), 3);

for i = 1:size(M, 3)

    % Add more samples to the sample map
    num_samples = sum(~isnan(M(:,:,i,:,end)), 4);
    total_samples = total_samples + num_samples;
    
    % Accumulate iteration data
    sum_samples = sum_samples + squeeze(sum(M(:,:,i,:,end-3:end-1), 4, 'omitnan'));
    sum_squares = sum_squares + squeeze(sum(M(:,:,i,:,end-3:end-1) .* ...
                                            M(:,:,i,:,end-3:end-1), 4, 'omitnan'));
    average = sum_samples ./ total_samples;

    % Calculate exit criterion
    SN2 = 1 ./ total_samples .* (sum_squares - 2 * sum_samples .* average + ...
                                 total_samples .* average .* average);
    
    % Select pixels that have reached the stopping criterion
    mask = total_samples > 1 & i >= base_grids & all(SN2 < LUT(max(total_samples-1, 1)), 3);
    
    % Fill in unused values with NaN
    M = reshape(M, size(M,1)*size(M,2), size(M,3), size(M,4), size(M,5));
    M(mask,i+1:end,:,end-3:end) = NaN;
    M = reshape(M, imageY, imageX, size(M,2), size(M,3), size(M,4));
end

% Return to original matrix structure of M
run('../utils/merge_stratify.m');
