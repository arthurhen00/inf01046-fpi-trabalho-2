function img1 = quantizacao_c_kmeans(img)

    tic;
    
    L = 64;
    K = 128;

    img2d_rows = size(img,1);
    img2d_cols = size(img,2);
    %figure, imshow(img)
    %title('imagem de entrada')
    
    
    r1 = floor(rem(img2d_rows,sqrt(L)));
    r2 = floor(rem(img2d_cols,sqrt(L)));
    img1 = zeros(img2d_rows+r1,img2d_cols+r2);
    
    img1(1:img2d_rows,1:img2d_cols) = img;
    
    if r1 ~= 0
      pad_rows = img(end,:);
      for j = 1:r1
          pad_rows(j,:) = pad_rows(1,:);
      end
      img1(1:img2d_rows,1:img2d_cols) = img;
      img1(img2d_rows+1:end,1:img2d_cols) = pad_rows;
    end
    if r1~= 0 && r2~= 0
       pad_cols = img1(:,img2d_cols);
      for j = 1:r2
          pad_cols(:,j) =  pad_cols(:,1);
      end
      img1(1:end,img2d_cols+1:end) = pad_cols;
    elseif r2~= 0
        pad_cols = img(:,img2d_cols);
        for j=1:sqrt(L)-r2
            pad_cols(:,j)=pad_cols(:,1);
        end

        img1(1:img2d_rows,1:img2d_cols) = img;
        img1(1:img2d_rows,img2d_cols+1:end)= pad_cols;
    end
    
    I_re = Kmeans_Pre_Post(img1,L,K);
    
    I_re = uint8(I_re);
    
    %figure, imshow(I_re);
    %title('imagem comprimida por quantização vetorial (kmeans)')
    
    fprintf('tamanho da memoria da imagem de entrada = %d bytes\n',numel(img));
    disp('');
    fprintf('tamanho da memoria da imagem de saida %d bytes\n', K*L+numel(img1)/L);
    disp('');
    
    fprintf('taxa de compressão (bits de entrada x bits de saida): %.2f x %d\n',double(numel(img))/double(K*L+numel(img1)/L),1);
    disp('');
    
    SNR=10*log10(std2(double(img))^2/std2(double(img)-double(I_re))^2);
    
    I_max = max(max(double(img)));
    I_min = min(min(double(img)));
    
    A = (I_max- I_min);
    PSNR = 10*log10((A^2)/(std2(double(img)-double(I_re))^2));
    
    fprintf('SNR = %.2f (dB)\n',SNR);
    disp('')
    fprintf('PSNR = %.2f (dB)\n',PSNR);
    disp('')
    
    toc;
    

end
