function [] = splitMerge( I, treshold, minSize, showBorder )

close all;

% Faz resize na imagem para o power of 2 mais próximo
[X, Y, Z] = size(I);
P1 = 2 ^ (nextpow2(max(X, Y)) - 1);
P2 = 2 ^ (nextpow2(max(X, Y))    );
S = P1;
if (abs(P1 - max(X,Y)) > abs(P2 - max(X,Y)))
    S = P2;
end

S
I = imresize(I, [S S]);
figure, imshow(I), title('Imagem Original');
I_gray = rgb2gray(I);
%

pows = fliplr(meshgrid(0:nextpow2(S)-1, 1));
dims = 2 .^ pows;

% Faz a decomposição de quadtree
S = qtdecomp(I_gray, treshold / 255, minSize);

% Checa se deve mostrar bordas
border = 1;
if showBorder
    border = 2;
end

% Representa os blocos
blocks = repmat(uint8(0),size(S));
for i = 1:length(dims)  
    dim = dims(i);
    color = (255 / (length(dims)-1)) * (i - 1);
    numblocks = length(find(S==dim));    
    if (numblocks > 0)       
        values = repmat(uint8(1), [dim dim numblocks]);
        values(border:dim,border:dim,:) = color;
        blocks = qtsetblk(blocks,S,dim,values);
    end
end

figure, imshow(blocks,[]);

end