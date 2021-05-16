% The script performs uniform sampling with N passed
% as a parameter.

% Default value for N is 32
if exist('N', 'var') ~= 1
    N = 32;
end

% Discard unused samples
M(:,:,N+1:end,end-3:end) = NaN;
total_samples(:,:) = N;
