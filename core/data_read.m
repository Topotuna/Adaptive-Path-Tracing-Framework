% Reads input sample data file and stores its data onto
% a 4D data matrix

tic;

% Data file location
fileID = fopen(strcat('../resources/samples/', datafile));

% Reads data into a matrix
M = fread(fileID, [8, Inf], 'float32').';

fclose(fileID);
toc;

% Assume data structure as
% (Xcell, Ycell, Xoffsett, Yoffset, order, Xcolour, Ycolour, Zcolour, Alpha)

% Adds random global ordering
M = [M(:,1:4) randperm(size(M, 1)).' M(:,5:size(M,2))];

% Changes input coordinates to count from [0,0]
M = sortrows(M, [1, 2, 5]);
M(:,1:2) = M(:,1:2) - M(1,1:2);

% Finds image dimensions
imageY = M(end,2)+1;
imageX = M(end,1)+1;

% Assume data has a fixed number of spp
max_spp = size(M, 1) / (imageX * imageY);

% Forms the data matrix
M = permute(reshape(M, [], imageY, imageX, size(M, 2)), [2,3,1,4]);
