echo on;
%% this example demonstrates how to use the Matlab "CT" object 
% written by Boray Tek 
% 21 May 2008

%% CONSTRUCTION 

% reads a dicom series to a cell array
% first input is the folder of the series. 
% second argument flag=1  reads everything to a  cell array
a = dicom_read_series('C:\BORAY\Lung_data\GGO_Examples_dicom\12655\S1\',1);

% use nothing for to read into a 3d array, but you may not run the whole demo for a whole
% scan set
% a = dicom_read_series('C:\BORAY\Lung_data\GGO_Examples_dicom\12655\S1\');

% for analyze images
% a =  analyze_read_to_cell('1.2.392.200036.9116.2.2.2.1762671960.1093321572.206670.hdr',1);

% create a CT object
ct_1  = CT(a);

% copy a Ct object
ct_2 = ct_1; 

% get info  
ct_info = getinfo(ct_1)


% get size 
ct_size = getsize(ct_2)

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

%%



%% DISPLAYING

sliceview(ct_1);

% display another adding a figure title

sliceview(ct_2, 'CT image'); % slider controls the slice number

% display another with a scale range and a title 

sliceview(ct_2,'Scaled CT ', [-400 1500]); % 

% get size of CT image 
[nslice,nrows, ncols] = getsize(ct_1)

% get 1 slide from the scan

slice_1 = getslice(ct_1,5);

% to display a slice you can use matlab display functions
figure(1);
imagesc(slice_1);

%% FILTERING
% currently 2d slice by slice filtering is implemented

% for example to apply a sobel filter

flt = fspecial('sobel');
tic; ct_filtered = filter2d(ct_1,flt);toc;

% create the different filters with fspecial 
flt = fspecial('gauss',[5 5]);
tic; ct_filtered = filter2d(ct_1,flt);toc;

echo off; 

%% PIXEL ACCESS 
%Pixel access is slow
pix_1 = getpixel(ct_1,5,6,7);

% You can get entire slice instead and access it your self
tic; 
for i = 1: 512
for j = 1:512
cc = getpixel(ct_1,3,i,j);
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
%[roi_wnd] = get_roi_mat(ct_in,sliceno,x,y,wid,hei)
%[roi_ct] = get_roi_ct(ct_in,sliceno,x,y,wid,hei)
% You can extract a 2d window  as a numeric matrice 
 tic; roi_2d= get_roi_mat(ct_1, 100, 300, 300, 101); toc
 
% or as a ct object
 tic; roi_ct= get_roi_ct(ct_1, 100, 300, 300, 101); toc

 figure; 
 imagesc(roi_2d);
 title('2d roi');
 
 
 
%% VOI 3D ACCESS
% [voi_mat] = get_voi_mat(ct_in,sliceno,x,y,wid,hei,dep)
% [voi_ct] = get_voi_ct(ct_in,sliceno,x,y,wid,hei,dep)

% You can extract a 2d window  as a numeric matrice 
 tic; 
 voi_3d= get_voi_mat(ct_1, 100,300,300,101,101,51); 
 toc
 
% or as a ct object
 tic; 
 voi_ct= get_voi_ct(ct_1, 100,300,300,101,101,51); 
 toc

% type help get_voi_ct for the inputs
 
sliceview(voi_ct,'VOI' ); 
 

 

echo off; 


%% TODO 
% summation 
% sum(ct_1) to perform summming all along the axis , i.e. plus{slice(ct_1:end))

% abs(ct_1) absolute value. or feval in more general terms. for example sin(ct_1), cost(ct_1)
% can be implemented by feval(ct_1, 'sin');

% to implement dicom, analyze header friendly info header. resolutions.

% filtering 3d to come...

% difference or derivative
% diff(ct_1) 

% Note that tic's and toc's are just to measure the time passes, not cpu
% time. 


