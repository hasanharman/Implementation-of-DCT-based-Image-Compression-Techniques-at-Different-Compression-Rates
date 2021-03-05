clc;
clear;
close all;

originalImg = imread('lena.tiff');
YUV_image=rgb2ycbcr(originalImg);
red = double(originalImg(:,:,1));
green = double(originalImg(:,:,2));
blue = double(originalImg(:,:,3));
%prompt = 'Please enter blocksize(2 or 4 or 8)\n';
%blocksize = input(prompt);
blocksize = 8;
DCT = DCT_basis(blocksize);

DCT_quantizer10 = ...    % levels for quantizing the DCT block (8x8 matrix)
[ 80   60   50   80  120 200 255 255; ...
       55   60   70  95  130 255 255  255; ...
       70   65   80  120 200 255 255  255; ...
       70  185  110  145 255 255 255  255; ...
       90  110  185  255 255 255 255  255; ...
      175  120  255  255 255 255 255  255; ...
      255  255  255  255 255 255 255  255; ...
      255  255  255  255 255 255 255  255 ];

DCT_quantizer50 = ...    % levels for quantizing the DCT block (8x8 matrix)
[ 16  11  10  16  24  40  51  61; ...
      12  12  14  19  26  58  60  55; ...
      14  13  16  24  40  57  69  56; ...
      14  17  22  29  51  87  80  62; ...
      18  22  37  56  68 109 103  77; ...
      24  35  55  64  81 104 113  92; ...
      49  64  78  87 103 121 120 101; ...
      72  92  95  98 112 100 103  99 ];
 
DCT_quantizer90 = ...    % levels for quantizing the DCT block (8x8 matrix)
[ 3    2   2   3   5  8 10 12; ...
       2   2   3   4  5 12 12  11; ...
       3   3   3   5  8 11 14  11; ...
       3   3   4   6 10 17 16  12; ...
       4   4   7  11 14 22 21  15; ...
       5   7  11  13 16 12 23  18; ...
      10  13  16  17 21 24 24  21; ...
      14  18  19  20 22 20 20  20 ];
                       
redQ10 = compression(red,DCT,DCT_quantizer10,blocksize);
greenQ10 = compression(green,DCT,DCT_quantizer10,blocksize);
blueQ10 = compression(blue,DCT,DCT_quantizer10,blocksize);

redQ50 = compression(red,DCT,DCT_quantizer50,blocksize);
greenQ50 = compression(green,DCT,DCT_quantizer50,blocksize);
blueQ50 = compression(blue,DCT,DCT_quantizer50,blocksize);

redQ90 = compression(red,DCT,DCT_quantizer90,blocksize);
greenQ90 = compression(green,DCT,DCT_quantizer90,blocksize);
blueQ90 = compression(blue,DCT,DCT_quantizer90,blocksize);

comp10(:,:,1) = redQ10;
comp10(:,:,2) = greenQ10;
comp10(:,:,3) = blueQ10;
imwrite(comp10,'comp_player10.jpg');

comp50(:,:,1) = redQ50;
comp50(:,:,2) = greenQ50;
comp50(:,:,3) = blueQ50;
imwrite(comp50,'comp_player50.jpg');

comp90(:,:,1) = redQ90;
comp90(:,:,2) = greenQ90;
comp90(:,:,3) = blueQ90;
imwrite(comp90,'comp_player90.jpg');

redD10 = decompression(redQ10,DCT,DCT_quantizer10,blocksize);
greenD10 = decompression(greenQ10,DCT,DCT_quantizer10,blocksize);
blueD10 = decompression(blueQ10,DCT,DCT_quantizer10,blocksize);

redD50 = decompression(redQ50,DCT,DCT_quantizer50,blocksize);
greenD50 = decompression(greenQ50,DCT,DCT_quantizer50,blocksize);
blueD50 = decompression(blueQ50,DCT,DCT_quantizer50,blocksize);

redD90 = decompression(redQ90,DCT,DCT_quantizer90,blocksize);
greenD90 = decompression(greenQ90,DCT,DCT_quantizer90,blocksize);
blueD90 = decompression(blueQ90,DCT,DCT_quantizer90,blocksize);

decompImg10(:,:,1) = uint8(redD10);
decompImg10(:,:,2) = uint8(greenD10);
decompImg10(:,:,3) = uint8(blueD10);
imwrite(decompImg10,'decomp_peppers10.jpg');

decompImg50(:,:,1) = uint8(redD50);
decompImg50(:,:,2) = uint8(greenD50);
decompImg50(:,:,3) = uint8(blueD50);
imwrite(decompImg50,'decomp_peppers50.jpg');

decompImg90(:,:,1) = uint8(redD90);
decompImg90(:,:,2) = uint8(greenD90);
decompImg90(:,:,3) = uint8(blueD90);
imwrite(decompImg90,'decomp_peppers90.jpg');

s1 = dir('lena.tiff');
originalSize = s1.bytes;
%fprintf('\n Original image size is %0.4f bytes', originalSize);
s10 = dir('decomp_peppers10.jpg');
q10Size = s10.bytes;
%fprintf('\n Q=10 is %0.4f bytes', q10Size);
s50 = dir('decomp_peppers50.jpg');
q50Size = s50.bytes;
%fprintf('\n Q=50 is %0.4f bytes', q50Size);
s90 = dir('decomp_peppers90.jpg');
q90Size = s90.bytes;
%fprintf('\n Q=90 is %0.4f bytes', q90Size);

CR10 = originalSize/q10Size;
CR50 = originalSize/q50Size;
CR90 = originalSize/q90Size;

fprintf('\n Compression Ratio for Q=10 is %0.4f', CR10);
fprintf('\n Compression Ratio for Q=50 is %0.4f', CR50);
fprintf('\n Compression Ratio for Q=90 is %0.4f', CR90);

figure(1)
subplot(131)
imshow(comp10);
title('Compressed Image Q=10')
subplot(132)
imshow(decompImg10);
title('Reconstructed Image Q=10')
subplot(133)
imshow(originalImg);
title('Original Image')

figure(2)
subplot(131)
imshow(comp50);
title('Compressed Image Q=50')
subplot(132)
imshow(decompImg50);
title('Reconstructed Image Q=50')
subplot(133)
imshow(originalImg);
title('Original Image')

figure(3)
subplot(131)
imshow(comp90);
title('Compressed Image Q=90')
subplot(132)
imshow(decompImg90);
title('Reconstructed Image Q=90')
subplot(133)
imshow(originalImg);
title('Original Image')

ref10=imread('decomp_peppers10.jpg');
ref50=imread('decomp_peppers50.jpg');
ref90=imread('decomp_peppers90.jpg');

%Calculating MSE values
%(64/64) means rows and col values when blocksize is 8,depending on the blocksize since our
%pictures is 512x512 rows and cols values calculating by dividing picture
%to blocksize
squaredErrorImage1 = (double(originalImg) - double(ref10)) .^ 2;
mse1 = sum(squaredErrorImage1(:)) / (64  * 64); 
squaredErrorImage2 = (double(originalImg) - double(ref50)) .^ 2;
mse2 = sum(squaredErrorImage2(:)) / (64 * 64);
squaredErrorImage3 = (double(originalImg) - double(ref90)) .^ 2;
mse3 = sum(squaredErrorImage3(:)) / (64 * 64);
fprintf('\n The MSE value for Q=10 is %0.4f', mse1);
fprintf('\n The MSE value for Q=50 is %0.4f', mse2);
fprintf('\n The MSE value for Q=90 is %0.4f', mse3);
%Calculating PSNR 
peakval=255;
psnr10=20*log10((peakval^2)./sqrt(mse1));
psnr50=20*log10((peakval^2)./sqrt(mse2));
psnr90=20*log10((peakval^2)./sqrt(mse3));
fprintf('\n The PSNR value for Q=10 is %0.4f', psnr10);
fprintf('\n The PSNR value for Q=50 is %0.4f', psnr50);
fprintf('\n The PSNR value for Q=90 is %0.4f', psnr90);

%%DCT 
function M = DCT_basis(N)
for k = 0:N - 1
    for n = 0:N - 1
        if k == 0
            M(k+1,n+1) = 1/sqrt(N);
        else
            M(k+1,n+1) = sqrt(2/N)*cos(pi*(2*n + 1)*k/(2*N));
        end
    end
    out = M;
    %figure(4)
    %basisImg = ind2rgb(im2uint8(k),'copper');
    %filename = strcat(num2str(k),num2str(k),'.png');
    %imwrite(imresize(basisImg,[64 64],'nearest'),filename);  
end
end


%%Compression
function y = compression(originalImg,DCT_basis,DCT_quantizer,blocksize)
jpeg_out = originalImg - originalImg;   % zero the matrix for the compressed image

imgSize = size(originalImg);
rows = imgSize(1,1);              
cols = imgSize(1,2);

originalImg=originalImg-128;

for row = 1: blocksize: rows
  for col = 1: blocksize: cols
       % take a block of the image:
    DCT_matrix = originalImg(row: row + blocksize-1, col: col + blocksize-1);
       % perform the transform operation on the 2-D block
     DCT_matrix = DCT_basis * DCT_matrix * DCT_basis';
      DCT_matrix = round(DCT_matrix ...
          ./ (DCT_quantizer(1:blocksize,1:blocksize) ));
      % place it into the compressed-image matrix:
    jpeg_out(row: row + blocksize-1, col: col + blocksize-1) = DCT_matrix;
 
  end
end
y = jpeg_out;
end

%%Decompression
function y = decompression(jpeg_out,DCT_basis,DCT_quantizer,blocksize)
reconstructed = jpeg_out - jpeg_out;
imgSize = size(jpeg_out);
rows = imgSize(1,1);               % finds image's rows and columns
cols = imgSize(1,2);
for row = 1: blocksize: rows
  for col = 1: blocksize: cols
 
       % take a block of the image:
    IDCT = jpeg_out(row: row + blocksize-1, col: col + blocksize-1);
 
       % reconstruct the quantized values:
    IDCT = IDCT ...
                .* (DCT_quantizer(1:blocksize, 1:blocksize) );
 
       % perform the inverse DCT:
    IDCT = DCT_basis' * IDCT * DCT_basis;
 
       % place it into the reconstructed image:
    reconstructed(row: row + blocksize-1, col: col + blocksize-1) = IDCT;
 
  end
  y = reconstructed + 128;
end
end