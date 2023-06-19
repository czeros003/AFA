function mm_atrous_lena(lvl, Threshold)
% Read and process the Lena image
[X, ~] = imread('lena.jpg');
Lena = rgb2gray(X);
y = Lena(50:177, 50:177);
recon_mm2(lvl, Threshold, y);
