function [] = texture( I, filter_size, theta, nTries )

close all;

I_gray = double(I);
nGroups = 4;
numRows = size(I_gray, 1) - filter_size;
numCols = size(I_gray, 2) - filter_size;
degree = 0:theta:360 - theta;

% Filtragem usando os filtros de gabor
for k = 1:length(degree)
    % Pega o filtro de gabor
    filter = gb(filter_size, 8, degree(k), 4);
    
    % Convolução com a imagem original
    for j = 1:numCols
        for i = 1:numRows
            filtered(i,j) = mean(mean(filter .* I_gray(i:i+filter_size-1, j:j+filter_size-1)));
        end
    end

    groups(:,:,k) = filtered;
end

% Adiciona informação espacial
X = 1:numCols;
Y = 1:numRows;
[X,Y] = meshgrid(X,Y);
groups = cat(3, cat(3,groups,X), Y);

% Reshape pro formato do kmeans
X = reshape(groups, numRows * numCols, []);
X = bsxfun(@minus,   X, mean(X));
X = bsxfun(@rdivide, X,  std(X));

coeff = pca(X);
feature2DImage = reshape(X*coeff(:,1), numRows, numCols);
figure, imshow(feature2DImage,[]), title('Features');

% Faz o kmeans
[idx, center] = kmeans(X, nGroups, 'distance', 'sqEuclidean', 'Replicates', nTries);
pixel_labels = reshape(idx, numRows, numCols);

% Rotula os pixels usando os resultados do k-means
figure, imshow(pixel_labels, []), title('Imagem rotulada');