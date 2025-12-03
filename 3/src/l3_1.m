img = imread('kamen1.jpg');

% Перетворення у відтінки сірого, якщо потрібно
if size(img, 3) == 3
    gray_img = rgb2gray(img);
else
    gray_img = img;
end

% Бінаризація
level = graythresh(gray_img);
bw = imbinarize(gray_img, level);

% Створення структурного елемента: дві крапки, зміщення [0 3]
% Другий аргумент для 'pair' - це вектор зміщення [рядки, стовпці]
se = strel('pair', [0 3]);

% Виконання ерозії
bw_eroded = imerode(bw, se);

% Виконання дилатації
bw_dilated = imdilate(bw, se);

% Відображення результатів
figure('Name', 'Завдання 1 та 2', 'NumberTitle', 'off');

subplot(1, 3, 1);
imshow(bw);
title('Оригінал (бінарний)');

subplot(1, 3, 2);
imshow(bw_eroded);
title('Ерозія (pair [0 3])');

subplot(1, 3, 3);
imshow(bw_dilated);
title('Дилатація (pair [0 3])');

print(gcf, [mfilename('fullpath') '.png'], '-dpng', '-r300');