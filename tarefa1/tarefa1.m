
% Arquivo de chamada
% Imagem 1
imagem1 = imread('umbrela.jpg');
imagem1 = rgb2gray(imagem1);

saida1_1 = JPEG_compression_cos(imagem1, 3);
saida1_2 = JPEG_compression_cos(imagem1, 6);
saida1_3 = JPEG_compression_cos(imagem1, 10);

[SNR1, PSNR1] = snr_psnr(double(imagem1), saida1_1);
[SNR2, PSNR2] = snr_psnr(double(imagem1), saida1_2);
[SNR3, PSNR3] = snr_psnr(double(imagem1), saida1_3);

subplot(2,2,1), imshow(uint8(imagem1 )), title(sprintf('original'));
subplot(2,2,2), imshow(uint8(saida1_1)), title(sprintf('comp 3 SNR:%.2f PSNR:%.2f',  SNR1, PSNR1));
subplot(2,2,3), imshow(uint8(saida1_2)), title(sprintf('comp 5 SNR:%.2f PSNR:%.2f',  SNR2, PSNR2));
subplot(2,2,4), imshow(uint8(saida1_3)), title(sprintf('comp 10 SNR:%.2f PSNR:%.2f', SNR3, PSNR3));
imwrite(uint8(imagem1), sprintf('./saida/entrada_original.jpg', 'jpg'));

% Imagem 2
%imagem2 = imread('office_5.jpg');
%imagem2 = rgb2gray(imagem2);

%saida2_1 = JPEG_compression_cos(imagem2, 3);
%saida2_2 = JPEG_compression_cos(imagem2, 6);
%saida2_3 = JPEG_compression_cos(imagem2, 10);

%[SNR1, PSNR1] = snr_psnr(double(imagem2), saida2_1);
%[SNR2, PSNR2] = snr_psnr(double(imagem2), saida2_2);
%[SNR3, PSNR3] = snr_psnr(double(imagem2), saida2_3);