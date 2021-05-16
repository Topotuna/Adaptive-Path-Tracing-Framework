% The script implements the image reconstruction method proposed in 1987
% by Mitchel. The algorithm spreads samples over a giner 4-by-4 grid and
% applies multiple stage image filtering.

% Assigns sub-pixel coordinates for every sample
gridDim = 4;
grid = [gridDim gridDim];
run('../utils/subdivide_with_fill.m');

% Distributes the samples over a finer grid based on their new coordinates
M = reshape(M, size(M,1)*size(M,2)*size(M,3), size(M,4));
M = sortrows(M, [1,2,5]);
M = permute(reshape(M, [], gridDim*imageY, gridDim*imageX, size(M,2)), [2,3,1,4]);

% Calculates sub-pixel mean colour values
image = permute(mean(M(:,:,:,end-3:end), 3, 'omitnan'), [1,2,4,3]);
image(isnan(image(:,:,1:3))) = 0;

% Applies colour space conversion from CIE 1931 XYZ to linear RGB
image(:,:,1:3) = xyz2rgb(image(:,:,1:3), 'ColorSpace', 'linear-rgb');

% Applies additional three filtering stages
image = imboxfilt(image);
image = imboxfilt(image);
image = imboxfilt(image, 5); % Filter twice as wide

% Downscales the image using bicubic interpolation
image = imresize(image, [imageY imageX], 'bicubic');
