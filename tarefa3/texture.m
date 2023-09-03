function [] = texture( I, filter_size, theta, nTries )

I_gray = double(I);
I_size = size(I_gray);
degree = 0:theta:360;

for k = 1:length(degree)
    % Pega o filtro de gabor
    filter = gb(filter_size, 8, degree(k), 4);
    
    % Convolução com a imagem original
    for j = 1:I_size(2) - filter_size
        for i = 1:I_size(1) - filter_size
            filtered(i,j) = mean(mean(filter .* I_gray(i:i+filter_size-1, j:j+filter_size-1)));
        end
    end

    groups{k} = filtered;
end

% ?????????????
[idx, center] = kmeans(groups{1}, 2, 'distance', 'sqEuclidean', 'Replicates', nTries);
