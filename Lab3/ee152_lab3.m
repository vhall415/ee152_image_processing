%% EE 152 Lab3: Fun with Frequency and Warping - Victoria Hall, 861154075

%% L3.1 Spatial frequencies I:
% Use the two images captured in L2.1. Resize them to 256x256 resolution
% using imresize() with anti-aliasing.
%
% (a) Display your image and their 2D Fourier transform magnitude and phase
% (use fft2, fftshift functions). Use
% imagesc(log(abs(fftshift(fft2(gray_image))))) to display log magnitude of
% the Fourier transform.
%
% (b) Apply a low pass and a high pass filter on all these images and
% display your results (Use fspecial('gaussian', filterSize, Sigma) for
% lowpass filter and try different values of filterSize and Sigma. Select
% the values that highlight the low and high frequency components the
% best).
%
% (c) Compute energy in the low frequency and high frequency coefficients
% of the images.
%
% (d) Repeat Example 2.11 in your textbook by adding a set of sinusoids in
% your images. Then remove those frequencies by setting the respective
% entries in the Fourier domain to zero.
clear;
close all;

%%
% Part a

im1 = imread('sharp.jpg');
im2 = imread('uniform.jpg');
i_sharp = imresize(im1, [256 256], 'Antialiasing', true);
i_uni = imresize(im2, [256 256], 'Antialiasing', true);

g_sharp = rgb2gray(i_sharp);
g_uni = rgb2gray(i_uni);

figure;
imshow(g_sharp);
title('Original Sharp Image');
figure;
imagesc(log(abs(fftshift(fft2(g_sharp)))));
title('Log Magnitude of Fourier Transform');
figure;
imagesc(angle(fftshift(fft2(g_sharp))));
title('Phase of Fourier Transform');

figure;
imshow(g_uni);
title('Original Uniform Image');
figure;
imagesc(log(abs(fftshift(fft2(g_uni)))));
title('Log Magnitude of Fourier Transform');
figure;
imagesc(angle(fftshift(fft2(g_uni))));
title('Phase of Fourier Transform');

%%
% Part b

lp_g = fspecial('gaussian', 5, 1.7);
lp_sharp = imfilter(g_sharp, lp_g);
lp_uni = imfilter(g_uni, lp_g);

figure;
imshow(lp_sharp);
title('Lowpass Filtered Sharp Image');
figure;
imagesc(log(abs(fftshift(fft2(lp_sharp)))));
title('Log Magnitude of Lowpass Fourier Transform');
figure;
imagesc(angle(fftshift(fft2(lp_sharp))));
title('Phase of Lowpass Fourier Transform');

figure;
imshow(lp_uni);
title('Lowpass Filtered Uniform Image');
figure;
imagesc(log(abs(fftshift(fft2(lp_uni)))));
title('Log Magnitude of Lowpass Fourier Transform');
figure;
imagesc(angle(fftshift(fft2(lp_uni))));
title('Phase of Lowpass Fourier Transform');

hp_g = fspecial('gaussian', 5, 0.001);
fil_sharp = imfilter(g_sharp, hp_g);
fil_uni = imfilter(g_uni, hp_g);
hp_sharp = g_sharp - lp_sharp;
hp_uni = g_uni - lp_uni;

figure;
imshow(hp_sharp);
title('Highpass Filtered Sharp Image');
figure;
imagesc(log(abs(fftshift(fft2(hp_sharp)))));
title('Log Magnitude of Highpass Fourier Transform');
figure;
imagesc(angle(fftshift(fft2(hp_sharp))));
title('Phase of Highpass Fourier Transform');

figure;
imshow(hp_uni);
title('Highpass Filtered Uniform Image');
figure;
imagesc(log(abs(fftshift(fft2(hp_uni)))));
title('Log Magnitude of Highpass Fourier Transform');
figure;
imagesc(angle(fftshift(fft2(hp_uni))));
title('Phase of Highpass Fourier Transform');

%%
% Part c
el_sharp = norm(abs(fft2(lp_sharp)), 2)^2;
el_uni = norm(abs(fft2(lp_uni)), 2)^2;
eh_sharp = norm(abs(fft2(hp_sharp)), 2)^2;
eh_uni = norm(abs(fft2(hp_uni)), 2)^2;

Energy = [el_sharp; el_uni; eh_sharp; eh_uni];
names = {'Lowpass Sharp', 'Lowpass Uniform', 'Highpass Sharp', 'Highpass Uniform'};
table(Energy, 'RowNames', names)

%%
% Part d
f = 5;% you choose
i_sin = uint8(255 * mat2gray(repmat(sin(linspace(0,f*(2*pi+pi),256)),[256 1])));

figure;
imshow(i_sin);
title('Sinusoidal Image');

sin_sharp = imadd(g_sharp, i_sin);
sin_uni = imadd(g_uni, i_sin);

figure;
imshow(sin_sharp);
title('Sin Corrupted Sharp Image');
figure;
imshow(sin_uni);
title('Sin Corrupted Uniform Image');

% fft of corrupted images
fc_sharp = fftshift(fft2(sin_sharp));
fc_uni = fftshift(fft2(sin_uni));
fadj_sharp = fc_sharp;
fadj_uni = fc_uni;
% fft of sin image
ff_sin = fft2(i_sin);
% if fft of sin image > 1
% for r = 1:256
%     for c = 1:256
%         if ff_sin(r, c) ~= 0
%             fadj_sharp(r, c) = 0;
%             fadj_uni(r, c) = 0;
%         end
%     end
% end
thresh = 4;
spike = log(abs(fftshift(ff_sin))) > thresh;
for r = 1:256
    for c = 1:256
        if spike(r, c) == 1
            fadj_sharp(r, c) = 0;
            fadj_uni(r, c) = 0;
        end
    end
end
% for r = 1:256
%     for c = 160:256
%         if spike(r, c) == 1
%             fadj_sharp(r, c) = 0;
%             fadj_uni(r, c) = 0;
%         end
%     end
% end
% fadj_sharp(spike) = 0;
% fadj_uni(spike) = 0;

% set fft of corrupted image at that location to 0
% ifft of modified fft corrupted image
fixed_sharp = ifft2(fadj_sharp);
fixed_uni = ifft2(fadj_uni);

figure;
imagesc(log(abs(fftshift(ff_sin))));
title('Sin Image Fourier Transform');
figure;
imagesc(log(abs(fftshift(fc_sharp))));
title('Sin Corrupted Sharp Fourier Transform');
figure;
imagesc(log(abs(fftshift(fc_uni))));
title('Sin Corrupted Uni Fourier Transform');
figure;
imagesc(log(abs(fftshift(fadj_sharp))));
title('Adjusted Sharp Fourier Transform');
figure;
imagesc(log(abs(fftshift(fadj_uni))));
title('Adjusted Uniform Fourier Transform');
figure;
imshow(fixed_sharp, []);
title('Fixed Sharp Image');
figure;
imshow(fixed_uni, []);
title('Fixed Uniform Image');

%% L3.2 Spatial frequencies II:
% Write your initials on a piece of paper and take their pictures.
%
% (a) Plot each letter with its corresponding 2D Fourier transform. Use
% English and Chinese characters if you wish.
%
% (b) Repeat Example 3.16 in your textbook to sharpen these letters using
% an unsharp mask and a highboost mask.
%
% (c) Swap phases of the Fourier transform for the two images and perform
% the inverse Fourier transform to reconstruct the images (use ifft2).

init_v = imread('init_v.jpg');
init_h = imread('init_h.jpg');
c_v = imcrop(init_v, [1410 953 400 400]);
c_h = imcrop(init_h, [1524 1007 400 400]);
i_v = imresize(c_v, [256 256]);
i_h = imresize(c_h, [256 256]);
g_v = rgb2gray(i_v);
g_h = rgb2gray(i_h);
f_v = fft2(g_v);
f_h = fft2(g_h);

v_mag = abs(f_v);
h_mag = abs(f_h);
v_phase = angle(f_v);
h_phase = angle(f_h);

figure;
imshow(g_v);
title('Image of V');
figure;
imagesc(log(fftshift(v_mag)));
title('Magnitude of V');
figure;
imagesc(v_phase);
title('Phase of V');
figure;
imshow(g_h);
title('Image of H');
figure;
imagesc(log(fftshift(h_mag)));
title('Magnitude of H');
figure;
imagesc(h_phase);
title('Phase of H');

%%
% Part b

% blur image
h_blur = fspecial('disk', 10);
iv_blur = imfilter(g_v, h_blur, 'replicate');
ih_blur = imfilter(g_h, h_blur, 'replicate');

% subtract blur from original = mask
iv_mask = imsubtract(g_v, iv_blur);
ih_mask = imsubtract(g_h, ih_blur);

figure;
imshow(iv_blur);
title('Blurred V');
figure;
imshow(iv_mask);
title('Unsharp Mask for V');

figure;
imshow(ih_blur);
title('Blurred H');
figure;
imshow(ih_mask);
title('Unsharp Mask for H');

% add mask to original (multiply mask by weight k)
k_unsharp = 1;  % k <= 1 for unsharp masking
k_highboost = 4.5;  % k > 1 for highboost filtering
iv_unsharp = imadd(g_v, immultiply(iv_mask, k_unsharp));
iv_highboost = imadd(g_v, immultiply(iv_mask, k_highboost));
ih_unsharp = imadd(g_h, immultiply(ih_mask, k_unsharp));
ih_highboost = imadd(g_h, immultiply(ih_mask, k_highboost));

figure;
imshow(iv_unsharp);
title('Sharpened V Using Unsharp Mask');
figure;
imshow(iv_highboost);
title('Sharpened V Using Highboost Mask');

figure;
imshow(ih_unsharp);
title('Sharpened H Using Unsharp Mask');
figure;
imshow(ih_highboost);
title('Sharpened H Using Highboost Mask');

%%
% Part c

f_v2 = v_mag .* exp(1i*h_phase);
f_h2 = h_mag .* exp(1i*v_phase);

inv_v = ifft2(f_v2);
inv_h = ifft2(f_h2);

figure;
imshow(real(inv_v), []);
title({'Inverse Fourier Transform of V', 'With The Phase Switched With H'});
figure;
imshow(real(inv_h), []);
title({'Inverse Fourier Transform of H', 'With The Phase Switched With V'});

%% L3.3 More fun with frequencies:
% Capture and image of yourself and another person.
%
% (a) Register (especially, align the eyes in) both images using an affine
% transformation (you may use fitgeotrans() command in Matlab).
%
% (b) Combine high and low frequencies from different images to create a
% hybrid image that changes from a high-frequency image to a low-frequency
% image as you move away from the screen. You may use a Gaussian filter as
% the lowpass filter h(x) =
% 1/sqrt(2*pi)*sigma*exp(-||x-mu||_2^2/2*sigma^2) Play with the cutoff
% frequency starting with the full width half maximum (i.e., FWHM ~
% 2.355*sigma) or some other value that covers half of the freuency
% spectrum. To create a highpass filter, simply subtract the lowpass kernel
% from 1.
%
% (c) Bonus: Try creating different types of hybrid images. Create images
% that change over time, morph into something else, or high and low
% frequency components swap. Combine objects of different types. Discuss
% the failure issues.

