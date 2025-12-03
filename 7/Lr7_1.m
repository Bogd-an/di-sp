L=imread('halloween.png');
J = imresize(L, [200 200]);
H=imcrop(L,[200 300 300 200]);
G=imrotate(L,410,'bicubic');
figure,imshow(L);
figure,imshow(J);
figure,imshow(H);
figure,imshow(G)
