function I = imsegme( file )

I=im2double(imread(file));
%turn to hsv image
I=rgb2hsv(I);
%get the hand image by h value in the hsv image
I=I(:,:,1);
I=false(size(I));
I(I>0.8&I<0.96)=1;
I=bwareaopen(I,200);
%remove moise by median filter
I=medfilt2(I,[3 3]);
% figure
% imshow(L)
%fill the holes of the image
I=imfill(I,'holes');
end

