img = imread('rock.jpg');

I =  im2double(rgb2gray(img));
level = graythresh(I); % Автоматичне визначення порогу методом Отсу
BW = imbinarize(I, level);

f = figure;
subplot(1,3,1), imshow(img), title('Оригінал ');
subplot(1,3,2), imshow(I), title('Відтінки сірого');
subplot(1,3,3), imshow(BW), title(['Бінаризація, поріг = ', num2str(level)]);

exportgraphics(f, [mfilename('fullpath') '.png'], 'Resolution', 300);
