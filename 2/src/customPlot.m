function customPlot(pos, im, t)
    ax = subplot(pos(1), pos(2), pos(3));
    
    if ~isa(im,'uint8') && ~isa(im,'uint16')  % якщо не клас зображення
        imagesc(ax, im); 
        axis(ax, 'image'); 
        colorbar(ax);
        colormap(ax, jet);  % кольорова карта для матриці
    else
        imshow(im, 'Parent', ax); 
        colormap(ax, gray);  % сірі відтінки для зображення
    end
    title(ax, t);
end