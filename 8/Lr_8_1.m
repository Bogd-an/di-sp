CIR = multibandread('tokyo.lan', [512, 512, 7], 'uint8=>uint8',... 
     128, 'bil', 'ieee-le', {'Band','Direct',[4 3 1]}); 
                figure, imshow(CIR) 
title('CIR Composite (Un-enhanced)') 
text(size(CIR,2), size(CIR,1) + 15,... 
  'Image courtesy of Space Imaging, LLC',... 
  'FontSize', 5, 'HorizontalAlignment', 'right') 
decorrCIR = decorrstretch(CIR, 'Tol', 0.01); 
figure, imshow(decorrCIR) 
title('CIR Composite with Decorrelation Stretch') 
NIR = im2single(CIR(:,:,1)); 
blue= im2single(CIR(:,:,2)); 
figure, imshow(blue) 
title('Visible Blue Band') 
figure 
imshow(NIR) 
title('Near Infrared Band') 
figure,plot(blue, NIR, '+b') 
set(gca, 'XLim', [0 1], 'XTick', 0:0.2:1,... 
         'YLim', [0 1], 'YTick', 0:0.2:1); 
axis square 
xlabel('blue level') 
ylabel('NIR level') 
title('NIR vs. Red Scatter Plot') 
ndvi = (NIR - blue) ./ (NIR + blue); 
figure,imshow(ndvi,'DisplayRange',[-1 1]) 
title('Normalized Difference Vegetation Index') 
threshold =-0.1; 
q = (ndvi > threshold); 
figure, imshow(q) 
title('NDVI with Threshold Applied') 
% Creating an image with a characteristic ratio 12. 
h = figure; 
p = get(h,'Position'); 
set(h,'Position',[p(1,1:3),p(3)/2]) 
subplot(1,2,1) 
% Creating a scattering schedule. 
plot(blue, NIR, '+b') 
hold on 
plot(blue(q(:)), NIR(q(:)), 'g+') 
set(gca, 'XLim', [0 1], 'YLim', [0 1]) 
axis square 
xlabel('red level') 
ylabel('NIR level') 
title('NIR vs. Red Scatter Plot') 
% NDVI image display. 
subplot(1,2,2) 
imshow(q) 
set(h,'Colormap',[0 0 1; 0 1 0]) 
title('NDVI with Threshold Applied') 