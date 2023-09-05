function saida = JPEG_compression_cos(gray_image, compressao)

    % Parte básica do JPEG (DCT e quantização)
    % Divisão da imagem em blocos, 8x8 ou 16x16
    % Transformada de cosseno discreta DCT
    % Quantizacao
    % 

    clc;
    close all;

    % Imagens
    imagem = gray_image;
    [altura, largura] = size(imagem);

    % Tamanho do bloco
    tam_bloco = 8;

    % Calcular as novas dimensões para serem múltiplas de tamanho_bloco
    nova_altura = ceil(altura / tam_bloco) * tam_bloco;
    nova_largura = ceil(largura / tam_bloco) * tam_bloco;

    imagem = imresize(imagem, [nova_altura, nova_largura]);

    % Matriz para guardar a DCT
    DCT = zeros(altura, largura);
    
    
    % ******************************************************************
    % COMP
    % Aplicar a DCT em blocos 8x8 (transformada do cosseno)
    for i = 1:nova_altura/tam_bloco
        for j = 1:nova_largura/tam_bloco
            y_inicio = (i - 1) * tam_bloco + 1;
            y_fim = y_inicio + tam_bloco - 1;
            y_fim = min(y_fim, nova_altura); % Limitar y_fim às dimensões da imagem
            
            x_inicio = (j - 1) * tam_bloco + 1;
            x_fim = x_inicio + tam_bloco - 1;
            x_fim = min(x_fim, nova_largura); % Limitar x_fim às dimensões da imagem
            
            bloco = double(imagem(y_inicio:y_fim, x_inicio:x_fim));
            dct_bloco = dct2(bloco);
            DCT(y_inicio:y_fim, x_inicio:x_fim) = dct_bloco;
        end
    end
    
    % ******************************************************************
    %
    % Matriz de quantização
    matriz_quantizacao = [
                    16 11 10 16  24  40  51  61;
                    12 12 14 19  26  58  60  55;
                    14 13 16 24  40  57  69  56;
                    14 17 22 29  51  87  80  62;
                    18 22 37 56  68 109 103  77;
                    24 35 55 64  81 104 113  92;
                    49 64 78 87 103 121 120 101;
                    72 92 95 98 112 100 103  99;];

    matriz_quantizacao = matriz_quantizacao * compressao;

    % limita o intervalo [1, 255]
    for i=1:8
        for j=1:8
            matriz_quantizacao(i, j) = min(matriz_quantizacao(i, j), 255);
            matriz_quantizacao(i, j) = max(matriz_quantizacao(i, j), 1);
        end
    end

    % Inicializar a matriz para armazenar os coeficientes quantizados
    coeficientes_quantizados = zeros(nova_altura, nova_largura);

    % Aplicar a quantização aos coeficientes DCT
    for i = 1:nova_altura/tam_bloco
        for j = 1:nova_largura/tam_bloco
            y_inicio = (i - 1) * tam_bloco + 1;
            y_fim = y_inicio + tam_bloco - 1;
            
            x_inicio = (j - 1) * tam_bloco + 1;
            x_fim = x_inicio + tam_bloco - 1;
            
            dct_bloco = DCT(y_inicio:y_fim, x_inicio:x_fim);
            quantizacao_bloco = round(dct_bloco ./ matriz_quantizacao); % Aplicar quantização
            
            coeficientes_quantizados(y_inicio:y_fim, x_inicio:x_fim) = quantizacao_bloco;
        end
    end

    % ******************************************************************
    % DEC
    % Inicializar a matriz para armazenar os coeficientes inversos da DCT
    coeficientes_idct = zeros(nova_altura, nova_largura);
    
    % Aplicar a inversa da DCT e inversa da quantização
    for i = 1:nova_altura/tam_bloco
        for j = 1:nova_largura/tam_bloco
            y_inicio = (i - 1) * tam_bloco + 1;
            y_fim = y_inicio + tam_bloco - 1;
            
            x_inicio = (j - 1) * tam_bloco + 1;
            x_fim = x_inicio + tam_bloco - 1;
            
            quantizacao_bloco = coeficientes_quantizados(y_inicio:y_fim, x_inicio:x_fim);
            idct_bloco = quantizacao_bloco .* matriz_quantizacao; % Inversa da quantização
            
            idct_bloco = idct2(idct_bloco); % Inversa da DCT
            
            coeficientes_idct(y_inicio:y_fim, x_inicio:x_fim) = idct_bloco;
        end
    end

    imwrite(uint8(coeficientes_idct), sprintf('./saida/saida_%d.jpg', compressao), 'jpg');

    parte_selecionada = coeficientes_idct(1:altura, 1:largura);

    saida = parte_selecionada;

end