% The script performs sampling algorithm described in 1987 by
% Mitchell in hisarticle. The algorithm performs supersampling
% in those regions that contain too high visual contrast in their
% neighbourhoods.

% Parameter initialisation
if exist('base', 'var') ~= 1
    base = 16;
end

if exist('supersample', 'var') ~= 1
    supersample = 64;
end

supersample = min(supersample, size(M, 3));
base = min(base, supersample);

% Find pixel neighbourhood contrasts using the functionality
% of erosion and dilation functions
pixel_mean = permute(mean(M(:,:,1:base,end-3:end-1),3),[1,2,4,3]);
pixel_max = imdilate(xyz2rgb(pixel_mean), ones(3));
pixel_min = imerode(xyz2rgb(pixel_mean), ones(3));
C = (pixel_max - pixel_min) ./ (pixel_max + pixel_min + 0.001);
figure,imshow(C);
imwrite(C, strcat('../output/', output_image, '_Mitchell_contrast.png'), 'png');

% Find supersampling regions
mask  = any(C > permute([0.4, 0.3, 0.6], [3,1,2]), 3);
figure,imshow(mask);
imwrite(mask, strcat('../output/', output_image, '_Mitchell_mask.png'), 'png');

% Fill in sample counts
total_samples(~mask) = base;
total_samples(mask) = supersample;

% Delete unused samples
M(:,:,supersample+1:end,end-3:end) = NaN;
M = reshape(M, size(M,1)*size(M,2), size(M,3), size(M,4));
M(~mask,base+1:supersample,end-3:end) = NaN;
M = reshape(M, imageY, imageX, size(M,2), size(M,3));

clear C mask;
