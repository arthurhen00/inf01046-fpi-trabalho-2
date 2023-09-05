function quantizacao()
    % Parâmetros
    block_size = 2;
    dictionary_size = 32;

    % Carregue a imagem de entrada em tons de cinza
    input_image = imread('kids.tif');
    input_image = double(input_image);

    % Divida a imagem em blocos
    [num_rows, num_cols] = size(input_image);
    num_blocks_rows = floor(num_rows / block_size);
    num_blocks_cols = floor(num_cols / block_size);

    % Organize todos os blocos da imagem em uma matriz
    all_blocks = zeros(block_size * block_size, num_blocks_rows * num_blocks_cols);
    block_idx = 1;
    for r = 1:num_blocks_rows
        for c = 1:num_blocks_cols
            block = input_image((r - 1) * block_size + 1 : r * block_size, ...
                                (c - 1) * block_size + 1 : c * block_size);
            all_blocks(:, block_idx) = block(:);
            block_idx = block_idx + 1;
        end
    end

    % Executar K-means para agrupar os blocos
    [cluster_indices, dictionary] = kmeans_algorithm(all_blocks', dictionary_size, 5);

    % Redimensionar o dicionário para a forma de blocos
    dictionary_blocks = reshape(dictionary', block_size, block_size, []);

    % Quantização vetorial
    output_image = zeros(num_rows, num_cols);
    block_idx = 1;
    for r = 1:num_blocks_rows
        for c = 1:num_blocks_cols
            quantized_block = dictionary_blocks(:, :, cluster_indices(block_idx));
            output_image((r - 1) * block_size + 1 : r * block_size, ...
                         (c - 1) * block_size + 1 : c * block_size) = quantized_block;
            block_idx = block_idx + 1;
        end
    end

    % Exiba a imagem de entrada e a imagem de saída lado a lado
    figure,imshow(uint8(input_image), []);
    title('Imagem de Entrada');


    figure,imshow(uint8(output_image), []);
    title('Imagem Quantizada');
    
    
    L = block_size*block_size;
    
    fprintf('tamanho da memoria da imagem de entrada = %d bytes\n',numel(input_image));
    disp('');
    fprintf('tamanho da memoria da imagem de saida %d bytes\n', dictionary_size*L+numel(output_image)/L);
    disp('');
    
    fprintf('taxa de compressão (bits de entrada x bits de saida): %.2f x %d\n',double(numel(input_image))/double(dictionary_size*L+numel(output_image)/L),1);
    disp('');
    
    SNR=10*log10(std2(double(input_image))^2/std2(double(input_image)-double(output_image))^2);
    
    I_max = max(max(double(input_image)));
    I_min = min(min(double(input_image)));
    
    A = (I_max- I_min);
    PSNR = 10*log10((A^2)/(std2(double(input_image)-double(output_image))^2));
    
    fprintf('SNR = %.2f (dB)\n',SNR);
    disp('')
    fprintf('PSNR = %.2f (dB)\n',PSNR);
    disp('')
    
    
    imwrite(output_image,'saida.tif','tif');
    
end
