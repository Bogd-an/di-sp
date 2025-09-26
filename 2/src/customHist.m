function customHist(images, titles, map)
    for k = 1:length(images)
        img_k = images{k};
        t = titles{k};
        i = (k-1)*2;
        
        subplot(2,2,i+1);
        if isempty(map)
            imshow(img_k); 
        else
            imshow(img_k, map); 
        end
        title(['Зображення: ' t]);
        
        subplot(2,2,i+2); imhist(img_k);  title(['Гістограма: ' t]);
    end

    drawnow;
end
