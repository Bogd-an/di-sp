img_agg = imread('agglut.jpg');

% Конвертація та бінаризація
if size(img_agg, 3) == 3
    img_agg = rgb2gray(img_agg);
end
level_agg = graythresh(img_agg);
bw_agg = im2bw(img_agg, level_agg);

% Кількість ітерацій ерозії підбирається, поки об'єкти не розлипнуться
n_iter = 10; 
bw_eroded_agg = bwmorph(bw_agg, 'erode', n_iter);

% "Потовщення" (thicken) для знаходження ліній розділу (skeleton of background)
bw_thick = bwmorph(bw_eroded_agg, 'thicken', inf);

% Розділення об'єктів: логічне AND початкового та потовщеного (розділового)
bw_separated = bw_agg & bw_thick; % Або (~bw_thick) залежно від полярності

figure('Name', 'Завдання 4', 'NumberTitle', 'off');

subplot(2, 2, 1);
imshow(bw_agg);
title('Злиплі об''єкти');

subplot(2, 2, 2);
imshow(bw_eroded_agg);
title(['Ерозія (', num2str(n_iter), ' ітерацій)']);

subplot(2, 2, 3);
imshow(bw_thick);
title('Thicken (лінії розділу)');

subplot(2, 2, 4);
imshow(bw_separated);
title('Результат розділення');

print(gcf, [mfilename('fullpath') '.png'], '-dpng', '-r300');