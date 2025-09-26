img = imread('rock.bmp');

g = rgb2gray(img);
eq = histeq(g); %вирівнювання (еквалізація) 

customHist({g, eq}, {'півтонове', 'півтонове еквалізоване'}, []);

print(gcf, [mfilename('fullpath') '.png'], '-dpng', '-r300');
close(gcf);
