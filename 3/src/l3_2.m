img_text = imread('TextRoman.bmp');

% Бінаризація (інвертуємо, якщо текст чорний на білому)
bw_text = ~imbinarize(img_text); 

% Структурний елемент - диск.
se_disk = strel('disk', 4);

% Відкриття: залишаються тільки об'єкти, де вміщується диск
bw_open = imopen(bw_text, se_disk);

% Реконструкція: відновлюємо повні літери за знайденими маркерами
bw_reconstructed = imreconstruct(bw_open, bw_text);

figure('Name', 'Завдання 3', 'NumberTitle', 'off');

subplot(1, 3, 1);
imshow(bw_text);
title('Оригінальний текст');

subplot(1, 3, 2);
imshow(bw_open);
title('Після відкриття (Disk)');

subplot(1, 3, 3);
imshow(bw_reconstructed);
title('Знайдені літери');

print(gcf, [mfilename('fullpath') '.png'], '-dpng', '-r300');