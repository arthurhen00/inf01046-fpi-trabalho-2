function [SNR, PSNR] = snr_psnr(original, saida)

    i_max = max(max(original));
    i_min = min(min(original));
    A = (i_max - i_min);
    SNR = 10*log10(std2(original)^2/std2(original - saida)^2);
    PSNR = 10*log10((A^2)/(std2(original-saida)^2));

end