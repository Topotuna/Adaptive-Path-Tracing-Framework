% The script reverses changes applied the script stratify.m

M = permute(M, [1,2,4,3,5]);
M = reshape(M, size(M,1), size(M,2), size(M,3)*size(M,4), size(M,5));

run('downscale.m');
clear stratified_grid;
