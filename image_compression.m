I = imread('image1.jpg');
% I= imresize(I,[1024 1024]);
% imwrite(I,'YenidenBoyutlandýrýlmýþ.jpg');
R_C= im2double(I(:,:,1));
G_C= im2double(I(:,:,2));
B_C= im2double(I(:,:,3));

T = dctmtx(8);
dct = @(block_struct) T * block_struct.data * T';

R_C_B = blockproc(R_C,[8 8],dct);
G_C_B = blockproc(G_C,[8 8],dct);
B_C_B = blockproc(B_C,[8 8],dct);


mask = [1   1   1   1   0   0   0   0
        1   1   1   0   0   0   0   0
        1   1   0   0   0   0   0   0
        1   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0];
    
R_C_B2 = blockproc(R_C_B,[8 8],@(block_struct) mask .* block_struct.data);
G_C_B2 = blockproc(G_C_B,[8 8],@(block_struct) mask .* block_struct.data);
B_C_B2 = blockproc(B_C_B,[8 8],@(block_struct) mask .* block_struct.data);

invdct = @(block_struct) T' * block_struct.data * T;
R_I2 = blockproc(R_C_B2,[8 8],invdct);
G_I2 = blockproc(G_C_B2,[8 8],invdct);
B_I2 = blockproc(B_C_B2,[8 8],invdct);

Compress= cat(3,R_I2,G_I2,B_I2);

% figure, imshow(Compress);

r=medfilt2(Compress(:,:,1),[5,5]);
g=medfilt2(Compress(:,:,2),[5,5]);
b=medfilt2(Compress(:,:,3),[5,5]);

k=cat(3,r,g,b);
% figure,imshow(k);

subplot(2,3,1); imshow(I); title('Orjinal Görüntü');
subplot(2,3,4); imhist(I);title('Orjinal Histogram');
subplot(2,3,2); imshow(Compress); title('Sýkýþtýrýlmýþ Görüntü');
subplot(2,3,5); imhist(Compress);title('Sýkýþtýrýlmýþ Histogram');
subplot(2,3,3); imshow(k); title('Medyan Filtre Görüntü');
subplot(2,3,6); imhist(k);title('Medyan Filtre Histogram');

imwrite(Compress,'Sýkýþtýrýlmýþ1.jpg');

