clc;
clear;
clear all;
close all;

path='C:\Users\cc\Desktop\segmentasyon\15-5-2015bt\SE000002\CT000022';
%path='C:\Users\cc\Desktop\segmentasyon\15-5-2015bt\SE000002\CT000025';
%path='C:\Users\cc\Desktop\segmentasyon\29-12-2015bt\SE000003\CT000035';
%path='C:\Users\cc\Desktop\segmentasyon\11-3-2015\SE000000\CT000011';
%path='C:\Users\cc\Desktop\segmentasyon\29-12-2015bt\SE000003\CT000016';


info = dicominfo(path);
imgHdr = dicominfo(path);
imgHdr
intercept = dicomlookup('0028', '1052')
slope = dicomlookup('0028', '1053')
metadata = dicominfo(path);
metadata.(dicomlookup('0028', '1052'))

metadata.(dicomlookup('0028', '1051'))
metadata.(dicomlookup('0028', '1050'))

readimage = dicomread(path);    %CT görüntüsünü okuma

image = int16(readimage) - 1024;    % hounsfield  scalasýna cevirme 
original_image=image; 

image(image>-140) = 255;  %kemikli bölge belirginleþtiridi.
minimum=min(image(:));
image(480:end,:)=minimum;       %tomografi görüntülerinde çýkan sedyeyi yok etme

figure(1);
imshow(original_image,[]);
title('Orjinal CT   ');

% lungCT=image;
% 
% %lung CT values Ww 1500    Wc -600
% 
% lungCT(lungCT>1200)=1200;
% lungCT(lungCT<-600)=-600;

% figure(1);
% imshowpair(readimage,lungCT,'montage');
% title('Orjinal CT            lung CT values Ww 1500    Wc -600');

%akciðeri görüntüleme
figure(2);
imshow(image,'DisplayRange',[]);
title('HU -140 dan büyük olan bölge beyazyapýldý ');

%2 defa median filtre ile gürültüler atýlýr.
image = medfilt2(image, [9 9]);

lung=FoundLung_v1(original_image,image);

%segmente edilmiþ akçiðerde circle arama
figure(3);
imshow(lung,[]);
title('segmentasyon Akciðer Sonucu akciðerler ');

[c, r] = imfindcircles(lung, [1 5], 'ObjectPolarity','dark','Sensitivity', 0.94);
figure(4);
title('lung');
imshow(lung,[]);
str = sprintf('lung   circle arama circle sayisi :%d/',size(r,1));
title(str);
viscircles(c,r);
size(r,1)
fark=original_image-lung;

figure(5);
imshowpair(fark,lung,'montage');
title('akçiðer farkýý')
lungImage=lung;

%lung CT values Ww 1500    Wc -600

lungCT=lung;
lungCT(lungCT>1200)=1200;
lungCT(lungCT<-600)=-600;

figure(6);
imshowpair(lungCT,lungCT,'montage');
[c, r] = imfindcircles(lungCT, [1 5], 'ObjectPolarity','dark','Sensitivity', 0.94);
viscircles(c,r);
str = sprintf('lung CT values Ww 1500    Wc -600circle araMa #CÝRCLE :%d/',size(r,1));
title(str);



%damarlarý temizleme
clearlung=clearVessel_v1(lung);

figure(7);

imshow(clearlung,[]);
title('damarlar temizlenmiþ akciðer');

% [c, r] = imfindcircles(clearlung, [1 5], 'ObjectPolarity','dark','Sensitivity', 0.94);
[c, r] = imfindcircles(clearlung, [1 5],'ObjectPolarity','dark','Sensitivity', 0.94);


counter = 0;
k = 1;
realSize=size(c);
realSize=realSize(1);
kalacaklarMerkez = zeros(realSize,2);
kalacaklarYaricap = zeros(realSize,1);
for i=1:realSize
    counter=0;
	for j=1:realSize
        if(i==j)
            continue;
        elseif( sqrt(((c(i,1)-c(j,1)))^2 + (c(i,2)-c(j,2))^2 ) - 10  < r(i,1)+r(j,1))
%                 kalacaklarMerkez(k,1)=c(i,1);
%                 kalacaklarMerkez(k,2)=c(i,2);
%                 kalacaklarYaricap(k)=r(i);
%                 k=k+1;
                counter=counter+1;
        end;
    end;
    if(counter>1)
        kalacaklarMerkez(k,1)=c(i,1);
        kalacaklarMerkez(k,2)=c(i,2);
        kalacaklarYaricap(k)=r(i);
        k=k+1;
    end
end;

lastNonZero = find(kalacaklarYaricap, 1, 'last');
lastNonZero
kalacaklarMerkez(lastNonZero+1:realSize,:)=[];
kalacaklarYaricap(lastNonZero+1:realSize)=[];


%viscircles(kalacaklarMerkez,kalacaklarYaricap);
%
figure(8);
imshow(clearlung,[]);
str = sprintf('her çemberin merkezinde 10 piksel yakýn 2 den fazla circle:%d/',size(kalacaklarYaricap,1));
title(str);
viscircles(kalacaklarMerkez,kalacaklarYaricap);



figure(9);
title('lung');
imshow(clearlung,[]);
str = sprintf('clearlung  circle arama circle sayisi :%d/',size(r,1));
title(str);
viscircles(c,r);
size(r,1)

www=clearlung;
lung_www=www;
lung_www(lung_www==1100)=0;
figure(87);
title('www');
imshow(www,[]);

figure(88);
title('www');
imshow(lung_www,[]);

[c, r] = imfindcircles(lung_www, [1 5], 'ObjectPolarity','dark','Sensitivity', 0.94);
figure(89);
title('lung');
imshow(lung_www,[]);
str = sprintf('clearlung  circle arama circle sayisi :%d/',size(r,1));
title(str);
viscircles(c,r);
size(r,1)

