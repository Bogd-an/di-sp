
CIR = multibandread('paris.lan', [512, 512, 7], ...
    'uint8=>uint8', 128, 'bil', 'ieee-le', ...
    {'Band', 'Direct', [4 3 1]});

% --- 2. ПОПЕРЕДНЯ ОБРОБКА ---
% Декорреляційне розтягування для покращення кольорового сприйняття
decorrCIR = decorrstretch(CIR, 'Tol', 0.01);

% Виділення окремих каналів для аналізу
% NIR (Near Infrared) - Банд 4
NIR = im2single(CIR(:,:,1)); 
% Visible (Vis) - Банд 3 (використовуємо як опорний видимий канал)
Vis = im2single(CIR(:,:,2)); 

% --- 3. РОЗРАХУНОК СПЕКТРАЛЬНОГО ІНДЕКСУ ---
% Нормалізований різницевий індекс
% (NIR - Vis) / (NIR + Vis)
% Цей індекс дозволяє розділити воду/асфальт (темні) та рослинність (світлі)
index_img = (NIR - Vis) ./ (NIR + Vis);

% --- 4. ПОРОГОВА ОБРОБКА (ЛОКАЛІЗАЦІЯ ШЛЯХІВ) ---
% Експериментальний поріг для виділення шляхів та води
threshold = -0.1; 
binary_mask = (index_img > threshold); 

% --- 5. ВІЗУАЛІЗАЦІЯ ---
f = figure('Name', 'Lab 8: Remote Sensing - Paths Detection', ...
    'Position', [50, 50, 1200, 600], 'NumberTitle', 'off');

% 1. Композитне зображення (покращене)
subplot(2, 3, 1); imshow(decorrCIR); title('Composite (DecorrStretch)');

% 2. Видимий канал
subplot(2, 3, 2); imshow(Vis); title('Visible Band');

% 3. Інфрачервоний канал
subplot(2, 3, 3); imshow(NIR); title('NIR Band');

% 4. Scatter Plot (Діаграма розсіювання)
subplot(2, 3, 4);
plot(Vis(:), NIR(:), '+b', 'MarkerSize', 2); hold on;
% Виділяємо знайдені пікселі іншим кольором
plot(Vis(binary_mask), NIR(binary_mask), 'g+', 'MarkerSize', 2);
xlabel('Visible Level'); ylabel('NIR Level');
axis square; axis([0 1 0 1]);
title('Scatter Plot (Vis vs NIR)');

% 5. Індексне зображення
subplot(2, 3, 5); imshow(index_img, 'DisplayRange', [-1 1]); title('Spectral Index (NDVI-like)');
colorbar;

% 6. Результат сегментації (Маска)
subplot(2, 3, 6); imshow(binary_mask); title(['Threshold > ', num2str(threshold)]);

% Збереження результату
exportgraphics(f, [mfilename('fullpath') '_result.png'], 'Resolution', 300);
fprintf('Обробку завершено. Результат збережено.\n');