% The adaptive path tracing framework

clear;
clc;

% Seeding the random number generator for deterministic results.
rng('default');

% Parameter initialisation
run('parameters.m');

'reading from file'
run('data_read.m');

% Initialising sampling map
total_samples = zeros(size(M,1), size(M,2));

'adaptive sampling'
tic;
total_samples = zeros(size(M,1), size(M,2));
run(strcat('../sampling/', adaptive_sampler_script));
toc;

'adaptive image reconstruction'
tic;
run(strcat('../reconstruct/', adaptive_reconstruct_script));
toc;

% Storing the results as output files in EXR and PNG formats
exrwritechannels(strcat('../output/', output_image, '.exr'), {'R', 'G', 'B', 'A'}, permute(num2cell(image, [1,2]), [3,1,2]));
imwrite(lin2rgb(image(:,:,1:3)), strcat('../output/', output_image, '.png'), 'Alpha', image(:,:,4));
imwrite(total_samples/max_spp, strcat('../output/', output_image, '_spp.png'), 'png');

% Display output image and the sample map
figure, imshow(lin2rgb(image(:,:,1:3)));
figure, imshow(total_samples/max_spp);

% Log the mean sampling rate for the generated image
fid = fopen('../logfile.txt', 'a+');
fprintf(fid, 'Sampler: %s \tReconstructor: %s \tMean spp: %d\n', adaptive_sampler_script, ...
        adaptive_reconstruct_script, mean(total_samples, 'all'));
fclose(fid);
