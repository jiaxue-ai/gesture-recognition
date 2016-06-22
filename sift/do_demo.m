
% This m-file demoes the usage of SIFT functions. This demo shows how
% effective SIFT can be when the images have small viewpoint differences
% It basically takes 2
% images as input and perform image matching based on SIFT. 
% 
% Author: Yantao Zheng. Nov 2006.  For Project of CS5240
% 


% Add subfolder path.
main :
data1_dir = 'data\';
data2_dir = 'data\';
data3_dir = 'data\';

data1_file = 'one.JPG';
data2_file = 'two.JPG';
data3_file = 'three.JPG';

%segment the image
I1=imsegme([data1_dir data1_file]) ; 
I2=imsegme([data2_dir data2_file]) ;
I3=imsegme([data3_dir data3_file]) ;

%resize the image
I1=imresize(I1, [240 320]);
I2=imresize(I2, [240 320]);
I3=imresize(I3, [240 320]);


I1=I1-min(I1(:)) ;
I1=I1/max(I1(:)) ;
I2=I2-min(I2(:)) ;
I2=I2/max(I2(:)) ;
I3=I3-min(I3(:)) ;
I3=I3/max(I3(:)) ;

%fprintf('CS5240 -- SIFT: Match image: Computing frames and descriptors.\n') ;
[frames1,descr1,gss1,dogss1] = do_sift( I1, 'Verbosity', 1, 'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ; %0.04/3/2
[frames2,descr2,gss2,dogss2] = do_sift( I2, 'Verbosity', 1, 'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ;


fprintf('Computing matches.\n') ;
descr1 = descr1';
descr2 = descr2';

tic ; 

matches=do_match(I1, descr1, frames1',I2, descr2, frames2' ) ;
fprintf('Matched in %.3f s\n', toc) ;


