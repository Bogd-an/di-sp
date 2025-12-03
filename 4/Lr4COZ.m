% ЛАБОРАТОРНА РОБОТА №4
% СТИСНЕННЯ ЦИФРОВИХ ВІДЕОЗОБРАЖЕНЬ ЗА JPEG-АЛГОРИТМОМ
% ВВЕДЕННЯ ПОЧАТКОВИХ ДАНИХ
prompt={'ІМ"Я ФАЙЛА ЗОБРАЖЕННЯ',...
   'РОЗМІР ЗОБРАЖЕННЯ КxК ДИСКР. ТОЧОК: К=32,64,128,256,512',...
   'РОЗМІР БЛОКУ ДКП NxN ДИСКР. ТОЧОК: N=4,8,16,32,64,128,256,512',...
   'МЕТОД ОБЧИСЛЕННЯ ДКП: 1-СУМА; 2-МАТРИЦІ',...
   'КІЛЬКІСТЬ НЕНУЛЬОВИХ КОЕФ. ДКП: М=1,2,...,N; 0-МЕТОД НЕ ВИКОРИСТ.',...
   'ПОРОГ ДЛЯ НЕНУЛЬОВИХ КОЕФ. ДКП: Р=1,...,255; 0-МЕТОД НЕ ВИКОРИСТ.',...
   'ВИВЕДЕННЯ РЕЗУЛЬТАТІВ: 1-ЗОБРАЖЕННЯ; 2-ТАБЛИЦЯ; 3-ЗОБР. І ТАБЛ.'};
def={'bacter.jpg','256','8','1','0','0','3'};
dlgTitle='ЛАБОРАТОРНА РОБОТА №4';
lineNo=1;
AddOpts.Resize='on';
AddOpts.WindowStyle='normal';
AddOpts.Interpreter='tex';
Answer=inputdlg(prompt,dlgTitle,lineNo,def,AddOpts);
ImageName=Answer{1};  % ІМ"Я ФАЙЛА ЗОБРАЖЕННЯ
K=str2num(Answer{2}); % РОЗМІР ЗОБРАЖЕННЯ КxК ДИСКР. ТОЧОК
N=str2num(Answer{3}); % РОЗМІР БЛОКУ ДКП NxN ДИСКР. ТОЧОК
TypeCalc=str2num(Answer{4}); % МЕТОД ОБЧИСЛЕННЯ ДКП
M=str2num(Answer{5}); % КІЛЬКІСТЬ НЕНУЛЬОВИХ КОЕФ. ДКП
P=str2num(Answer{6}); % ПОРОГ ДЛЯ НЕНУЛЬОВИХ КОЕФ. ДКП
TypeOutput=str2num(Answer{7});  % ВИВЕДЕННЯ РЕЗУЛЬТАТІВ

% ІНІЦІАЛІЗАЦІЯ ЗМІННИХ
OrigImage=zeros(K,K);
RestoreImage=zeros(K,K);
CoefDCT=zeros(K,K);
CoefDCTCompress=zeros(K,K);
CoefMul=zeros(N,N);

% ЗАВАНТАЖЕННЯ ПОЧАТКОВОГО ЗОБРАЖЕННЯ
RGB=imread(ImageName);
II=rgb2gray(RGB);
OrigImage=II(1:K,1:K);

% ОБЧИСЛЕННЯ ДКП
switch TypeCalc
case 1
    Time1=cputime;
    fun=@dct2;
    CoefDCT=blkproc(OrigImage,[N N],fun);
    Time2=cputime;
    fprintf('\nЧАС ОБЧИСЛЕННЯ ПРЯМОГО ДКП (СУМА) %7.3f СЕКУНД\n',Time2-Time1);
case 2
    Time1=cputime;
    CoefMul=dctmtx(N);
    fun = inline('P1*double(x)*ctranspose(P1)', 1);
    CoefDCT=blkproc(OrigImage, [N N], fun, CoefMul);
    Time2=cputime;
    fprintf('\nЧАС ОБЧИСЛЕННЯ ПРЯМОГО ДКП (МАТРИЦІ) %7.3f СЕКУНД\n',Time2-Time1);   
end
% СТИСНЕННЯ ЗОБРАЖЕННЯ
if P~=0
    CoefDCTCompress=CoefDCT;
    CoefDCTCompress((abs(CoefDCTCompress))<P)=0;
end
if M~=0
    h = waitbar(0,'СТИСНЕННЯ ЗОБРАЖЕННЯ ...');
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

% ВІДНОВЛЕННЯ ЗОБРАЖЕННЯ
switch TypeCalc
case 1
    Time1=cputime;
    fun=@idct2;
    RestoreImage=uint8(blkproc(CoefDCTCompress,[N N],fun));
    % RestoreImage=uint8(idct2(CoefDCTCompress));
    Time2=cputime;
    fprintf('ЧАС ОБЧИСЛЕННЯ ОБЕРНЕНОГО ДКП (СУМА) %7.3f СЕКУНД\n',Time2-Time1);   
case 2
    Time1=cputime;
    fun = inline('uint8(ctranspose(P1)*x*P1)', 1);
     RestoreImage=blkproc(CoefDCTCompress, [N N], fun, CoefMul);
    Time2=cputime;
    fprintf('ЧАС ОБЧИСЛЕННЯ ОБЕРНЕНОГО ДКП (МАТРИЦІ) %7.3f СЕКУНД\n',Time2-Time1);   
end

% ОБЧИСЛЕННЯ ПОХИБКИ, ЩО ВИНИКЛА В РЕЗУЛЬТАТІ СТИСНЕННЯ
ErrorDCTArray=abs(double(RestoreImage)-double(OrigImage));
ErrorDCTMean=mean2(ErrorDCTArray);
ErrorDCTSKO=sqrt((sum(sum(ErrorDCTArray.^2)))/(K*K));
ErrorDCTMax=max(max(ErrorDCTArray));
ErrorDCTMin=min(min(ErrorDCTArray));

% ОБЧИСЛЕННЯ КОЕФІЦІЄНТУ СТИСНЕННЯ
RCompress=prod(size(CoefDCTCompress))/nnz(CoefDCTCompress);
% ВИВЕДЕННЯ РЕЗУЛЬТАТІВ
if ((TypeOutput==2)|(TypeOutput==3))
	fprintf('ДИНАМІЧНИЙ ДІАПАЗОН ЯСКРАВОСТІ 255 ДИСКРЕТНИХ РІВНЕЙ\n');
	fprintf('ПОХИБКА, ЩО ВИНИКЛА В РЕЗУЛЬТАТІ СТИСНЕННЯ\n');   
	fprintf('СЕРЕДНЄ ЗНАЧЕННЯ     %7.3f ДИСКРЕТНИХ РІВНЕЙ\n', ErrorDCTMean);   
	fprintf('СЕРЕДНЬОКВАДРАТИЧНЕ ЗНАЧЕННЯ     %7.3f ДИСКРЕТНИХ РІВНЕЙ\n', ErrorDCTSKO);   
	fprintf('МІНІМАЛЬНЕ ЗНАЧЕННЯ  %7.3f ДИСКРЕТНИХ РІВНЕЙ\n', ErrorDCTMin);   
	fprintf('МАКСИМАЛЬНЕ ЗНАЧЕННЯ %7.3f ДИСКРЕТНИХ РІВНЕЙ\n', ErrorDCTMax);   
	fprintf('СТИСНЕННЯ ЗОБРАЖЕННЯ (КІЛЬКІСТЬ ВСІХ КОЕФІЦІЄНТІВ ДКП/КІЛЬКІСТЬ НУЛЬОВИХ КОЕФІЦІЄНТІВ)\n');   
	fprintf('%7.3f РАЗІВ\n', RCompress);
end
if ((TypeOutput==1)|(TypeOutput==3))
	subplot(2,2,1); imshow(OrigImage);
	subplot(2,2,2); imshow(log(abs(CoefDCT)));
     colormap(gray(256)); colorbar;
	subplot(2,2,3); imshow(RestoreImage);
	subplot(2,2,4); imshow(log(abs(CoefDCTCompress)));
     colormap(gray(256)); colorbar;
end
