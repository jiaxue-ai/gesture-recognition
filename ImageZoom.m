function I=ImageZoom(I1,x,y)
%���ܣ�ʵ��ͼ������ⱶ������
%x---ˮƽ����ϵ��
%y---��ֱ����ϵ��

if length(size(I1))>2
I1=rgb2gray(I1);
end

figure,imshow(I1);
[m,n]=size(I1);

newWidth=round(x*m);
newHeight=round(x*n);

T=[x 0 0;0 y 0;0 0 1];
tform=maketform('affine',T);

tx=zeros(newWidth,newHeight);
ty=zeros(newWidth,newHeight);
for i=1:newWidth
for j=1:newHeight
tx(i,j)=i;
ty(i,j)=j;
end
end

[w z]=tforminv(tform,tx,ty); %��������ֵ

I=uint8(zeros(newWidth,newHeight));

%����ͼ������ص㸳ֵ
for i=1:newWidth
for j=1:newHeight
S_x=w(i,j);
S_y=z(i,j);
if(S_x>=m-1||S_y>=n-1||double(uint16(S_x))<=0||double(uint16(S_y))<=0) 
I(i,j)=0; %����ԭͼ����
else
if (S_x/double(uint16(S_x))==1.0&S_y/double(uint16(S_y))==1.0)
I(i,j)=I1(uint16(S_x),uint16(S_y));%������
else
%����������
a=double(uint16(S_x));
b=double(uint16(S_y));
u=S_x-a;
v=S_y-b;
x11=double(I1(a,b));
x12=double(I1(a,b+1));
x21=double(I1(a+1,b));
x22=double(I1(a+1,b+1));
I(i,j)=uint8((1-u)*(1-v)*x11+(1-u)*v*x12+u*(1-v)*x21+u*v*x22);
end
end
end
end

figure,imshow(I)
