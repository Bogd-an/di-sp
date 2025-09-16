[img, color_map] = imread('kamen.bmp');
I = im2double(ind2gray(img, color_map));

level = 0.2;
BW = I > level; % бінаризація

f = figure;
subplot(1,3,1), imshow(img, color_map), title('Оригінал');
subplot(1,3,2), imshow(I), title('Відтінки сірого');
subplot(1,3,3), imshow(BW), title(['Бінаризація, поріг = ', num2str(level)]);

exportgraphics(f, [mfilename('fullpath') '.png'], 'Resolution', 300);

