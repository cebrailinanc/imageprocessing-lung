function originalImage=FoundLung_v1(originalImage,copyImage)


or=originalImage;
copyImage=segmentasyon(copyImage);

%copyImage(copyImage~=255)=0;

copyImage = im2bw(copyImage, 0.5);
figure(10);
imshow(copyImage,'DisplayRange',[]);
title('FoundLung_v1 AKci�erler kald�');

%ak�i�erin i�indeki g�r�lt�leri temizleme

%Determine the connected components:
CC = bwconncomp(copyImage, 8);
%Compute the area of each component:
S = regionprops(CC, 'Area');
SegmentValue=[S.Area];

segmentSize=1000;
BW2=copyImage;
if (length(SegmentValue)>1)
    
    %segmentleri b�y�kten k����e s�rala
    SegmentValue = sort(SegmentValue,'descend');
    
    %arkaplandan daha b�y�k beyaz segment temizlenir
    if ((SegmentValue(2)+1)>segmentSize)
        segmentSize=SegmentValue(2)+1;
    end
    %Remove small objects:
    L = labelmatrix(CC);
    BW2 = ismember(L, find([S.Area] >= segmentSize));

%     figure(11);
%     imshowpair(copyImage,BW2,'montage');
%     title('Ak�i�erdeki k���k beyazl�lar� temizlendi');
end
%ak�i�erin d���ndaki g�r�lt�leri temizleme
BW2=~BW2;

%Determine the connected components:
CC = bwconncomp(BW2, 8);
%Compute the area of each component:
S = regionprops(CC, 'Area');
SegmentValue=[S.Area];
%60 pikselden k���k alanlar temizlenecek
segmentSize=1000;
if (length(SegmentValue)>2)
    
    %segmentleri b�y�kten k����e s�rala
    SegmentValue = sort(SegmentValue,'descend');
    %
    if ((SegmentValue(3)+1)>segmentSize)
        segmentSize=SegmentValue(3)+1;
    end
    %Remove small objects:
    L = labelmatrix(CC);
    BW2 = ismember(L, find([S.Area] >= segmentSize));

%     figure(12);
%     imshow(BW2,'DisplayRange',[]);
%     title('Ak�i�erdeki k���k beyazl�lar� temizlendi');
end

BW2=~BW2;
figure(12);
imshow(BW2,'DisplayRange',[]);
title('FoundLung_v1 Akci�er segmentesyon');


seg= bwlabel(BW2);

% hold on;
% a=visboundaries(seg, 'Color', 'r', 'EnhanceVisibility', true, 'LineStyle', '-');
% koordinat_X=a.Children(1,1).XData;
% koordinat_Y=a.Children(1,1).YData;


%seg(uint16(koordinat_X(1,1:end-1)),uint16(koordinat_Y(1,1:end-1)))=0;
%

%ak�i�erin arkaplan�n� beyazlatma 
value=seg(1,1);

[rows, cols] = size(copyImage);
maks=max(max(originalImage));
maks
for i = 1:rows
		for j = 1:cols
			if(value==seg(i,j))
				originalImage(i,j)=700;
            end
        end
end

% for i=1:length(koordinat_X)-1
%     a=koordinat_Y(1,i);
%     b=koordinat_X(1,i);
%     if(isnan(a) || isnan(b))
%         continue;
%     end
%     originalImage(a,b)=maks;
% end
figure(15);
imshowpair(or,originalImage,'montage');
title('FoundLung_v1 segmentasyon sonucu');






function copyImage=segmentasyon(copyImage)

  [Rows, Columns] = size(copyImage);
    %akci�er�n �st k�sm�n� beyaza �evir
	for j=1:Columns
		satir=1;	
		while((copyImage(satir,j)~=255 | copyImage(satir+5,j)~=255) & satir<=(Columns-5))
			copyImage(satir,j)=255;
			satir=satir+1;
        end;	
    end;

	%akci�er�n alt k�sm�n� beyaza �evir
	for sutun=1:Columns
	
        satir=Rows;
		yatay=1;
		if (sutun<40 | sutun>Columns-30)
		
			yatay=41;
        end
        while((copyImage(satir,sutun)~=255 | copyImage(satir-10-yatay,sutun)~=255 | copyImage(satir-15,sutun)~=255)& satir>=1)
		
			copyImage(satir,sutun)=255;
			satir=satir-1;
        end		
    end
