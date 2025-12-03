I=imread('leaf.jpg');
% Чотири параметри
scale=1.2; % коефіцієнт масштабування
angle=40*pi/180; % кут повороту
tx=0; % зсув по x
ty=0; % зсув по y
sc=scale*cos(angle);
ss=scale*sin(angle);
T=[ sc -ss;
 ss sc;
 tx ty];
subplot(331)
imshow(I);
title('Original image')
t_lc=maketform('affine', T);
I_linearconformal=imtransform(I, t_lc, 'FillValues', .3);
subplot(332)
imshow(I_linearconformal);
title('linear conformal')
[I_linearconformal, xdata, ydata]=imtransform(I, t_lc, 'FillValues', .3);
T=[1 0.1;
 1 1;
 0 0];
t_aff=maketform('affine', T);
I_affine=imtransform(I, t_aff, 'FillValues', .3);
subplot(333)
imshow(I_affine)
title('affine')
T=[1 0 0.008;
 1 1 0.01;
 0 0 1];
t_proj=maketform('projective', T);
I_projective=imtransform(I, t_proj, 'FillValues', .3);
subplot(334)
imshow(I_projective)
title('projective')
xybase=reshape(randn(12, 1), 6, 2);
t_poly=cp2tform(xybase, xybase, 'polynomial', 2);
% Дванадцять елементів T.
T= [0 0;
 1 0;
 0 1;
 0.001 0;
 0.02 0;
 0.01 0];
t_poly.tdata=T;
I_polynomial=imtransform(I, t_poly, 'FillValues', .3);
subplot(335)
imshow(I_polynomial)
title('polynomial')
imid=round(size(I, 2)/2);
I_left=I(:, 1:imid);
stretch=1.5; % Коефіціент розтягнення
size_right=[size(I, 1) round(stretch*imid)];
I_right=I(:, imid+1:end);
I_right_stretched=imresize(I_right, size_right);
I_piecewiselinear=[I_left I_right_stretched];
subplot(336)
imshow(I_piecewiselinear)
title('piecewise linear')
[nrows, ncols]=size(I);
[xi, yi]=meshgrid(1:ncols, 1:nrows);
a1=5; % амплітуда синусоїди.
a2=3;
u=xi+a1*sin(pi*xi/imid);
v=yi-a2*sin(pi*yi/imid);
tmap_B=cat(3, u, v);
resamp=makeresampler('linear', 'fill');
I_sinusoid=tformarray(I, [], resamp, [2 1], [1 2], [], tmap_B, .3);
subplot(337)
imshow(I_sinusoid)
title('sinusoid')

