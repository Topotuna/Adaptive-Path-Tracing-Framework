% The script implements the adaptive image reconstruction algorithm
% proposed in 2011 by Rousselle et al. It filters each image pixel using
% its optimal local filter.

% Small parts of code were written using guidance from the supplemental
% material provided along with the article. Nonetheless, the structure of
% written code is intended to comply with this project's structure and not
% to replicate the provided implementation.

% Parameter initialisation
scale = [8, 1/sqrt(2), sqrt(2)]; % [stages, initial, increment]

% Per-pixel filter selection procedure
run('../utils/filter_selection.m');

% Display and store intermediate results
imwrite(selected/max(selected,[],'all'), strcat('../output/', output_image, '_Rousselle_reconstruct_filters.png'), 'png');
figure,imshow(selected/max(selected,[],'all'));
imwrite(1-selected/max(selected,[],'all'), strcat('D:/output/stoppingmapfinal.png'));

% Downscaling the image using bicubic interpolation
image = imresize(filtered, [imageY imageX], 'bicubic');

% Converting from CIE 1931 XYZ to linear RGB colour space
image(:,:,1:3) = xyz2rgb(image(:,:,1:3), 'ColorSpace', 'linear-rgb');
