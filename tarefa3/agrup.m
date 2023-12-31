function [] = agrup( I, nColors, nTries)

figure, imshow(I), title('Imagem Original');

% Converte a imagem para LAB
cform = makecform('srgb2lab');
lab_I = applycform(I, cform);

% Agrupa as cores em AB usando k-means
ab = double(lab_I(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

% Repete o processo de agrupamento N vezes para evitar minimos locais
[idx, center] = kmeans(ab,nColors, 'distance', 'sqEuclidean', 'Replicates', nTries);
pixel_labels = reshape(idx, nrows, ncols);

% Rotula os pixels usando os resultados do k-means
figure, imshow(pixel_labels, []), title('Imagem rotulada');

% Cria uma imagem para cada cor da imagem de entrada
rgb_label = repmat(pixel_labels, [1 1 3]);

for k = 1:nColors
    color = I;
    color(rgb_label ~= k) = 0;
    figure, imshow(color), title(sprintf('Grupo %d', k));
end

end

