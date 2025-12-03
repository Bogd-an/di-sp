% кюанпюрнпмю пнанрю ╧4
% ярхямеммъ жхтпнбху б╡денгнапюфемэ гю JPEG-юкцнпхрлнл
% ббедеммъ онвюрйнбху дюмху
prompt={'╡л"ъ тюикю гнапюфеммъ',...
   'пнгл╡п гнапюфеммъ йxй дхяйп. рнвнй: й=32,64,128,256,512',...
   'пнгл╡п акнйс дйо NxN дхяйп. рнвнй: N=4,8,16,32,64,128,256,512',...
   'лернд навхякеммъ дйо: 1-яслю; 2-люрпхж╡',...
   'й╡кэй╡ярэ мемскэнбху йнет. дйо: л=1,2,...,N; 0-лернд ме бхйнпхяр.',...
   'онпнц дкъ мемскэнбху йнет. дйо: п=1,...,255; 0-лернд ме бхйнпхяр.',...
   'бхбедеммъ пегскэрюр╡б: 1-гнапюфеммъ; 2-рюакхжъ; 3-гнап. ╡ рюак.'};
def={'apple.bmp','256','8','1','0','0','3'};
dlgTitle='кюанпюрнпмю пнанрю ╧4';
lineNo=1;
AddOpts.Resize='on';
AddOpts.WindowStyle='normal';
AddOpts.Interpreter='tex';
Answer=inputdlg(prompt,dlgTitle,lineNo,def,AddOpts);
ImageName=Answer{1};  % ╡л"ъ тюикю гнапюфеммъ
K=str2num(Answer{2}); % пнгл╡п гнапюфеммъ йxй дхяйп. рнвнй
N=str2num(Answer{3}); % пнгл╡п акнйс дйо NxN дхяйп. рнвнй
TypeCalc=str2num(Answer{4}); % лернд навхякеммъ дйо
M=str2num(Answer{5}); % й╡кэй╡ярэ мемскэнбху йнет. дйо
P=str2num(Answer{6}); % онпнц дкъ мемскэнбху йнет. дйо
TypeOutput=str2num(Answer{7});  % бхбедеммъ пегскэрюр╡б

% ╡м╡ж╡юк╡гюж╡ъ гл╡ммху
OrigImage=zeros(K,K);
RestoreImage=zeros(K,K);
CoefDCT=zeros(K,K);
CoefDCTCompress=zeros(K,K);
CoefMul=zeros(N,N);

% гюбюмрюфеммъ онвюрйнбнцн гнапюфеммъ
RGB=imread(ImageName);
II=rgb2gray(RGB);
OrigImage=II(1:K,1:K);

% навхякеммъ дйо
switch TypeCalc
case 1
    Time1=cputime;
    fun=@dct2;
    CoefDCT=blkproc(OrigImage,[N N],fun);
    Time2=cputime;
    fprintf('\nвюя навхякеммъ опълнцн дйо (яслю) %7.3f яейсмд\n',Time2-Time1);
case 2
    Time1=cputime;
    CoefMul=dctmtx(N);
    fun = inline('P1*double(x)*ctranspose(P1)', 1);
    CoefDCT=blkproc(OrigImage, [N N], fun, CoefMul);
    Time2=cputime;
    fprintf('\nвюя навхякеммъ опълнцн дйо (люрпхж╡) %7.3f яейсмд\n',Time2-Time1);   
end
% ярхямеммъ гнапюфеммъ
if P~=0
    CoefDCTCompress=CoefDCT;
    CoefDCTCompress((abs(CoefDCTCompress))<P)=0;
end
if M~=0
    h = waitbar(0,'ярхямеммъ гнапюфеммъ ...');
    CoefDCTCompress=zeros(K,K);
    for i=1:(K/N)
        for j=1:(K/N)
            waitbar(((i-1)*(K/N)+j)/((K/N)*(K/N)),h);
            CoefDCTCompress(((i-1)*N+1):((i-1)*N+M),((j-1)*N+1):((j-1)*N+M))=...
                CoefDCT(((i-1)*N+1):((i-1)*N+M),((j-1)*N+1):((j-1)*N+M));
        end
    end
    close(h);
end
if (P==0)&(M==0)
    CoefDCTCompress=CoefDCT;
end

% б╡дмнбкеммъ гнапюфеммъ
switch TypeCalc
case 1
    Time1=cputime;
    fun=@idct2;
    RestoreImage=uint8(blkproc(CoefDCTCompress,[N N],fun));
    % RestoreImage=uint8(idct2(CoefDCTCompress));
    Time2=cputime;
    fprintf('вюя навхякеммъ наепмемнцн дйо (яслю) %7.3f яейсмд\n',Time2-Time1);   
case 2
    Time1=cputime;
    fun = inline('uint8(ctranspose(P1)*x*P1)', 1);
     RestoreImage=blkproc(CoefDCTCompress, [N N], fun, CoefMul);
    Time2=cputime;
    fprintf('вюя навхякеммъ наепмемнцн дйо (люрпхж╡) %7.3f яейсмд\n',Time2-Time1);   
end

% навхякеммъ онухайх, ын бхмхйкю б пегскэрюр╡ ярхямеммъ
ErrorDCTArray=abs(double(RestoreImage)-double(OrigImage));
ErrorDCTMean=mean2(ErrorDCTArray);
ErrorDCTSKO=sqrt((sum(sum(ErrorDCTArray.^2)))/(K*K));
ErrorDCTMax=max(max(ErrorDCTArray));
ErrorDCTMin=min(min(ErrorDCTArray));

% навхякеммъ йнет╡ж╡╙мрс ярхямеммъ
RCompress=prod(size(CoefDCTCompress))/nnz(CoefDCTCompress);
% бхбедеммъ пегскэрюр╡б
if ((TypeOutput==2)|(TypeOutput==3))
	fprintf('дхмюл╡вмхи д╡юоюгнм ъяйпюбняр╡ 255 дхяйпермху п╡бмеи\n');
	fprintf('онухайю, ын бхмхйкю б пегскэрюр╡ ярхямеммъ\n');   
	fprintf('яепедм╙ гмювеммъ     %7.3f дхяйпермху п╡бмеи\n', ErrorDCTMean);   
	fprintf('яепедмэнйбюдпюрхвме гмювеммъ     %7.3f дхяйпермху п╡бмеи\n', ErrorDCTSKO);   
	fprintf('л╡м╡люкэме гмювеммъ  %7.3f дхяйпермху п╡бмеи\n', ErrorDCTMin);   
	fprintf('люйяхлюкэме гмювеммъ %7.3f дхяйпермху п╡бмеи\n', ErrorDCTMax);   
	fprintf('ярхямеммъ гнапюфеммъ (й╡кэй╡ярэ бя╡у йнет╡ж╡╙мр╡б дйо/й╡кэй╡ярэ мскэнбху йнет╡ж╡╙мр╡б)\n');   
	fprintf('%7.3f пюг╡б\n', RCompress);
end
if ((TypeOutput==1)|(TypeOutput==3))
	subplot(2,2,1); imshow(OrigImage);
	subplot(2,2,2); imshow(log(abs(CoefDCT)));
     colormap(gray(256)); colorbar;
	subplot(2,2,3); imshow(RestoreImage);
	subplot(2,2,4); imshow(log(abs(CoefDCTCompress)));
     colormap(gray(256)); colorbar;
end
