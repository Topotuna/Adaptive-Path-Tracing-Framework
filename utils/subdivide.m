% The script sub-divides the sample grid into a finer
% sub-pixel grid indicated by the variable grid

multiplier = [grid(2), grid, grid(1)];
multiplier = permute(multiplier, [3, 4, 1, 2]);

% Subdivide each pixel into a stratified grid
M(:,:,:,1:4) = M(:,:,:,1:4) .* multiplier;

% Find subpixels. Floor function prevents samples from
% getting assigned to wrong pixels.
subpixel = min(floor(M(:,:,:,3:4)), ...
               permute([grid(2),grid(1)]-1,[3,4,1,2]));
M(:,:,:,1:2) = M(:,:,:,1:2) + subpixel; % Recalculate subpixels
M(:,:,:,3:4) = M(:,:,:,3:4) - subpixel; % Find subpixel offsets

clear grid;
