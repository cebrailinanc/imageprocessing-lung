function clearlung=clearVessel_v1(lung)


%akçiðerler siyah arka plan beyaz yapýldý
tmp = lung;
%maks=max(lung(:));
tmp(tmp~=700)=0;
tmp(tmp==700)=255;

figure(100);
imshow(tmp,[]);
title('akciðer sýnýrlarý belirleme');
hold on;
borderLung=visboundaries(tmp, 'Color', 'r', 'EnhanceVisibility', true, 'LineStyle', '-'); %akçiðerin sýnýrlarý
hold off;

%akciðerdeki damarlarý belirginleþtirme
lung(lung>-140) = 255;
originalImage=lung;
figure(101);
imshow(lung,'DisplayRange',[]);
title('clearVessel_v1 lung(lung>-140) = 255; damarlar belirginleþti ');
hold on;
visboundaries(tmp, 'Color', 'r', 'EnhanceVisibility', true, 'LineStyle', '-');
hold off;


tresholdImage = im2bw(lung, 0.5);% akciðer,damar ve   arka planý ayýrma


koordinat_X=borderLung.Children(1,1).XData;
koordinat_Y=borderLung.Children(1,1).YData;
for i=1:length(koordinat_X)
    a=koordinat_Y(1,i);
    b=koordinat_X(1,i);
    if(isnan(a) || isnan(b))
        continue;
    end
    tresholdImage(a,b)=0;
end

figure(99);
imshow(tresholdImage,[]);
title('vessel tresholdImage');

[L, num] = bwlabel(tresholdImage,8);

num
RGB = label2rgb(L, @jet,  'k');
figure(98);
title('connected component labeling uy');
imshow(RGB,[]);

%Determine the connected components:
CC = bwconncomp(tresholdImage, 8);
%Compute the area of each component:
S = regionprops(CC, 'Area');
SegmentValue=[S.Area];
L = labelmatrix(CC);
BW2 = ismember(L, find([S.Area] >= 100)); %akçiðerde 80 pikselden küçük alankarý temizleme 
    
[L, num] = bwlabel(BW2,8);
num
RGB = label2rgb(L, @jet,  'k');
figure(97);
imshow(RGB,[]);
title('akçiðerde 80 pikselden küçük alankarý temizlendi');

background_r=RGB(2,2,1);
background_g=RGB(2,2,2);
background_b=RGB(2,2,3);

[rows, cols] = size(originalImage);
clearlung=originalImage;
minimum=min(originalImage(:));
minimum
maksimum=max(originalImage(:));
maksimum
figure(90);
imshow(originalImage,[]);
title('originalImage');
for i = 1:rows
		for j = 1:cols
        
			if((0==RGB(i,j,1) & 0==RGB(i,j,2) & 0==RGB(i,j,3)) )
				clearlung(i,j)=originalImage(i,j);
            elseif  (background_r==RGB(i,j,1) & background_g==RGB(i,j,2) & background_b==RGB(i,j,3))
               	clearlung(i,j)=1100;
            else
                clearlung(i,j)=minimum;
            end
        end
end

figure(96);
imshowpair(originalImage,clearlung,'montage');
title('clear vessel')

