% кюанпюрнпмю пнанрю ╧5
% дняк╡дфеммъ лернд╡б т╡кэрпюж╡╞ ьсл╡б мю жхтпнбху 
% б╡денгнапюфеммъу б ╡мрекейрсюкэмху яхярелюу
% ббедеммъ онвюрйнбху дюмху
ImageName='e:\coz\lr1\saturn.tif'; % ╡л"ъ тюикю гнапюфеммъ
% бхгмювеммъ ьслс
Tsh='gaussian'; % рхо ьслс мю гнапюфемм╡
% 'gaussian' - "а╡кхи" ьсл г мнплюкэмхл пнгонд╡кнл
M=0; % яепедм╙ гмювеммъ ьслс
V=0.2; % дхяоепя╡ъ ьслс
% Tsh='salt & pepper'; % рхо ьслс мю гнапюфемм╡
% 'salt & pepper' - ьсл с бхцкъд╡ а╡кху ╡ внпмху рнвнй
% D=0.05; % ы╡кэм╡ярэ ьслс мю гнапюфемм╡
% Tsh='speckle'; % рхо ьслс мю гнапюфемм╡
% 'speckle' - лскэрхок╡йюрхбмхи ьсл
% V=0.01; % дхяоепя╡ъ ьслс
% ярбнпеммъ т╡кэрпю
Tfilter='average'; % рхо т╡кэрпю
 % 'average' - сяепедмчччвхи т╡кэрп
Hsize=7; % пнгл╡п йбюдпюрмн╞ люяйх т╡кэрпю
Filter=fspecial(Tfilter,Hsize); % ярбнпеммъ люяйх т╡кэрпю
% Tfilter='gaussian'; % рхо т╡кэрпю
% 'gaussian' - цюсянб т╡кэрп мхфм╡у вюярнр
% пюд╡ся люяйх т╡кэрпю, пнгл╡п йбюдпюрмн╞ люяйх Radius*2+1
% Radius=5;
% ярбнпеммъ люяйх т╡кэрпю
% Filter=fspecial(Tfilter,Radius);
% гюбюмрюфеммъ онвюрйнбнцн гнапюфеммъ
OrigImage=imread(ImageName);
if ndims (OrigImage) ==3
 OrigImage=rgb2gray(OrigImage);
end
% дндюбюммъ ьслс дн гнапюфеммъ
NoiseImage = imnoise(OrigImage,Tsh,M,V);
% NoiseImage = imnoise(OrigImage,Tsh,D);
% NoiseImage = imnoise(OrigImage,Tsh,V);
% т╡кэрпюж╡ъ гнапюфеммъ
% сяепедмччвхи т╡кэрп г йбюдпюрмнч люяйнч
% Hsize x Hsize рнвнй
RestoreImage=imfilter(NoiseImage, Filter);
% лед╡юммхи т╡кэрп
% пнгл╡п люрпхж╡ дкъ бхгмювеммъ яся╡дмху рнвнй
% Mfilter=[3 3];
% RestoreImage=medfilt2(NoiseImage,Mfilter);
% навхякеммъ б╡дл╡ммняреи л╡ф б╡дмнбкемхл ╡
% онвюрйнбхл гнапюфеммъл
ErrorImage=uint8(abs(double(RestoreImage)-double(OrigImage)));
DeltaMean=double(mean2(ErrorImage));
DeltaMax=double(max(max(ErrorImage)));
% бхбедеммъ пегскэрюр╡б
fprintf('дняк╡дфеммъ лернд╡б т╡кэрпюж╡╞ б╡ден╡мтнплюж╡╞ б ╡мрекейрсюкэмху яхярелюу\n');
fprintf('люйяхлюкэме гмювеммъ онухайю б╡дмнбкеммъ %7.3f дхяйпермху п╡бмеи\n', DeltaMax);
fprintf('яепедме гмювеммъ онухайю б╡дмнбкеммъ %7.3f дхяйпермху п╡бмеи\n', DeltaMean);
subplot(2,2,1); imshow(OrigImage);
title('онвюрйнбе гнапюфеммъ');
subplot(2,2,2); imshow(NoiseImage);
title('гнапюфеммъ г ьслнл');
subplot(2,2,3); imshow(RestoreImage);
title('б╡дмнбкеме гнапюфеммъ');
subplot(2,2,4); imshow(ErrorImage);
title('онухайю б╡дмнбкеммъ');