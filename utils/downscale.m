% The script reverses changes applied by subdivide.m
% and subdivide_with_fill.m scripts

stratified_grid = [stratified_grid(2) stratified_grid(1)];
stratified_grid = permute(stratified_grid, [3,4,1,2]);

M(:,:,:,3:4) = (M(:,:,:,3:4) + mod(M(:,:,:,1:2), stratified_grid)) ./ stratified_grid;
M(:,:,:,1:2) = floor(M(:,:,:,1:2) ./ stratified_grid);

M = reshape(M, size(M,1)*size(M,2)*size(M,3), size(M,4));
M = sortrows(M, [1,2,5]);
M = permute(reshape(M, [], imageY, imageX, size(M,2)), [2,3,1,4]);
