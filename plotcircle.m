function plotcircle(x,y,r)
seta=0:0.001:2*pi;
xx=x+r*cos(seta);
yy=y+r*sin(seta);
plot(xx,yy,'-',x,y,'.');
axis off

end

