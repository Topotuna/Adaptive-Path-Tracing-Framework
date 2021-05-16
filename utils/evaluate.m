% The script applies HDR-VDP-3 metric to determine the test
% image quality compared to the reference

test_image = '../output/test.exr';
reference_image = '../../resources/reference/cbox.exr';
diff = hdrvdp3('quality', double(exrread(test_image)), ...
               double(exrread(reference_image)), 'rgb-native', 30)
