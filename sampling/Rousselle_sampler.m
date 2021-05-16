% The script implements the sampling algorithm proposed in 2011 by
% Rousselle et al. in their article. The algorithm achieves local
% error minimisation by applying the optimal filter at each pixel and
% distributing additional samples to those pixels that can improve the
% mean squared error (MSE) the most.

% Small parts of code were written using guidance from the supplemental
% material provided along with the article. Nonetheless, the structure of
% written code is intended to comply with this project's structure and not
% to replicate the provided implementation.

% Parameter initialisation
if exist('I', 'var') ~= 1
    I = 8;
end

if exist('image_spp', 'var') ~= 1
    image_spp = 32;
end

if exist('initial_spp', 'var') ~= 1
    initial_spp = 4;
end

initial_spp = min(initial_spp, max_spp);

% Backup
M_orig = M;

% Initial stratified sampling
num_grids = 1;
grid = [2 2];
run('N_stratified_sampler');
total_samples = sum(~isnan(M(:,:,:,end)),3);

% The main algorithm iterations
for iteration = 1:I
    % Selecting optimal per-pixel filters
    run('../utils/filter_selection.m');

    % Calculating mean squared errors for each pixel
    mses = sum(pixel_variance,3);
    mses = kron(mses,ones(gridDim));
    for stage = 1:max(selected,[],'all')
        slice = sum(mse(:,:,:,stage),3);
        slice = kron(slice,ones(gridDim));
        mses(selected == stage) = slice(selected == stage);
    end
    mses = permute(mean(reshape(mses,gridDim,imageY,gridDim,imageX),[1,3]),[2,4,1,3]);
    clear slice;
    
    % Calculating relative mean squared error for each pixel
    % 0.001 prevents from oversampling dark regions
    mse_relative = sum(mses./(0.001+filtered.^2),3);

    % Probable reduction in relative mse
    mse_relative = mse_relative .* image_spp ./ (image_spp + total_samples);

    % Prevents from adding more samples than datafile can
    mse_relative = mse_relative .* (total_samples ~= max_spp);

    % Distribute new samples
    remaining_samples = imageX*imageY*image_spp - sum(total_samples,'all');
    num_iter_samples = floor(remaining_samples/(I-iteration+1));
    num_iter_pixels = floor(num_iter_samples/image_spp);

    % Sort the pixels by their potential improvement
    [x,y] = meshgrid(1:size(mse_relative,2),1:size(mse_relative,1));
    mask = reshape(cat(3,x,y,mse_relative,total_samples),[],4);
    mask = [mask randperm(size(mask, 1)).'];
    mask = sortrows(mask, [3,5], 'descend');
    
    % First num_iter_pixels get a guaranteed improvement
    samples_used = min(max_spp, mask(1:num_iter_pixels,4) + floor(image_spp/I*8));
    samples_added = samples_used - mask(1:num_iter_pixels,4);
    mask(1:num_iter_pixels,4) = samples_used;
    
    % Distribute leftover samples from this iteration
    samples_left = num_iter_samples - sum(samples_added,'all');
    pixel_index = num_iter_pixels+1;
    while(samples_left > 0)
        extra_samples = min(max_spp-mask(pixel_index,4), ...
                            min(image_spp,samples_left));
        mask(pixel_index,4) = mask(pixel_index,4) + extra_samples;
        samples_left = samples_left - extra_samples;
        pixel_index = pixel_index + 1;
    end
    mask = sortrows(mask, [1,2]);
    mask = reshape(mask,imageY,imageX,[]);
    total_samples = mask(:,:,4);

    % Performing sampling on the original data based on the generated
    % sampling map.
    M = M_orig;
    sampling_map = total_samples;
    run('../utils/custom_sampler.m');
end
