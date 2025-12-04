I = imread('halloween.png'); 
I_resized = imresize(I, [512 512]);
rect = [250 100 250 250]; 
I_cropped = imcrop(I_resized, rect);

angle_geo = 65;
I_rotated = imrotate(I_resized, angle_geo, 'bicubic');

f1 = figure('Name', 'Lab 7 - Part 1: Geometric', 'Position', [100, 100, 1000, 400]);
subplot(1, 4, 1); imshow(I); title('Оригінал');
subplot(1, 4, 2); imshow(I_resized); title('Resize 512x512');
subplot(1, 4, 3); imshow(I_cropped); title('Crop [250 100 ...]');
subplot(1, 4, 4); imshow(I_rotated); title(['Rotate ' num2str(angle_geo) '^o']);

exportgraphics(f1, 'Lab7_Part1_Geometric.png', 'Resolution', 300);
close(f1);
%% 1. Оригінал

I_sp = imread('leaf.jpg');

scale_val = 5.0; 
angle_sp = 60 * pi / 180;
stretch_val = 1.2;
a1 = 7; 
a2 = 5;

f2 = figure('Name', 'Lab 7 - Part 2: Spatial', 'Position', [100, 100, 1200, 600]);

subplot(2, 4, 1); imshow(I_sp); title('Original Image');

%% 2. Linear Conformal (Scale + Rotation)
sc = scale_val * cos(angle_sp);
ss = scale_val * sin(angle_sp);
T_conf = [ sc -ss;
           ss  sc;
            0   0 ];
t_lc = maketform('affine', T_conf);

I_linconf = imtransform(I_sp, t_lc, 'FillValues', .3); 
subplot(2, 4, 2); imshow(I_linconf); title('Linear Conformal');

%% 3. Affine (Generic)
T_aff = [1 0.1; 1 1; 0 0]; % Базова матриця зсуву з прикладу
t_aff = maketform('affine', T_aff);
I_affine = imtransform(I_sp, t_aff, 'FillValues', .3);
subplot(2, 4, 3); imshow(I_affine); title('Affine (Shear)');

%% 4. Projective
T_proj = [1 0 0.008; 1 1 0.01; 0 0 1];
t_proj = maketform('projective', T_proj);
I_proj = imtransform(I_sp, t_proj, 'FillValues', .3);
subplot(2, 4, 4); imshow(I_proj); title('Projective');

%% 5. Polynomial
% Генерація базисних точок (випадкова деформація)
rng(12); % Фіксуємо seed
xybase = reshape(randn(12, 1), 6, 2);
t_poly = cp2tform(xybase, xybase, 'polynomial', 2);

T_poly_data = [0 0; 1 0; 0 1; 0.001 0; 0.02 0; 0.01 0];
t_poly.tdata = T_poly_data;
I_poly = imtransform(I_sp, t_poly, 'FillValues', .3);
subplot(2, 4, 5); imshow(I_poly); title('Polynomial');

%% 6. Piecewise Linear (Розтягнення правої частини)
imid = round(size(I_sp, 2) / 2);
I_left = I_sp(:, 1:imid, :); % Підтримка RGB
I_right = I_sp(:, imid+1:end, :);
% Обчислення нового розміру
new_width = round(stretch_val * imid);
size_right = [size(I_sp, 1), new_width];
I_right_str = imresize(I_right, size_right);
I_piecewise = [I_left I_right_str]; % Склеювання
subplot(2, 4, 6); imshow(I_piecewise); title('Piecewise Linear');

%% 7. Sinusoidal Transformation
[nrows, ncols, ~] = size(I_sp);
[xi, yi] = meshgrid(1:ncols, 1:nrows);
% Формула деформації
u = xi + a1 * sin(pi * xi / imid);
v = yi - a2 * sin(pi * yi / imid);
tmap_B = cat(3, u, v);
resamp = makeresampler('linear', 'fill');
% tformarray застосовує координатне відображення
I_sin = tformarray(I_sp, [], resamp, [2 1], [1 2], [], tmap_B, .3);
subplot(2, 4, 7); imshow(I_sin); title(['Sinusoid (a1=' num2str(a1) ')']);

exportgraphics(f2, 'Lab7_Part2_Spatial.png', 'Resolution', 300);
close(f2);