function customMesh(pos, c, t)
    max_size = 100; % максимальний розмір для mesh, бо ноуту погано :(
    [h, w] = size(c);

    row_idx = round(linspace(1, h, min(h,max_size)));
    col_idx = round(linspace(1, w, min(w,max_size)));
    c_small = c(row_idx, col_idx);
    
    ax = subplot(pos(1), pos(2), pos(3));
    mesh(ax, c_small);  
    title(ax, t); 
    xlabel(ax,'X'); ylabel(ax,'Y'); 
    % zlabel(ax, labelZ);
    colormap(ax, jet);
end