function [A, inf] =  dicom_read_series(dirname,bcell)
% [A, inf] =  dicom_read_series(dirname,bcell)
% the difference from the not big one is that this one reads everything to
% a cell directly does not use array at all
% may take more time.
% reads all dicom files in a folder, directory
% dirname is the directory or  one of the
% files. e.g. give the first file name it searches for the rest.
% First version assumes all the files in a directory are in the same series.
% returns
% A:matrix
% inf: dicom info
% b_cell: is boolean flag tells function to read the series into a cell
% array such that every slice is a pointed 2d array, just for memory efficiency. When we
% do this we do not need to reserve a big chunk of memory, but individual
% memories for each slice. Of course you are still limited with the

% $Revision by B.Tek, 22.05.08
% will add the read ability from first file in a series
% input can be  a file name in the directory

% $Revision by B.Tek, 30.05.08
% removing .dcm file constraint. adding .dcm and no extension

% $Revision: 30.05.08
% changing everything so it does not read an array at all.
% written: B.Tek

% $Revision: 06.06.08
% adding RescaleSlope and RescaleIntercept Scaling.
% written:  B.Tek

% $Revision: 17.06.08
% adding orientation correction
% B.Tek

% $Revision: 19.06.08
% adding Z resolution correction, by calculating diff of ImagePositionPat.
% PixelSpacing = [ x_resolution y_resolution z_resolution];
% adding PixelPadding update if the rescale happens.
% B.Tek

% $Revision: 17.02.13
% added help copyright info, B.Tek


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



if(exist(dirname,'dir'))
    dir_list = dir(dirname);
    dir_length = length(dir_list);
elseif (exist(dirname,'file'))
    % find the last slash
    indx_dir_slash = find(dirname=='\');
    dirname = dirname(1:indx_dir_slash(end));
    dir_list = dir(dirname);
    dir_length = length(dir_list);
else
    disp(strcat(dirname, ' not found ' ));
end

first_file = dir_list(3).name;
inf = dicominfo(strcat(dirname,first_file)); % read dicom
nrows = double(inf.Height);
ncols = double(inf.Width);

% this field is to rescale the values to Hounslow units.
% to values are used for a linear transformation.
RescaleSlope = 1;
RescaleIntercept = 0;

if(isfield(inf,'RescaleSlope'))
    RescaleSlope = inf.RescaleSlope;
else
    warning('RescaleSlope field not found'); %#ok<WNTAG>
end
if (isfield(inf,'RescaleIntercept'))
    RescaleIntercept = inf.RescaleIntercept;
else
    warning('RescaleSlope field not found'); %#ok<WNTAG>
end

% this is to understand whether the data is signed or not, value 1
% represents signed, if it is unsigned we do not care we typecast it to
% int16. <-B.T->
PixelRepresentation = 1;
if(isfield(inf,'PixelRepresentation'))
    PixelRepresentation = inf.PixelRepresentation;
end

% this stupid which is not guarenteed to exist in all the fields and may
% not be same type as the data, is to show padded value outside the
% acquisition tube. <-B.T->
PixelPaddingValue = [];
if(isfield(inf,'PixelPaddingValue'))
    PixelPaddingValue = inf.PixelPaddingValue;
    if(PixelRepresentation ==1 & isa(PixelPaddingValue,'uint16'))
        PixelPaddingValue = int16(double(PixelPaddingValue)-double(2^double(inf.BitDepth)));
        if ((RescaleSlope==1)&(RescaleIntercept==0))
            PixelPaddingValue =  RescaleSlope.*PixelPaddingValue+RescaleIntercept;
        end
    end
end


% This is to find the orientation of the image.
ImageOrientationPatient = [1 0 0; 0 1 0]; %#ok<NASGU>
rotate_flag =0;
x_rot = 0;
y_rot = 0;
if(isfield(inf, 'ImageOrientationPatient'))
    ImageOrientationPatient = inf.ImageOrientationPatient;
    v_angles = acosd(ImageOrientationPatient);
    x_rot = v_angles(1);
    y_rot = v_angles(5);
    if (rem(x_rot,90)~=0 | rem(y_rot,90)~=0)
        warning('Complex Orientation info in the Header, skipping orientation correction');
        rotate_flag =0; % no correction
    elseif ((x_rot==0) & (y_rot==0))
        rotate_flag =0; % no correction
    elseif ((x_rot==180) & (y_rot==180))
        rotate_flag =1; % both needs rotate
    elseif ((x_rot==180))
        rotate_flag =2; % x needs flipping
    elseif((y_rot==180))
        rotate_flag =3; % y needs flipping
    else
        warning('Unhandled orientation condition, images may be not oriented correctly and the physical resolution values can be wrong');
    end
end



%btdepth = double(inf.BitDepth);
k = 1;

if(isfield(inf,'ImplementationClassUID'))
    classUID  = inf.ImplementationClassUID;
elseif (isfield(inf,'SOPClassUID'))
    classUID  = inf.SOPClassUID;
else
    disp('Implementationclassuid or SOPclassuid not found');
end

I = find(first_file=='.');
nodot = isempty(I);

I(dir_length-2) = 0;
filename_list = cell(dir_length-2,1);

for i= 3:dir_length
    fname = dir_list(i).name;
%     no_dcm_ext = ~strcmp(fname(end-2:end),'dcm');
%     no_txt_ext = 
%     if (no_dcm_ext && (~nodot)) %% warning if there is no  extension it does not check the series.
%         continue;
%     end
    try
    Infoo = dicominfo(strcat(dirname,'\', fname));
    catch 
        warning(strcat('Not valid Dicom file: unable to read infoo, skipping file ',fname));
        continue;
    end
    if(isfield(inf,'ImplementationClassUID'))
        uid  = Infoo.ImplementationClassUID;
    elseif (isfield(inf,'SOPClassUID'))
        uid  = Infoo.SOPClassUID;
    else
        disp('Implementationclassuid or SOPclassuid not found');
    end
    if (strcmp(classUID, uid))
        %I(k)= abs(Infoo.SliceLocation);
        I(k) = Infoo.SliceLocation;
        filename_list{k} = strcat(dirname,'\', fname);
        % do not read the file here, first order it then read later
        %A(:,:,k) = dicomread(strcat(dirname,'\', fname));
        k = k+1;
        fname;
    else
        disp(strcat(fname,'Class UID does not match'));
    end
end


if ((k-1)~= dir_length-2)
    I = I(1:k-1); % valid portion
end
[I2 indx] = sort(I,2,'ascend'); % sort the slice locations.
len = length(I2);
filename_list_sorted =cell(len,1);
for i =1 :len
    filename_list_sorted{i} = filename_list{indx(i)}; % re index A...
end


% This is to find the z axis resolution  assuming there is no flipped axis
% in z direction , if there is then this calculation will be wrong, check
% if there is any warnings about thee complex orientation <-B.T->
info1 = dicominfo(filename_list_sorted{1});
info2 = dicominfo(filename_list_sorted{2});
if(isfield(info1, 'ImagePositionPatient') & isfield(info2, 'ImagePositionPatient') )
    zz=info1.ImagePositionPatient-info2.ImagePositionPatient;
    info1.PixelSpacing=[info1.PixelSpacing(1) info1.PixelSpacing(2) abs(zz(3))];
else
    info1.PixelSpacing=[info1.PixelSpacing(1) info1.PixelSpacing(2) info.SliceThickness];
end
inf = info1; % this is to return first header in the series; I know it is
inf.PixelPaddingValue = PixelPaddingValue; % update the pixelpaddding value with the one calculated here. 
%not the best way.



% now read to cell directly
A = cell(len,1);

if ((RescaleSlope==1)&(RescaleIntercept==0))
    for i = 1: len
        rd = dicomread(filename_list_sorted{i});
        rd = rotate_with_flag(rd,rotate_flag,x_rot, y_rot);
        if ((PixelRepresentation~=1) & isa(rd(1,1),'uint16'))
            rd = int16(rd);
        end
        A{i} = rd;
    end
else
    for i = 1: len
        rd = dicomread(filename_list_sorted{i});
        rd = rotate_with_flag(rd,rotate_flag,x_rot, y_rot);
        if ((PixelRepresentation~=1) & isa(rd(1,1),'uint16'))
            rd= int16(rd);
        end
        rd = RescaleSlope.*rd+RescaleIntercept;
        A{i} = rd;
    end
end

disp(strcat(int2str(len), ' slices read  from : ',dirname));

if (nargin ==2)
    if(bcell ==0)
        %should convert back to array
        for i = len:-1:1
            B(:,:,i) = A{i};
        end
        A = B; % we have the numeric
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function A = rotate_with_flag(A, flg, xrot, yrot)
if (flg)
    switch flg
        case 1
            A = rot90(A,2);
        case 2
            A = fliplr(A);
        case 3
            A = flipud(A);
    end
end

%%% Not used 
function A = correct_padding_value(A, val, newval)
A(A==val)= newval;
