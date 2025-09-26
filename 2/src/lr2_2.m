img = imread('rock.bmp');

[pal, map] = rgb2ind(img, 256); %на палітрове з 256 кольорами
eq = histeq(pal);

customHist({pal, eq}, {'палітрове', 'еквалізоване палітрове'}, map);

print(gcf, [mfilename('fullpath') '.png'], '-dpng', '-r300');
close(gcf);
