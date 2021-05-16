% The script performs sample data sub-dividing into a finer grid
% where empty sub-pixel values get flled with mean pixel values

% Prepare to fill in empty subpixels with mean pixel value
filling = permute(mean(M(:,:,:,end-3:end),3,'omitnan'),[1,2,4,3]);
filling = cat(3,kron(filling(:,:,1),ones(4)),kron(filling(:,:,2),ones(4)),...
                kron(filling(:,:,3),ones(4)),kron(filling(:,:,4),ones(4)));
            
run('subdivide.m');
M = reshape(M, size(M,1)*size(M,2)*size(M,3), size(M,4));
M = sortrows(M, [1,2,5]);
M = permute(reshape(M, [], gridDim*imageY, gridDim*imageX, size(M,2)), [2,3,1,4]);

% Fill in empty subpixels with mean pixel value
slice = M(:,:,1,end-3:end);
slice(isnan(slice)) = filling(isnan(slice));
M(:,:,1,end-3:end) = slice;
clear filling slice;
