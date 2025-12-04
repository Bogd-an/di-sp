orig_img = imread('saturn.tif');
method = 'Prewitt';       % Метод виділення контурів
noise_type = 'speckle';   % Тип шуму
noise_var = 0.02;         % Дисперсія шуму

if ndims(orig_img) == 3
    orig_img = rgb2gray(orig_img);
end
I = im2double(orig_img);

% --- 2. ЕТАП 1: ПОЧАТКОВЕ ЗОБРАЖЕННЯ ---
% Виділення контурів на оригіналі
% Використовуємо автоматичний поріг (другий вихідний аргумент thresh)
[BW_orig, thresh] = edge(I, method); 
cnt_orig = nnz(BW_orig); % Кількість білих пікселів (контурів)

% --- 3. ЕТАП 2: ЗАШУМЛЕНЕ ЗОБРАЖЕННЯ ---
noisy_I = imnoise(I, noise_type, noise_var);
BW_noisy = edge(noisy_I, method); % Той самий метод
cnt_noisy = nnz(BW_noisy);

% --- 4. ЕТАП 3: ВІДНОВЛЕНЕ ЗОБРАЖЕННЯ ---
restored_I = medfilt2(noisy_I, [3 3]); 
BW_restored = edge(restored_I, method);
cnt_restored = nnz(BW_restored);

% --- 5. ВІЗУАЛІЗАЦІЯ ---
% Формування тексту статистики
statsStr = sprintf(['Method: %s\n' ...
    'Original Edges:\t%d px\n' ...
    'Noisy Edges:\t%d px\n' ...
    'Restored Edges:\t%d px'], ...
    method, cnt_orig, cnt_noisy, cnt_restored);

f = figure('Name', 'Lab 6: Edge Detection Analysis', 'NumberTitle', 'off');
set(f, 'Position', [100, 100, 1200, 350]);

splt(0, [], statsStr);
splt(1, BW_orig, 'Оригінал (Контури)');
splt(2, BW_noisy, ['Шум ' noise_type ' (Контури)']);
splt(3, BW_restored, 'Відновлене (Контури)');

exportgraphics(f, [mfilename('fullpath') '_result.png'], 'Resolution', 300);
close(f);
% --- ДОПОМІЖНА ФУНКЦІЯ ---
function splt(inx, I, txt_str)
    subplot(1, 4, inx+1); imshow(I);  title(txt_str);
end