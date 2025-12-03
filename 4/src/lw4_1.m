% Скрипт для виконання Лабораторної роботи №4 (Варіант 12)
clc; clear; close all;

% --- НАЛАШТУВАННЯ ---
imageFile = 'rock.jpg';
K = 512; % Розмір за варіантом

%% ЗАВДАННЯ 2-3: Вплив розміру блоку (N)
fprintf('\n--- Дослідження розміру блоку (N) ---\n');
Ns = [16, 128];

for i = 1:length(Ns)
    N = Ns(i);
    fprintf('Обробка для N=%d... ', N);
    
    % Виклик функції (без фільтрації P=0, M=0)
    res = jpeg_compress(imageFile, K, N, 0, 0, true);
    
    fprintf('Час: %.4f с, Стиснення: %.2f разів, RMSE: %.2f\n', ...
        res.TimeDCT + res.TimeIDCT, res.RCompress, res.ErrorDCTSKO);
    
    % Збереження графіка
    saveas(gcf, sprintf('task2_N%d.png', N));
    
end

%% ЗАВДАННЯ 4: Вплив порогу (P)
% Примітка: Розмір блоку беремо другий за варіантом -> N = 128
N_task4 = 128;
Ps = [15, 70, 150];
errors_P = [];

fprintf('\n--- Дослідження порогу (P) при N=%d ---\n', N_task4);
fprintf('|  P  | RMSE  | Compr |\n');
fprintf('|-----|-------|-------|\n');

for i = 1:length(Ps)
    P = Ps(i);
    res = jpeg_compress(imageFile, K, N_task4, 0, P, true);
    
    errors_P(end+1) = res.ErrorDCTSKO;
    fprintf('| %3d | %5.2f | %5.2f |\n', P, res.ErrorDCTSKO, res.RCompress);
    
    saveas(gcf, sprintf('task4_P%d.png', P));
    
end

% Побудова графіка залежності похибки від P
figure('Name', 'Залежність похибки від P');
plot(Ps, errors_P, '-bo', 'LineWidth', 2);
grid on;
title(['Залежність RMSE від порогу P (N=' num2str(N_task4) ')']);
xlabel('Поріг (P)'); ylabel('Похибка (RMSE)');
saveas(gcf, 'graph_error_P.png');



%% ЗАВДАННЯ 5: Вплив кількості коефіцієнтів (M)
% Примітка: N = 128
Ms = [10, 40, 50];
errors_M = [];

fprintf('\n--- Дослідження зональної фільтрації (M) при N=%d ---\n', N_task4);
fprintf('|  M  | RMSE  | Compr |\n');
fprintf('|-----|-------|-------|\n');

for i = 1:length(Ms)
    M = Ms(i);
    res = jpeg_compress(imageFile, K, N_task4, M, 0, true);
    
    errors_M(end+1) = res.ErrorDCTSKO;
    fprintf('| %3d | %5.2f | %5.2f |\n', M, res.ErrorDCTSKO, res.RCompress);
    
    saveas(gcf, sprintf('task5_M%d.png', M));
    
end

% Побудова графіка залежності похибки від M
figure('Name', 'Залежність похибки від M');
plot(Ms, errors_M, '-ro', 'LineWidth', 2);
grid on;
title(['Залежність RMSE від параметра M (N=' num2str(N_task4) ')']);
xlabel('Параметр M'); ylabel('Похибка (RMSE)');
saveas(gcf, 'graph_error_M.png');

fprintf('\nРоботу завершено! Графіки збережено у поточній папці.\n');