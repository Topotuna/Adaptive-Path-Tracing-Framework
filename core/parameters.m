% Parameters for the adaptive path tracing framework.

% The name of the sample data file
datafile = 'samples.bin';

% The name for output files
output_image = 'output';

% The script name for sampling algorithm
adaptive_sampler_script = 'Mitchell_sampler.m';

% The script name for image reconstruction algorithm
adaptive_reconstruct_script = 'Mitchell_reconstruct.m';


% Input parameters for individual strategies

% Uniform sampling
% N = 32;

% Uniform stratified sampling
% grid = [4 4];
% num_grids = 2;

% Lee sampling
% max_var = 1/128;
% beta = 0.05;

% Mitchell sampling
% base = 16;
% supersampling = 64;

% Rousselle sampling;
% I = 8;
% initial_spp = 4;
% image_spp = 32;
