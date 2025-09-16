[img, color_map] = imread('rock.bmp');
I = im2double(ind2gray(img, color_map));

level = DIYiterativeThreshold(I);
BW = I > level; % бінаризація

f = figure;
subplot(1,3,1), imshow(img, color_map), title('Оригінал');
subplot(1,3,2), imshow(I), title('Відтінки сірого');
subplot(1,3,3), imshow(BW), title(['Бінаризація, поріг = ', num2str(level)]);

exportgraphics(f, [mfilename('fullpath') '.png'], 'Resolution', 300);


function T = DIYiterativeThreshold(I)
  T = 0.5 * (min(I(:)) + max(I(:))); %початковий поріг - середнє між min max пікселів
  Tnext = 0;
  while abs(T - Tnext) >= 0.5
    Tnext = T;
    g = I >= T; %логічна маска "світлих" пікселів, які >= порогу
    T = 0.5 * (min(I(g)) + max(I(~g)));%- середнє між min світлих max темних пікселів
  end
end
