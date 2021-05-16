% The script implements optimal filter scale selection procedure described
% by Rousselle et al in 2011. The image is sub-divided and optimal filter
% is selected for each sub-pixel.

% Small parts of code were written using guidance from the supplemental
% material provided along with the article. Nonetheless, the structure of
% written code is intended to comply with this project's structure and not
% to replicate the provided implementation.

% Parameter initialisation
if exist('scale', 'var') ~= 1
    scale = [4, 1, 2]; % [stages, initial, increment]
end
filter_scales = 4 * scale(2) .* scale(3) .^ (0:scale(1)-1);
clear scale;

gridDim = 4;

num_samples = sum(~isnan(M(:,:,:,end)),3);

% Error rate
gamma = 0.05;

% Parameter for loss in scaling
loss = -log(1 - (1.9 * gamma)^(1/sqrt(2)));

% Scale selector coefficient
rc2 = filter_scales(2:end).*filter_scales(2:end);
rf2 = filter_scales(1:end-1).*filter_scales(1:end-1);
coef = [1, (rc2+rf2)./(rc2-rf2)];

pixel_variance = permute(var(M(:,:,:,end-3:end), 0, 3, 'omitnan'),[1,2,4,3]);

% Calculating the initial mean squared error as the pixel variance
mse = zeros(size(M,1),size(M,2),size(pixel_variance,3),numel(filter_scales)+1);
mse(:,:,:,1) = pixel_variance;

% Spreading samples over a finer 4-by-4 grid
grid = [gridDim gridDim];
run('subdivide_with_fill.m');

% Calculating mean and variance over a finer image grid
subpixel_mean = permute(mean(M(:,:,:,end-3:end), 3, 'omitnan'),[1,2,4,3]);
subpixel_variance = permute(var(M(:,:,:,end-3:end), 0, 3, 'omitnan'),[1,2,4,3]);

% Initialising cycle variables
f = subpixel_mean;
varf = subpixel_variance;
kernel_norm = 1;

mask = true(size(M,1),size(M,2));
selected = zeros(size(mask,1,2));
filtered = zeros(size(mask,1)*size(mask,2),size(pixel_variance,3));
for stage = 1:numel(filter_scales)
    rho = 1 - 1./(num_samples/(kernel_norm)); % Compensates for low sample counts
    rho = kron(rho,ones(gridDim));
    
    % Form a Gaussian filter
    radius = ceil(2*filter_scales(stage));
    kernel = zeros(2*radius+1);
    kernel(radius+1,radius+1) = 1;
    gauss = imgaussfilt(kernel,filter_scales(stage));
    kernel_norm = norm(gauss);
    
    % Find filtered image subpixel values
    c = imgaussfilt(subpixel_mean,filter_scales(stage));

    % And variance values
    varc = conv2(subpixel_variance(:,:,1),gauss.^2,'same');
    for i = 2:size(subpixel_variance,3)
        varc(:,:,i) = conv2(subpixel_variance(:,:,i),gauss.^2,'same');
    end
    
    % Calculate difference in MSE from selecting a coarser filter
    mse_diff = coef(stage).*(f-c).^2 - (varf-varc);
    mse_diff = permute(mean(reshape(mse_diff,4,imageY,4,imageX,size(mse_diff,3)),[1,3]),[2,4,5,1,3]);
    mse(:,:,:,stage+1) = mse(:,:,:,stage) + mse_diff;

    % Scale selector
    S = coef(stage)*loss*rho.*(f-c).^2 - (varf-varc);
    filter = sum(S,3) >= 0;
    
    % Denoising filters
    gauss(radius+1,radius+1) = 0.001*gauss(radius+1,radius+1);
    gauss = gauss(2:end-1,2:end-1);
    gauss = gauss/sum(gauss,'all');
    filter = conv2(filter == 0,gauss,'same');
    filter = round(filter) == 0;

    % Find pixels where finer filters are suitable
    selected(mask) = filter(mask)*(stage-1);
    
    % Find pixels affected by this filtering stage
    newMask = mask;
    newMask(mask) = ~filter(mask);
    stagePixels = ~newMask & mask;
    
    % Use these pixels in a final image
    f = reshape(f,[],size(f,3));
    filtered(stagePixels,:) = f(stagePixels,:);
    
    mask = newMask;
    varf = varc;
    f = c;
end
selected(mask) = stage;

% Find pixels unaffected by previous filtering stages
stagePixels = mask;

% Use these pixels in a final image
c = reshape(c,[],size(filtered,2));
filtered(stagePixels,:) = c(stagePixels,:);
filtered = reshape(filtered,size(selected,1),size(selected,2),size(pixel_variance,3));
filtered = permute(mean(reshape(filtered,4,imageY,4,imageX,size(pixel_variance,3)),[1,3]),[2,4,5,1,3]);
