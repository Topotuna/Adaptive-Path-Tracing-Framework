% The script adds extra dimension to the matrix M to
% store the samples values on a grid for every pixel
% instead of a list

if exist('grid', 'var') == 1
    stratified_grid = grid; % Stratified sampling rate
else
    stratified_grid = [1 1];
end
clear grid;

if prod(stratified_grid) ~= 1
    grid = stratified_grid;
    run('subdivide.m');

    M = reshape(M, size(M,1)*size(M,2)*size(M,3), size(M,4)); % Form a list
    M = sortrows(M, [1,2,5]); % Sort randomly within sub-pixels
    M = permute(reshape(M, [], stratified_grid(1), ...
                        imageY, stratified_grid(2), imageX, size(M,2)), ...
                [3,5,1,2,4,6]);
    M = reshape(M, size(M,1), size(M,2), size(M,3),...
                size(M,4)*size(M,5), size(M,6)); % Recreate initial structure
else
    M = permute(M, [1,2,3,5,4]); % Add extra dimension
end
