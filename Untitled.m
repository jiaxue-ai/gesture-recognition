%<span style="font-size:18px;">clc
close all

vidobj = videoinput('winvideo',1,'YUY2_320x240');
triggerconfig(vidobj,'manual');
start(vidobj);
tic 
for i = 1:1000
     snapshot = getsnapshot(vidobj);
     frame = ycbcr2rgb(snapshot);
     x=1
     imshow(frame);
      pause(0.5);
end
elapsedTime = toc
timePerFrame = elapsedTime/1000
effectiveFrameRate = 1/timePerFrame

stop(vidobj);
delete(vidobj);
disp('end');