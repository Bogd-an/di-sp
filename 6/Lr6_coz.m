% кюанпюрнпмю пнанрю ╧6
% лерндх бхд╡кеммъ йнмрсп╡б на'╙йр╡б мю жхтпнбху
% б╡денгнапюфеммъу б ╡мрекейрсюкэмху яхярелюу
ImageName='e:\coz\lr1\saturn.tif'; % ╡л"ъ тюикю гнапюфеммъ
% бха╡п лерндс б╡д╡кеммъ йнмрсп╡б
%Type='sobel'; % лернд янаекъ
 % оюпюлерпх лерндс
%Thresh=0.05; % онп╡ц дкъ бхгмювеммъ йнмрспю
%Direction='both'; % мюопълнй пнгрюьсбюммъ йнмрсп╡б
 % 'horizontal' - цнпхгнмрюкэмхи
 % 'vertical' - бепрхйюкэмхи
 % 'both' - б нану мюопълйюу

 Type='prewitt'; % лернд опеб╡рю
% % оюпюлерпх лерндс
 Thresh=0.05; % онп╡ц дкъ бхгмювеммъ йнмрспю
Direction='both'; % мюопълнй пнгрюьсбюммъ йнмрсп╡б
% % 'horizontal' - цнпхгнмрюкэмхи
% % 'vertical' - бепрхйюкэмхи
% % 'both' - б нану мюопълйюу
%
% Type='roberts'; % лернд пнаепряю
% % оюпюлерпх лерндс
% Thresh=0.05; % онп╡ц дкъ бхгмювеммъ йнмрспю
% Direction='both'; % мюопълнй пнгрюьсбюммъ йнмрсп╡б
% % 'horizontal' - цнпхгнмрюкэмхи
% % 'vertical' - бепрхйюкэмхи
% % 'both' - б нану мюопълйюу
%
% Type='log'; % лернд кюокюяхюмю йпхбн╞ цюсяяю
% % оюпюлерпх лерндс
% Thresh=0.005; % онп╡ц дкъ бхгмювеммъ йнмрспю
% Direction='both'; % мюопълнй пнгрюьсбюммъ йнмрсп╡б
% % 'horizontal' - цнпхгнмрюкэмхи
% % 'vertical' - бепрхйюкэмхи
% % 'both' - б нану мюопълйюу
%
% Type='canny'; % лернд йюммх
% % оюпюлерпх лерндс
% Thresh=0.05; % онп╡ц дкъ бхгмювеммъ йнмрспю
% Direction='both'; % мюопълнй пнгрюьсбюммъ йнмрсп╡б
% % 'horizontal' - цнпхгнмрюкэмхи
% % 'vertical' - бепрхйюкэмхи
% % 'both' - б нану мюопълйюу
% гюбюмрюфеммъ онвюрйнбнцн гнапюфеммъ
OrigImage=imread(ImageName);
if ndims(OrigImage)==3
 OrigImage=rgb2gray(OrigImage);
end
% дндюбюммъ ьслс дн гнапюфеммъ
NoiseImage = imnoise(OrigImage,'salt & pepper',0.2);
% т╡кэрпюж╡ъ гнапюфеммъ
% сяепедмччвхи т╡кэрп г йбюдпюрмнч люяйнч Hsize x Hsize рнвнй
Tfilter='average'; % рхо т╡кэрпю
Hsize=5; % пнгл╡п йбюдпюрмн╞ люяйх т╡кэрпю
Filter=fspecial(Tfilter,Hsize); % ярбнпеммъ люяйх т╡кэрпю
RestoreImage=imfilter(NoiseImage, Filter);
% бхд╡кеммъ йнмрсп╡б
% бхйнпхярюммъ гюдюмху оюпюлерп╡б
BW1=edge(OrigImage,Type,Thresh,Direction);
BW2=edge(NoiseImage,Type,Thresh,Direction);
BW3=edge(RestoreImage,Type,Thresh,Direction);
% юбрнлюрхвме бхгмювеммъ онпнцс
%[BW1,Tresh1]=edge(OrigImage,Type);
%[BW2,Tresh2]=edge(NoiseImage,Type);
%[BW3,Tresh3]=edge(RestoreImage,Type);
CountEdge1=nnz(double(BW1));
CountEdge2=nnz(double(BW2));
CountEdge3=nnz(double(BW3));
% бхбедеммъ пегскэрюр╡б
fprintf('\nлерндх бхд╡кеммъ йнмрсп╡б на''╙йр╡б мю б╡денгнапюфеммъу\n');
fprintf('гюцюкэмю днбфхмю йнмрсп╡б мю онвюрйнбнлс гнапюфемм╡ %7.0f дхяйпермху рнвнй\n', CountEdge1);
fprintf('гюцюкэмю днбфхмю йнмрсп╡б мю гнапюфемм╡ г ьслнл %7.0f дхяйпермху рнвнй\n', CountEdge2);
fprintf('гюцюкэмю днбфхмю йнмрсп╡б мю  б╡дмнбкемнлс гнапюфемм╡ %7.0f дхяйпермху рнвнй\n', CountEdge3);
subplot(3,2,1); imshow(OrigImage);
title('онвюрйнбе гнапюфеммъ');
subplot(3,2,2); imshow(BW1);
title('йнмрспх мю онвюрй. гнап.');
subplot(3,2,3); imshow(NoiseImage);
title('гнапюфеммъ г ьслнл');
subplot(3,2,4); imshow(BW2);
title('йнмрспх мю гнап. г ьслнл');
subplot(3,2,5); imshow(RestoreImage);
title('б╡дмнбкеме гнапюфеммъ');
subplot(3,2,6); imshow(BW3);
title('йнмрспх мю б╡дмнбкемнлс гнап. ');