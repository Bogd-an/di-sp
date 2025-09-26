img = imread('rock.jpg');
gray_img = rgb2gray(img);
neg_img = imcomplement(gray_img);  % негатив

corr = xcorr2(neg_img, gray_img);  % 2D автокореляційна функція
coorN= normxcorr2(neg_img, gray_img); % 2D нормалізована кореляція

customPlot([2, 3, 1], gray_img, 'Відтінки сірого');
customPlot([2, 3, 2], corr,     'автокореляційна');
customMesh([2, 3, 3], corr,     'автокореляційна');
customPlot([2, 3, 4], neg_img,  'Негатив');
customPlot([2, 3, 5], coorN,    'нормалізована');
customMesh([2, 3, 6], coorN,    'нормалізована');

drawnow;
print(gcf, [mfilename('fullpath') '.png'], '-dpng', '-r300');
close(gcf);