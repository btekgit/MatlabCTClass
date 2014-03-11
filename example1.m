echo on;
%% CT OBJECT
% "CT" class is written to replicate numerical matrix array behaviour of
% the matlab although the data is contained in a cell array to overcome
% contiguous memory limitation of the matlab.
% Obviuously it slower than  matrix access and manipulation
% written by B. Tek 
% 22 May 2008

% This example file is usually updated. However, you can see change_log.txt 
% for the changes..


%% This example demonstrates how to use the Matlab "CT" object 
% In order to run this demo you have to put "CT" folder in matlab 
% access path. 
% and replace the scan filenames with your local ones. 
% I recommend closing figures if there are many.

%% CONSTRUCTION 

% reads a dicom series to a cell array
% first input is the folder of the series. 
% second argument flag=1  reads everything to a  cell array
%a = dicom_read_series('C:\BORAY\Lung_data\GGO_Examples_dicom\12655\S1\',1);

% use nothing for to read into a 3d array, but you may not run the whole demo for a whole
% scan set
% a = dicom_read_series('C:\BORAY\Lung_data\GGO_Examples_dicom\12655\S1\');

% for analyze images
% a =  analyze_read_to_cell('1.2.392.200036.9116.2.2.2.1762671960.1093321572.206670.hdr',1);

% read_ct_set function can read both, dicom or analyze.. included in the CT
% folder


% create a CT object
%ct_1  = CT(a);

%or better call the read_ct_set function, it creates the object inside also
%copies the file header to the info. s

fname = 'C:\BORAY\Lung_data\GGO_Examples_dicom\12655\S1\';
ct_1 = read_ct_set(fname,1)

% copy a Ct object
ct_2 = ct_1; 

% get info  
ct_info = getinfo(ct_1)


% get size 
ct_size = getsize(ct_2)
% 

% if you want to get the cell data
cell_data = cell(ct_1);

% if you like you can get the numeric array
% m = cell2mat(cell_data);


%%

%% METHODS

% the list of the methods of CT can be seen 

methods CT


%%


%% BASIC ARITHMETICS

% add two CT objects
ct_3 = ct_1+ct_2;

% subtract two CT objects
ct_4 = ct_1-ct_2;

% multiply Ct objects element by element

ct_5 = 5.*ct_1.*ct_1;

% divide ct objects element by element

ct_6 =  ct_1./ct_5;

% threshold a CT object

ct_7 = ct_1>-400; 

% compare two CT objects

ct_8 = ct_3> ct_1; 

% "or" "and" compare two CT objectss 
ct_8 = (ct_2 | ct_1 & ct_5)==ct_7;  

% replace all values with a constant. 
ct_8 = setval(ct_8, uint8(128));


% find minumun 
min_ct_8 = min(ct_8); % with index [min_ct_8, location_of_the_minimum] = min(ct_8);


% find maximum
max_ct_8 = max(ct_8); % with index [min_ct_8, location_of_the_maximum] = max(ct_8);

% sum all layers
matrix_1 = sum(ct_3); 
% matrix_1 is 2d array, of the same type (e.g.'int16') 

%%



%% DISPLAYING

% Displaying has to convert cells to 3d arrays' so it can crash 

%sliceview(ct_1);

% display another adding a figure title

sliceview(ct_2, 'CT image'); % slider controls the slice number

% display another with a scale range and a title 

sliceview(ct_2,'Scaled CT ', [-400 1500]); % 


% get 1 slide from the scan

slice_1 = getslice(ct_1,5);

% to display a slice you can use matlab display functions
figure(1);
imagesc(slice_1);

%% FILTERING
% currently 2d slice by slice filtering and 3d filtering is implemented

% for example to apply a sobel filter

flt = fspecial('sobel');
tic; ct_filtered = filter2d(ct_1,flt);toc;

% create the different filters with fspecial 
flt = fspecial('gauss',[5 5]);
tic; ct_filtered = filter2d(ct_1,flt);toc;

% 3d filtering only on the int16 inputs
flt = 1.27*ones(3,3,3);
tic; ct_filtered3d = filter3d(ct_1, flt); toc;

echo off; 

%% PIXEL ACCESS 
%Pixel access is slow
pix_1 = getpixel(ct_1,5,6,7);

% You can get entire slice instead and access it your self
tic; 
for i = 1: 512
    for j = 1:512
        cc = getpixel(ct_1,i,j,3);
    end
end
toc;

cc = getslice(ct_1,3);

tic; 

cc = getslice(ct_1,3);

for i = 1:512
    for j = 1:512
        aa = cc(i,j);
    end
end

toc;
%%
echo on; 
%% ROI 2D ACCESS
%[roi_wnd] = get_roi_mat(ct_in,x,y,sliceno,wid,hei)
%[roi_ct] = get_roi_ct(ct_in,x,y,sliceno,wid,hei)
% You can extract a 2d window  as a numeric matrice 
 tic; roi_2d= get_roi_mat(ct_1, 300, 300,100, 101); toc
 
% or as a ct object
 tic; roi_ct= get_roi_ct(ct_1, 300, 300,100, 101); toc

 figure; 
 imagesc(roi_2d);
 title('2d roi');
 
 
 
%% VOI 3D ACCESS
% [voi_mat] = get_voi_mat(ct_in,x,y,sliceno,wid,hei,dep)
% [voi_ct] = get_voi_ct(ct_in,x,y,sliceno,wid,hei,dep)

% You can extract a 2d window  as a numeric matrix 
 tic; 
 voi_3d= get_voi_mat(ct_1,300,300,100,101,101,51); 
 toc
 
% or as a ct object
 tic; 
 voi_ct= get_voi_ct(ct_1, 300,300,100,101,101,51); 
 toc

% type help get_voi_ct for the inputs
% you can also use another convention 
% [voi_ct] = get_voi_cube_ct(ct_in,y_range,x_range,slice_range)
voi_ct2 = get_voi_cube_ct(ct_1,40:60,70:80,90:100);



% display one voi's
 
sliceview(voi_ct,'VOI' ); 
 
%% TO ACCESS ALL THE VOIS OF A CT OBJECT 
echo on; 
wnd_size = [102,102,30]; % wnd_size = [y,x,z] ;  
overlap = 0 ;
% get voi centers. 
voi_list = get_voi_coordinates(ct_1,wnd_size, overlap);
echo off;
ct_2 = setval(ct_2, int16(0));
for i = 1: length(voi_list)
    % get the voi
     voi_i = get_voi_mat(ct_3,voi_list(i,1),voi_list(i,2),voi_list(i,3),wnd_size(1),wnd_size(2),wnd_size(3) );
     % process it, it is 3d matrix. 
     voi_o = abs(voi_i); 
     %sliceview(voi_o);
     % put it back
    
     ct_2 = set_voi_mat(ct_2,voi_o, voi_list(i,1),voi_list(i,2),voi_list(i,3),wnd_size(1),wnd_size(2),wnd_size(3));
end
echo off; 

%% MORPHOLOGICAL OPERATIONS 
% This area supported on int16, uint16, byte, and logical inputs
%int16, uint16, byte, and logical inputs are supported
%I run it on whole sets having up to 465 slices. It runs without any memory problem. 
%After updating your class files usage is as follows: e.g.

my_window_size =3; 
%ct_1 = read_ct_set(‘ my binary ct file’ ,1);
dilate3d(ct_1, my_window_size);
%or 
% read image 
%ct_1 = read_ct_set(‘ my HU unit file’,1);
% do very sophisticated operations resulting in binary image
ct_2 = ct_1> 1000 ;
% invoke your function
ct_2_opened = open3d(ct_2,my_window_size);

%Labelling is slightly different. No neighboorhood definition
ct_2_labelled = label3d(ct_2_opened);
%However be carefull. Label3d is very memory intensive. Although it does
%not require a continous memory, the number of binary voxels can cause a
%crash. 

%% TODO 

% abs(ct_1) absolute value. or feval in more general terms. for example sin(ct_1), cost(ct_1)
% can be implemented by feval(ct_1, 'sin');

% Note that tic's and toc's are just to measure the time passes, not cpu
% time. 


