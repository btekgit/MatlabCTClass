function anwritehdr(filestub, hdr)
% Write an ANALYZE format header
%
% anwritehdr(filestub, hdr)
%
% ARGS:
% hdr = header structure must contain the following elements:
%    .dim   = dimension vector for s (eg [256 256 128])
%
% and may contain the followin elements:
%    .vsize = voxel size vector for s (eg [0.5 0.5 0.2])
%    .cal   = calibrated intensity range of s (eg [max min] = [1 0])
%    .vox   = voxel intensity range of s (eg [max min] = [255 0]);
%    .datatype = ANALYZE datatype enum (eg 4 = int16)
%    .desc    = study description (cropped to 80 chars)
%    .orig    = originator (eg CIT_BIC) (cropped to 10 chars)
%    .scannum = scan number (cropped to 10 chars)
%    .pid     = patient id (cropped to 10 chars)
%    .expdate = experiment date (cropped to 10 chars)
%    .exptime = experiment time (cropped to 10 chars)
%
% AUTHOR: Mike Tyszka, Ph.D.
% PLACE : California Institute of Technology
% DATES : 11/15/2000 JMT From scratch (see Mayo Clinic ANALYZE format page)
%         02/28/2001 JMT Add .cal and .vox header fields
%         08/05/2002 JMT Add 32-bit integer support
%         12/01/2003 JMT Add support for history fields within hdr
%         08/06/2004 JMT Write calibration scale and offset to SPM header
%                        fields.
%         04/12/2005 JMT Correct spm_offset in header
%         01/23/2006 JMT M-Lint corrections
%
% Copyright 2000-2006 California Institute of Technology.
% All rights reserved.
%
% This file is part of AnUtils.
%
% AnUtils is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% AnUtils is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with AnUtils; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

fname = 'anwritehdr';

if nargin < 2
  fprintf('%s requires at least two input arguments\n', fname);
  return
end

if isempty(hdr) || ~isfield(hdr,'dim')
  fprintf('%s requires a header containing image dimensions\n', fname);
  return
end

% Upgrade 2D images to 3D by adding singleton dimension
if length(hdr.dim) == 2
  hdr.dim(3) = 1;
end
if length(hdr.vsize) == 2
  hdr.vsize(3) = 1;
end
  
% Tidy up hdr structure if necessary
if ~isfield(hdr,'vsize'); hdr.vsize = [1 1 1]; end
if ~isfield(hdr,'vox'); hdr.vox = [255 0]; end
if ~isfield(hdr,'datatype'); hdr.datatype = 4; end
if ~isfield(hdr,'desc'); hdr.desc = 'None'; end
if ~isfield(hdr,'orig'); hdr.orig = round(hdr.dim(1:3)/2.0); end
if ~isfield(hdr,'scannum'); hdr.scannum = 'None'; end
if ~isfield(hdr,'pid'); hdr.pid = 'None'; end
if ~isfield(hdr,'generated'); hdr.generated = datestr(now,23); end
if ~isfield(hdr,'expdate'); hdr.expdate = 'Unknown'; end
if ~isfield(hdr,'exptime'); hdr.exptime = 'Unknown'; end

% Calibrated scaling defaults to range 0..1 if not supplied
if ~isfield(hdr,'cal'); hdr.cal = [1 0]; end

% Calculate SPM scale
spm_scale  = (hdr.cal(1) - hdr.cal(2))/(hdr.vox(1) - hdr.vox(2));

% SPM offset is simply hdr.cal(2) = min(s);
spm_offset = hdr.cal(2);

% Byte offset to beginning of data within .img file
vox_offset = 0;

% Make dim and vsize row vectors of length 3
hdr.dim = reshape(hdr.dim(1:3),[1 3]);
hdr.vsize = reshape(hdr.vsize(1:3),[1 3]);

% Set bits-per-pixel from datatype
switch hdr.datatype
case 2
  hdr.bits_pixel = 8;
case 4
  hdr.bits_pixel = 16;
case {8,16,64}
  hdr.bits_pixel = 32;
otherwise
  % Reset to type 4 if not 2,4 or 8
  hdr.datatype = 4;
  hdr.bits_pixel = 16;
end

% Create header filename
anahdrfile = [filestub '.hdr'];

% Write header file as little endian
fd = fopen(anahdrfile, 'w', 'ieee-le');

% Header key structure
fwrite(fd, 348, 'uint32'); % Header length [0 + 4]
fprintf(fd, '%10s', 'MRI'); % Data type [4 + 10]
fprintf(fd, '%18s', 'Unknown'); % Database [14 + 18]
fwrite(fd, 16384, 'uint32'); % Extents [32 + 4]
fwrite(fd, 0, 'uint16'); % Unused [36 + 2]
fprintf(fd, '%c', 'r'); % Regular [38 + 1]
fprintf(fd, '%c', 0); % Unused [39 + 1]

% Image dimension structure
fwrite(fd, [3 hdr.dim 1 0 0 0], 'uint16'); % Dimensions [0 + 16]
fwrite(fd, zeros(1,7), 'uint16'); % [16 + 14]
fwrite(fd, hdr.datatype, 'uint16'); % data type [30 + 2]
fwrite(fd, hdr.bits_pixel, 'uint16'); % bits/pixel [32 + 2]
fwrite(fd, 0, 'uint16'); % [34 + 2]
fwrite(fd, [3 hdr.vsize 0 0 0 0], 'float'); % [36 + 32]
fwrite(fd, vox_offset, 'float'); % SPM Voxel offset [68 + 4]
fwrite(fd, spm_scale, 'float'); % SPM scale [72 + 4]
fwrite(fd, spm_offset, 'float'); % SPM offset [76 + 4]
fwrite(fd, 0, 'float'); % Unused [80 + 4]
fwrite(fd, hdr.cal, 'float'); % Cal max, min [84 + 8]
fwrite(fd, 0, 'int32'); % Compressed [92 + 4]
fwrite(fd, 1, 'int32'); % Verified [96 + 4]
fwrite(fd, hdr.vox, 'int32'); % Max, Min [100 + 8]

% Data hdr structure
fwrite(fd, padstring(hdr.desc,80), 'char');
fwrite(fd, repmat(' ',[1 24]), 'char'); % Aux file
fwrite(fd, 0, 'char'); % Orientation (axial unflipped)

% Originator field replaced in SPM by 5 int16 fields
% origin[0..2] are the X,Y,Z coordinates in voxels of
% the midline anterior commisure.
fwrite(fd, [hdr.orig(1) hdr.orig(2) hdr.orig(3) 0 0], 'int16'); % AC-defined origin

fwrite(fd, padstring(hdr.generated,10), 'char'); % Generated
fwrite(fd, repmat(' ',[1 10]), 'char'); % Scan number
fwrite(fd, padstring(hdr.pid,10), 'char'); % Patient ID
fwrite(fd, padstring(hdr.expdate,10), 'char'); % Expt date
fwrite(fd, padstring(hdr.exptime,10), 'char'); % Expt time
fwrite(fd, repmat(' ',[1 3]), 'char'); % Hist UN0
fwrite(fd, 1, 'int32'); % Views
fwrite(fd, 1, 'int32'); % Vols added
fwrite(fd, 1, 'int32'); % Start field
fwrite(fd, 1, 'int32'); % Field skip
fwrite(fd, [0 1], 'int32'); % Omax, Omin
fwrite(fd, [0 1], 'int32'); % Smax, Smin

fclose(fd);

%----------------------------------------------------------
% Utility function to crop or pad a string to n characters
%----------------------------------------------------------

function b = padstring(a,n)

b = repmat(' ',[1 n]);
na = length(a);
if na > n; na = n; end
b(1:na) = a(1:na);

return

%----------------------------------------------------------
% ANALYZE .hdr format specification
%
% FROM: http://www.mayo.edu/bir/Analyze_Pages/AnalyzeFileInfo.html
%
% /*    ANALYZETM
%  Header File Format
%  *
%  *
%  *  (c) Copyright, 1986-1995
%  *  Biomedical Imaging Resource
%  *  Mayo Foundation
%  *
%  *
%  *  dbh.h
%  *
%  *
%  *
%  *  databse sub-definitions
%  */
%
%
% struct header_key                       /* header key   */ 
%       {                                /* off + size      */
%       int sizeof_hdr                   /* 0 + 4           */
%       char data_type[10];              /* 4 + 10          */
%       char db_name[18];                /* 14 + 18         */
%       int extents;                     /* 32 + 4          */
%       short int session_error;         /* 36 + 2          */
%       char regular;                    /* 38 + 1          */
%       char hkey_un0;                   /* 39 + 1          */
%       };                               /* total=40 bytes  */
% struct image_dimension 
%       {                                /* off + size      */
%       short int dim[8];                /* 0 + 16          */
%       short int unused8;               /* 16 + 2          */
%       short int unused9;               /* 18 + 2          */
%       short int unused10;              /* 20 + 2          */
%       short int unused11;              /* 22 + 2          */
%       short int unused12;              /* 24 + 2          */
%       short int unused13;              /* 26 + 2          */
%       short int unused14;              /* 28 + 2          */
%       short int datatype;              /* 30 + 2          */
%       short int bitpix;                /* 32 + 2          */
%       short int dim_un0;               /* 34 + 2          */
%       float pixdim[8];                 /* 36 + 32         */
%                       /* 
%                            pixdim[] specifies the voxel dimensitons: 
%                            pixdim[1] - voxel width
%                            pixdim[2] - voxel height
%                            pixdim[3] - interslice distance
%                                ...etc
%                       */
%       float vox_offset;                /* 68 + 4          */
%       float funused1;                  /* 72 + 4          */
%       float funused2;                  /* 76 + 4          */
%       float funused3;                  /* 80 + 4          */
%       float cal_max;                   /* 84 + 4          */
%       float cal_min;                   /* 88 + 4          */
%       float compressed;                /* 92 + 4          */
%       float verified;                  /* 96 + 4          */
%       int glmax,glmin;                 /* 100 + 8         */
%       };                               /* total=108 bytes */
% struct data_hdr       
%       {                                /* off + size      */
%       char descrip[80];                /* 0 + 80          */
%       char aux_file[24];               /* 80 + 24         */
%       char orient;                     /* 104 + 1         */
%       char originator[10];             /* 105 + 10        */
%       char generated[10];              /* 115 + 10        */
%       char scannum[10];                /* 125 + 10        */
%       char patient_id[10];             /* 135 + 10        */
%       char exp_date[10];               /* 145 + 10        */
%       char exp_time[10];               /* 155 + 10        */
%       char hist_un0[3];                /* 165 + 3         */
%       int views                        /* 168 + 4         */
%       int vols_added;                  /* 172 + 4         */
%       int start_field;                 /* 176 + 4         */
%       int field_skip;                  /* 180 + 4         */
%       int omax, omin;                  /* 184 + 8         */
%       int smax, smin;                  /* 192 + 8         */
%       };
% struct dsr
%      { 
%       struct header_key hk;            /* 0 + 40          */
%       struct image_dimension dime;     /* 40 + 108        */
%       struct data_hdr hist;        /* 148 + 200       */
%       };                               /* total= 348 bytes*/
%
% /* Acceptable values for datatype */
%
% #define DT_NONE                  0
% #define DT_UNKNOWN               0
% #define DT_BINARY                1
% #define DT_UNSIGNED_CHAR         2
% #define DT_SIGNED_SHORT          4
% #define DT_SIGNED_INT            8
% #define DT_FLOAT                 16
% #define DT_COMPLEX               32
% #define DT_DOUBLE                64
% #define DT_RGB                   128
% #define DT_ALL                   255
%
% typedef struct
%       { 
%        float real;
%        float imag;
%       } COMPLEX;
%
%
% --------------------------------------------------------------------------------
%
% Comments
% The header format is flexible and can be extended for new user-defined data types. The essential structures of the header are the header_key and the image_dimension.
%
% The required elements in the header_key substructure are: 
%
% int sizeof_header      Must indicate the byte size of the header file. 
% int extents              Should be 16384, the image file is created as contiguous with a minimum extent size. 
% char regular              Must be `r' to indicate that all images and volumes are the same size. 
% The image_dimension substructure describes the organization and size of the images. These elements enable the database to reference images by volume and slice number. Explanation of each element follows: 
%
% short int dim[];      /* array of the image dimensions */ 
% dim[0]      Number of dimensions in database; usually 4 
% dim[1]      Image X dimension; number of pixels in an image row 
% dim[2]      Image Y dimension; number of pixel rows in slice 
% dim[3]      Volume Z dimension; number of slices in a volume 
% cdim[4]      Time points, number of volumes in database.
% char vox_units[4]     specifies the spatial units of measure for a voxel 
% char cal_units[4]      specifies the name of the calibration unit 
% short int datatype      /* datatype for this image set */ 
% /*Acceptable values for datatype are*/ 
% #define DT_NONE                        0 
% #define DT_UNKNOWN               0      /*Unknown data type*/ 
% #define DT_BINARY                    1      /*Binary (1 bit per voxel)*/ 
% #define DT_UNSIGNED_CHAR     2      /*Unsigned character (8 bits per voxel)*/ 
% #define DT_SIGNED_SHORT        4      /*Signed short (16 bits per voxel)*/ 
% #define DT_SIGNED_INT             8      /*Signed integer (32 bits per voxel)*/ 
% #define DT_FLOAT                     16     /*Floating point (32 bits per voxel)*/ 
% #define DT_COMPLEX                32     /*Complex (64 bits per voxel; 2 floating point numbers) 
% #define DT_DOUBLE                   64     /*Double precision (64 bits per voxel)*/ 
% #define DT_RGB                         128    /* */
% #define DT_ALL                         255    /* */
%
% short int bitpix;        /* number of bits per pixel; 1, 8, 16, 32, or 64. */ 
% short int dim_un0;   /* unused */ 
% float pixdim[];       Parallel array to dim[], giving real world measurements in mm. and ms. 
% pixdim[1];      voxel width in mm. 
% pixdim[2];      voxel height in mm. 
% pixdim[3];      slice thickness in mm. 
% float vox_offset;      byte offset in the .img file at which voxels start. This value can be 
%                                   negative to specify that the absolute value is applied for every image
%                                   in the file. 
% float calibrated Max, Min    specify the range of calibration values 
% int glmax, glmin;    The maximum and minimum pixel values for the entire database. 
% The data_hdr substructure is not required, but the orient field is used to indicate individual slice orientation and determines whether the Movie program will attempt to flip the images before displaying a movie sequence.
%
% orient:       slice orientation for this dataset. 
% 0      transverse unflipped 
% 1      coronal unflipped 
% 2      sagittal unflipped 
% 3      transverse flipped 
% 4      coronal flipped 
% 5      sagittal flipped 