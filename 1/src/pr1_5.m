imgs = {'Rock.bmp', 'Rock.jpg', 'kamen.bmp'};

for k = 1:length(imgs)
    [X, map] = imread(imgs{k});
    if ~isempty(map)
        I = ind2gray(X, map); % якщо індексоване 
    else
        I = rgb2gray(X); % RGB або вже grayscale
    end
    gr = im2double(I);
    level = graythresh(I);  % поріг методом Отсу
    fprintf('%s \t поріг = %.10f\n', imgs{k}, level);
end
