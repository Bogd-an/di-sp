function res = jpeg_compress(imageFile, K, N, M, P, showPlots)
% ВХІДНІ ПАРАМЕТРИ:
%   imageFile - (string/char) Шлях до файлу або матриця зображення.
%   K         - (int) Розмір зображення (KxK).
%   N         - (int) Розмір блоку ДКП (NxN).
%   M         - (int) Зональна фільтрація (розмір квадрата MxM), 0 - вимк.
%   P         - (int) Порогова фільтрація (значення порогу), 0 - вимк.
%   showPlots - (bool) true/false. Чи будувати графіки.
%
% ВИХІДНІ ДАНІ (структура res):
%   res.MeanError   - Середня абсолютна похибка.
%   res.ErrorDCTSKO - Середньоквадратична похибка (RMSE).
%   res.MaxError    - Максимальна похибка.
%   res.RCompress   - Коефіцієнт стиснення.
%   res.TimeDCT     - Час виконання прямого ДКП (сек).
%   res.TimeIDCT    - Час виконання оберненого ДКП (сек).
%   res.Settings    - Структура з параметрами, з якими запускалась функція (K, N, M, P).
%   res.OrigImage       - Оригінальне зображення.
%   res.CoefDCT         - Спектр ДКП.
%   res.CoefDCTCompress - Стиснений спектр.
%   res.RestoreImage    - Відновлене зображення.

    % --- 1. ПІДГОТОВКА ЗОБРАЖЕННЯ ---
    if ischar(imageFile) || isstring(imageFile)
        RGB = imread(imageFile);
    else
        RGB = imageFile;
    end

    if size(RGB, 3) == 3
        II = rgb2gray(RGB);
    else
        II = RGB;
    end
    
    II = imresize(II, [K, K]);
    OrigImage = double(II);

    % --- 2. ОБЧИСЛЕННЯ ДКП (Пряме) ---
    t_start = tic;
    
    T = dctmtx(N);
    dct_func = @(block_struct) T * block_struct.data * T';
    CoefDCT = blockproc(OrigImage, [N N], dct_func);
    
    t_dct = toc(t_start);

    % --- 3. СТИСНЕННЯ ---
    CoefDCTCompress = CoefDCT;

    % Метод 1: Порогова обробка (P)
    if P > 0
        CoefDCTCompress(abs(CoefDCTCompress) < P) = 0;
    end

    % Метод 2: Зональна фільтрація (M)
    if M > 0 && M < N
        blockMask = zeros(N, N);
        blockMask(1:M, 1:M) = 1;
        fullMask = repmat(blockMask, K/N, K/N);
        CoefDCTCompress = CoefDCTCompress .* fullMask;
    end

    % --- 4. ВІДНОВЛЕННЯ (Обернене) ---
    t_start = tic;
    
    idct_func = @(block_struct) T' * block_struct.data * T;
    RestoreImageRaw = blockproc(CoefDCTCompress, [N N], idct_func);
    RestoreImage = max(0, min(255, RestoreImageRaw));
    
    t_idct = toc(t_start);

    % --- 5. РОЗРАХУНОК МЕТРИК ---
    ErrorDCTArray = abs(RestoreImage - OrigImage);
    
    nonZero = nnz(CoefDCTCompress);
    if nonZero == 0
        RCompress = Inf;
    else
        RCompress = numel(CoefDCTCompress) / nonZero;
    end

    % --- 6. ФОРМУВАННЯ РЕЗУЛЬТАТУ ---
    res.MeanError = mean(ErrorDCTArray(:));
    res.ErrorDCTSKO = sqrt(mean(ErrorDCTArray(:).^2));
    res.MaxError = max(ErrorDCTArray(:));
    res.RCompress = RCompress;
    
    res.TimeDCT = t_dct;
    res.TimeIDCT = t_idct;
    
    % Зберігаємо вхідні налаштування для зручності аналізу
    res.SettingsK = K;
    res.SettingsN = N;
    res.SettingsM = M;
    res.SettingsP = P;

    % Зберігаємо матриці (закоментуйте, якщо економите пам'ять)
    res.OrigImage = OrigImage;
    res.CoefDCT = CoefDCT;
    res.CoefDCTCompress = CoefDCTCompress;
    res.RestoreImage = RestoreImage;

    % --- 7. ВІЗУАЛІЗАЦІЯ (Тільки якщо showPlots = true) ---
    if showPlots
        figure('Name', 'Результати стиснення JPEG', 'NumberTitle', 'off');
        colormap(gray(256));
        
        subplot(2,2,1); 
        imshow(uint8(OrigImage)); 
        title('Оригінал');
        
        subplot(2,2,2); 
        imshow(log(abs(CoefDCT)+1), []); 
        title('Спектр ДКП (log)'); colorbar;
        
        subplot(2,2,3); 
        imshow(uint8(RestoreImage)); 
        title(['Відновлене (RMSE: ' num2str(res.ErrorDCTSKO, '%.2f') ')']);
        
        subplot(2,2,4); 
        imshow(log(abs(CoefDCTCompress)+1), []); 
        title(['Стиснений спектр (Cr: ' num2str(res.RCompress, '%.1f') ')']); colorbar;
    end
end