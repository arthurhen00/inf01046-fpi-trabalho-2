function quantizacao_colorida()
   % Parâmetros
    block_size = 2;
    dictionary_size = 128;
    
    input_image = imread('tape.png');
    input_image = double(input_image);

    [num_rows, num_cols, num_channels] = size(input_image);
    num_blocks_rows = floor(num_rows / block_size);
    num_blocks_cols = floor(num_cols / block_size);

    % Organiza todos os blocos da imagem em uma matriz
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

    % Executa K-means para agrupar os blocos
    [cluster_indices, dictionary] = kmeans_algorithm(all_blocks', dictionary_size, 5);

    % Redimensiona o dicionário para a forma de blocos
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
    figure,imshow(uint8(input_image));
    title('Imagem de Entrada');

    figure,imshow(uint8(output_image));
    title('Imagem Quantizada');
    
    [SNR,PSNR] = calcula_SNR_PSNR(input_image, output_image);
    
    L = block_size*block_size;
    
    fprintf('Tamanho da memoria da imagem de entrada = %d bytes\n',numel(input_image));
    disp('');
    fprintf('Tamanho da memoria da imagem de saida %d bytes\n', dictionary_size*L+numel(output_image)/L);
    disp('');
    
    fprintf('Taxa de compressão (bits de entrada x bits de saida): %.2f x %d\n',double(numel(input_image))/double(dictionary_size*L+numel(output_image)/L),1);
    disp('');
    
    fprintf('SNR = %.2f (dB)\n',SNR);
    disp('')
    fprintf('PSNR = %.2f (dB)\n',PSNR);
    disp('')
    
    
end