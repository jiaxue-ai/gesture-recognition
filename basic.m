img_dir='database_ideal\';
img_file='120.JPG';
I=imread([img_dir img_file]);
I=imresize(I,[240 320]);
rgb=im2double(I);
r_bw=im2bw(I,0.4);
% turn to hsv image
% hsv=rgb2hsv(rgb);
% figure,
% imshow(hsv)
%get the hand image by h value in the hsv image
% h=hsv(:,:,1);
% r_bw=false(size(h));
% r_bw(h>0.8&h<0.96)=1;
% r_bw=bwareaopen(r_bw,200);
%remove moise by median filter
or_segimg=medfilt2(r_bw,[3 3]);
% figure
% imshow(L)
%fill the holes of the image
fin_segimg=imfill(or_segimg,'holes');
%show the segmented image
% figure
% imshow(fin_segimg),title('segment image')
% L=bwlabel(fin_segimg);
% figure
% imagesc(L)
% the contour image
[X Y]=size(fin_segimg);
contour_img=zeros(X,Y);
for x=2:X-1
    for y=2:Y-1
         if (fin_segimg(x-1,y)==0&&fin_segimg(x,y)==1&&fin_segimg(x+1,y)==1) ...
             ||(fin_segimg(x,y-1)==0&&fin_segimg(x,y)==1&&fin_segimg(x,y+1)==1) ...
             ||(fin_segimg(x-1,y)==1&&fin_segimg(x,y)==0&&fin_segimg(x+1,y)==0) ...
             ||(fin_segimg(x,y-1)==1&&fin_segimg(x,y)==0&&fin_segimg(x,y+1)==0)
            contour_img(x,y)=1;
        end
    end
end
%find the center
cen_img=zeros(X,Y);
con_step=2;
for i=1:con_step:X
    for j=1:con_step:Y
        if (fin_segimg(i,j)~=0)
            min_dist=X*Y;
            for x=1:con_step:X
                for y=1:con_step:Y
                    if(contour_img(x,y)~=0)
%                         p1=[i j];
%                         p2=[x y];
%                         dist=norm(p1-p2);
                        dist=sqrt((x-i)^2+(y-j)^2);
                        if min_dist>dist
                            min_dist=dist;
                        end
                    end
                end
            end
            cen_img(i,j)=min_dist;
        end
    end
end
r=max(max(cen_img));
[cols,rows]=find(cen_img==r);
rows=rows(1);
cols=cols(1);
%show the contour image with center
finger_img=zeros(X,Y);
for i=1:con_step:X
    for j=1:con_step:Y
        if contour_img(i,j)~=0
            if sqrt((cols-i)^2+(rows-j)^2)>1.9*r&&j>cols;
                finger_img(i,j)=1;
            end
        end
    end
end
figure
imshow(finger_img)
for i=1:con_step:X
    for j=1:con_step:Y
        if finger_img(i,j)==1
            for x=1:con_step:X
                for y=1:con_step:Y
                    if finger_img(x,y)==1
                        if (sqrt((x-i)^2+(y-j)^2)<9*con_step)&&((x~=i)||(y~=j))
                            finger_img(i,j)=0;
                        end
                    end
                end
            end
        end
    end
end
fingerx=[];
fingery=[];
% figure
% imshow(finger_img)
figure
imshow(fin_segimg),title('contour image with circle')
hold on
plotcircle(rows,cols,r)
hold on
for i=1:con_step:X
    for j=1:con_step:Y
        if finger_img(i,j)==1
            fingerx=[fingerx;i];
            fingery=[fingery;j];
            line([rows,j],[cols,i]);
            plot(j,i,'o')
        end
    end
end
finger_num=size(fingerx,1);
angle=[];
for i=1:finger_num-1
    a=[fingerx(i)-cols,fingery(i)-rows];
    b=[fingerx(i+1)-cols,fingery(i+1)-rows];
    angle1=subspace(a',b');
    angle=[angle1;angle];
end
angle_num=size(angle,1);
if(angle_num==0)
    if(finger_num==0)
        disp('palm')
    elseif(sqrt((rows-fingerx(1))^2+(cols-fingery(1))^2)>2.2*r)
    disp('one')
    else
    disp('pinky')
    end
else
for i=1:angle_num
    if (angle(i)<0.18)
        finger_num=finger_num-1;
        if(i~=angle_num)
            tmp=angle(i+1);
            angle(i+1)=angle(i)+tmp;
         angle(i)=0;
        else
           angle(i)=0;
        end
    end
end
end
if(finger_num==0)
    disp('palm')
end
    if(finger_num==1)
    if(sqrt((rows-fingerx(1))^2+(cols-fingery(1))^2)>2.2*r)
    disp('one')
    else
    disp('pinky')
    end
    end
    node=0;
    if(finger_num==4)
        for i=1:angle_num
            if(angle(i)>0.55)
                disp('3+1')
                node=1;
                break;
            end
        end
        if(node==0)
            disp('four')
        end
    elseif(finger_num==5)
        disp('five')
    end
    if(finger_num==2)
        for i=1:angle_num
    if (angle(i)~=0)
        if(angle(i)>1.2)
            disp('Y')
            break;
        elseif((angle(i)>0.6)&(angle(i)<1.2))
            disp('L')
            break;
        elseif(angle(i)<0.6)
            disp('two')
            break;
        end
    end
        end
    end
    if(finger_num==3)
        largeangle=0;
        for i=1:angle_num
            if(angle(i)>0.5)
                largeangle=largeangle+1;
            end
        end
        if(largeangle==2)
            disp('rock')
        elseif(largeangle==1)
            disp('three')
        else
            disp('w')
        end
    end