% The script applies stratified sampling and takes
% variables grid and num_grid as parameters.

% Default sampling grid is 4-by-4
if exist('grid', 'var') ~= 1
    grid = [4 4];
end

% Default number of sampling grids used is such that achieved
% sampling rate is no greater than 32.
if exist('num_grids', 'var') ~= 1
    num_grids = max(1, floor(32/prod(grid)));
end

if prod(grid) == 1
    N = num_grids;
    run('N_sampler');
else    

    % Uniform sampling is performed on a stratified grid
    run('../utils/stratify');

    M(:,:,num_grids+1:end,:,end-3:end) = NaN;
    total_samples(:,:) = num_grids*prod(stratified_grid);

    run('../utils/merge_stratify.m');
end
