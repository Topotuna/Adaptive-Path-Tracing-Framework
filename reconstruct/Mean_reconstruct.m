% The script implements per-pixel mean box filtering

% Calculates mean sample values
image = permute(mean(M(:,:,:,end-3:end), 3, 'omitnan'), [1,2,4,3]);

% Performs colour space conversion from CIE 1931 XYZ to inear RGB
image(:,:,1:3) = xyz2rgb(image(:,:,1:3), 'ColorSpace', 'linear-rgb');
