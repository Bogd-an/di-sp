img = imread('rock.jpg');
gray_img = rgb2gray(img);

angles = [0, 30, 120];
anglLen = length(angles)+1;

customPlot([anglLen, 2, 1], img, 'Оригінальне');
customPlot([anglLen, 2, 2], gray_img, 'Grayscale');

for k = 1:anglLen-1
    angle = angles(k);
    index = 3*k + 1;
    
    rotated_img = imrotate(gray_img, angle, 'bilinear', 'crop');
    c = normxcorr2(rotated_img, gray_img); % 2D нормалізована кореляція

    customPlot([anglLen, 3, index], rotated_img, ['Повернуте: ' num2str(angle) '°']);
    customPlot([anglLen, 3, index+1], c, 'Взаємна кореляційна');
    customMesh([anglLen, 3, index+2], c, 'Взаємна кореляційна');
end

drawnow;
print(gcf, [mfilename('fullpath') '.png'], '-dpng', '-r300');
close(gcf);
