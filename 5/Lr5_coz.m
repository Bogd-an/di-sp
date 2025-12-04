% ЛАБОРАТОРНА РОБОТА №5
% ДОСЛІДЖЕННЯ МЕТОДІВ ФІЛЬТРАЦІЇ ШУМІВ НА ЦИФРОВИХ 
% ВІДЕОЗОБРАЖЕННЯХ В ІНТЕЛЕКТУАЛЬНИХ СИСТЕМАХ
% ВВЕДЕННЯ ПОЧАТКОВИХ ДАНИХ
ImageName='e:\coz\lr1\saturn.tif'; % ІМ"Я ФАЙЛА ЗОБРАЖЕННЯ
% ВИЗНАЧЕННЯ ШУМУ
Tsh='gaussian'; % ТИП ШУМУ НА ЗОБРАЖЕННІ
% 'gaussian' - "БІЛИЙ" ШУМ З НОРМАЛЬНИМ РОЗПОДІЛОМ
M=0; % СЕРЕДНЄ ЗНАЧЕННЯ ШУМУ
V=0.2; % ДИСПЕРСІЯ ШУМУ
% Tsh='salt & pepper'; % ТИП ШУМУ НА ЗОБРАЖЕННІ
% 'salt & pepper' - ШУМ У ВИГЛЯДІ БІЛИХ І ЧОРНИХ ТОЧОК
% D=0.05; % ЩІЛЬНІСТЬ ШУМУ НА ЗОБРАЖЕННІ
% Tsh='speckle'; % ТИП ШУМУ НА ЗОБРАЖЕННІ
% 'speckle' - МУЛЬТИПЛІКАТИВНИЙ ШУМ
% V=0.01; % ДИСПЕРСІЯ ШУМУ
% СТВОРЕННЯ ФІЛЬТРА
Tfilter='average'; % ТИП ФІЛЬТРА
 % 'average' - УСЕРЕДНЮЮЮЧИЙ ФІЛЬТР
Hsize=7; % РОЗМІР КВАДРАТНОЇ МАСКИ ФІЛЬТРА
Filter=fspecial(Tfilter,Hsize); % СТВОРЕННЯ МАСКИ ФІЛЬТРА
% Tfilter='gaussian'; % ТИП ФІЛЬТРА
% 'gaussian' - ГАУСОВ ФІЛЬТР НИЖНІХ ЧАСТОТ
% РАДІУС МАСКИ ФІЛЬТРА, РОЗМІР КВАДРАТНОЇ МАСКИ Radius*2+1
% Radius=5;
% СТВОРЕННЯ МАСКИ ФІЛЬТРА
% Filter=fspecial(Tfilter,Radius);
% ЗАВАНТАЖЕННЯ ПОЧАТКОВОГО ЗОБРАЖЕННЯ
OrigImage=imread(ImageName);
if ndims (OrigImage) ==3
 OrigImage=rgb2gray(OrigImage);
end
% ДОДАВАННЯ ШУМУ ДО ЗОБРАЖЕННЯ
NoiseImage = imnoise(OrigImage,Tsh,M,V);
% NoiseImage = imnoise(OrigImage,Tsh,D);
% NoiseImage = imnoise(OrigImage,Tsh,V);
% ФІЛЬТРАЦІЯ ЗОБРАЖЕННЯ
% УСЕРЕДНЮЮЧИЙ ФІЛЬТР З КВАДРАТНОЮ МАСКОЮ
% Hsize x Hsize ТОЧОК
RestoreImage=imfilter(NoiseImage, Filter);
% МЕДІАННИЙ ФІЛЬТР
% РОЗМІР МАТРИЦІ ДЛЯ ВИЗНАЧЕННЯ СУСІДНИХ ТОЧОК
% Mfilter=[3 3];
% RestoreImage=medfilt2(NoiseImage,Mfilter);
% ОБЧИСЛЕННЯ ВІДМІННОСТЕЙ МІЖ ВІДНОВЛЕНИМ І
% ПОЧАТКОВИМ ЗОБРАЖЕННЯМ
ErrorImage=uint8(abs(double(RestoreImage)-double(OrigImage)));
DeltaMean=double(mean2(ErrorImage));
DeltaMax=double(max(max(ErrorImage)));
% ВИВЕДЕННЯ РЕЗУЛЬТАТІВ
fprintf('ДОСЛІДЖЕННЯ МЕТОДІВ ФІЛЬТРАЦІЇ ВІДЕОІНФОРМАЦІЇ В ІНТЕЛЕКТУАЛЬНИХ СИСТЕМАХ\n');
fprintf('МАКСИМАЛЬНЕ ЗНАЧЕННЯ ПОХИБКА ВІДНОВЛЕННЯ %7.3f ДИСКРЕТНИХ РІВНЕЙ\n', DeltaMax);
fprintf('СЕРЕДНЕ ЗНАЧЕННЯ ПОХИБКА ВІДНОВЛЕННЯ %7.3f ДИСКРЕТНИХ РІВНЕЙ\n', DeltaMean);
subplot(2,2,1); imshow(OrigImage);
title('ПОЧАТКОВЕ ЗОБРАЖЕННЯ');
subplot(2,2,2); imshow(NoiseImage);
title('ЗОБРАЖЕННЯ З ШУМОМ');
subplot(2,2,3); imshow(RestoreImage);
title('ВІДНОВЛЕНЕ ЗОБРАЖЕННЯ');
subplot(2,2,4); imshow(ErrorImage);
title('ПОХИБКА ВІДНОВЛЕННЯ');