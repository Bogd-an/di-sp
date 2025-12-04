orig_img = imread('saturn.tif');
noise_type = 'speckle';
vars = [0.01, 0.02];
mask_sizes = [5, 9];

if ndims(orig_img) == 3
    orig_img = rgb2gray(orig_img);
end
I = im2double(orig_img);

idxList = 1:4;
vList = [vars(1), vars(2), vars(1), vars(2)];     
mList = [mask_sizes(1), mask_sizes(2), mask_sizes(1), mask_sizes(2)]; 

filterTypes = {'average', 'average', 'median', 'median'}; 

for i = 1:length(idxList)
    idx = idxList(i);
    v = vList(i);
    m = mList(i);
    currentFilter = filterTypes{i}; 
    noisy_I = imnoise(I, noise_type, v);
    if strcmp(currentFilter, 'average')
        h = fspecial('average', m);
        restored_I = imfilter(noisy_I, h);
    else
        restored_I = medfilt2(noisy_I, [m m]);
    end
    diff_I = abs(restored_I - I);
    err_mean = mean2(diff_I);
    err_max = max(max(diff_I));
    
    statsStr = sprintf('Experiment %d \nMean: %.4f\nMax: %.4f', idx, err_mean, err_max);
    figTitle = sprintf('Exp %d: %s %dx%d', idx, currentFilter, m, m);
    
    f = figure('Name', figTitle, 'NumberTitle', 'off');
    set(f, 'Position', [100, 100, 1000, 400]);

    splt(0, [], statsStr);
    splt(1, I, 'Оригінал');
    splt(2, noisy_I, ['Speckle, var=', num2str(v)]);
    splt(3, restored_I, [currentFilter, '-', num2str(m), 'x', num2str(m)]);
    splt(4, diff_I, 'Похибка');

    filename = [mfilename('fullpath'), '_', num2str(i), '.png'];
    exportgraphics(f, filename, 'Resolution', 300);
    close(f);
end

function splt(inx, I, title_str)
    subplot(1, 5, inx+1); imshow(I); title(title_str);
end