function quantizacao_colorida()
   % Parâmetros
    block_size = 2;
    dictionary_size = 256;
    num_channels = 3;

    % Carregue a imagem de entrada
    input_image = imread('peppers.png');
    input_image = double(input_image);

    % Divida a imagem em blocos
    [num_rows, num_cols, ~] = size(input_image);
    num_blocks_rows = floor(num_rows / block_size);
    num_blocks_cols = floor(num_cols / block_size);

    % Organize todos os blocos da imagem em uma matriz
    all_blocks = zeros(block_size * block_size * num_channels, num_blocks_rows * num_blocks_cols);
    block_idx = 1;
    for r = 1:num_blocks_rows
        for c = 1:num_blocks_cols
            block = input_image((r - 1) * block_size + 1 : r * block_size, ...
                                (c - 1) * block_size + 1 : c * block_size, :);
            all_blocks(:, block_idx) = block(:);
            block_idx = block_idx + 1;
        end
    end

    % Executar K-means para agrupar os blocos
    [cluster_indices, dictionary] = kmeans_algorithm(all_blocks', dictionary_size, 5);

    % Redimensionar o dicionário para a forma de blocos
    dictionary_blocks = reshape(dictionary', block_size, block_size, num_channels, []);

    % Quantização vetorial
    output_image = zeros(num_rows, num_cols, num_channels);
    block_idx = 1;
    for r = 1:num_blocks_rows
        for c = 1:num_blocks_cols
            quantized_block = dictionary_blocks(:, :, :, cluster_indices(block_idx));
            output_image((r - 1) * block_size + 1 : r * block_size, ...
                         (c - 1) * block_size + 1 : c * block_size, :) = quantized_block;
            block_idx = block_idx + 1;
        end
    end

    % Exiba a imagem de entrada e a imagem de saída lado a lado
    figure;
    subplot(1, 2, 1);
    imshow(uint8(input_image));
    title('Imagem de Entrada');

    subplot(1, 2, 2);
    imshow(uint8(output_image));
    title('Imagem Quantizada');
end