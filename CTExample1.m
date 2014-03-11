echo on;
%% This example demonstrates how to use the Matlab "CT" class objects 
% Type 'help @CT' to see full function list of the CT class
% or type methods CT
% written by F. Boray Tek 
% 27 Feb 2013

% Copyright 2008-2013 F. Boray Tek.
% All rights reserved.
%
% This file is part of CT class.
%
% CT class is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% CT class is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

% You should have received a copy of the GNU General Public License
% along with CT class.  If not, see <http://www.gnu.org/licenses/>.

%% CONSTRUCTION 

% reads a dicom series to a cell array
% first input is the folder of the series. 
% second argument flag=1  reads everything to a  cell array
%a = dicom_read_series('fullpath',1);

% create a CT object from an analyze  file
ct_1= read_ct_set('testCT.hdr',1);




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
[s1,s2,s3] = size(ct_1)
for i = 1: s1
for j = 1:s2
cc = getpixel(ct_1,i,j,1);
end
end
toc;


tic; 

cc = getslice(ct_1,1);

for i = 1:s1
for j = 1:s2
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
 tic; roi_2d= get_roi_mat(ct_1, 50, 50, 10, 1); toc
 
% or as a ct object
 tic; roi_ct= get_roi_ct(ct_1, 50, 50, 10, 1); toc

 figure; 
 imagesc(roi_2d);
 title('2d roi');
 
 
 
%% VOI 3D ACCESS
% [voi_mat] = get_voi_mat(ct_in,sliceno,x,y,wid,hei,dep)
% [voi_ct] = get_voi_ct(ct_in,sliceno,x,y,wid,hei,dep)

% You can extract a 2d window  as a numeric matrice 
 tic; 
 voi_3d= get_voi_mat(ct_1, 50,50,5,20,20,3); 
 toc
 
% or as a ct object
 tic; 
 voi_ct= get_voi_ct(ct_1, 50,50,5,20,20,3); 
 toc

% type help get_voi_ct for the inputs
 
sliceview(voi_ct,'VOI' ); 
 

 

echo off; 



