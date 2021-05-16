% The script takes a custom sampling map and modifies the
% matrix M accoridng to it

if exist('sampling_map', 'var') ~= 1
    sampling_map = 32*ones(imageY,imageX);
end

M = reshape(M, size(M,1)*size(M,2), size(M,3), size(M,4));

lowest = min(sampling_map, [], 'all');
while lowest < size(M,2)

    mask = (sampling_map == lowest);
    M(mask,lowest+1:end,end-3:end) = NaN;

    sampling_map(mask) = size(M,2);
    lowest = min(sampling_map, [], 'all');
end

M = reshape(M, imageY, imageX, size(M,2), size(M,3));

clear sampling_map;
