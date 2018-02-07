close all;
clear;

I = imread('cameraman.tif');
figure;
imshow(I);
I_r = imrotate(I, 180);
figure;
imshow(I_r);
I_s = imresize(I, [256 512]);
figure;
imshow(I_s);

p1 = detectHarrisFeatures(I);
p2 = detectHarrisFeatures(I_r);
p3 = detectHarrisFeatures(I_s);

figure;
imshow(I);
hold on;
plot(p1.selectStrongest(50));
hold off;
figure;
imshow(I_r);
hold on;
plot(p2.selectStrongest(50));
hold off;
figure;
imshow(I_s);
hold on;
plot(p3.selectStrongest(50));
hold off;