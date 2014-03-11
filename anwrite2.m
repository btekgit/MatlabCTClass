function anwrite2(filestub, s, hdr)
% Write a 3D dataset in ANALYZE 7.5 format
%
% anwrite(filestub, s, hdr)
%
% ARGS:
% filestub = full file path without extensions
% s        = 3D scalar data
% hdr      = full or partial header structure (all fields are optional)
%   .vsize    = voxel dimensions in mm [1 1 1]
%   .cal      = calibrated intensity range [max min] [1 0]
%   .datatype = data type (2=int8, 4=int16, 8=int32, 16=float, 64=double) [4]
%   .desc     = study description (cropped to 80 chars)
%   .orig     = originator (eg CIT_BIC) (cropped to 10 chars)
%   .scannum  = scan number (cropped to 10 chars)
%   .pid      = patient id (cropped to 10 chars)
%   .expdate  = experiment date (cropped to 10 chars)
%   .exptime  = experiment time (cropped to 10 chars)
%
% AUTHOR: Mike Tyszka, Ph.D.
% PLACE : Caltech BIC and City of Hope, Duarte CA
% DATES : 11/15/2000 JMT From scratch (see Mayo Clinic ANALYZE format page)
%         02/28/2001 JMT Add .cal and .vox header fields
%         08/05/2002 JMT Add 32-bit integer support (JMT Caltech)
%         07/01/2003 JMT Replace header argument with vsize and bitdepth
%         12/01/2003 JMT Return to header argument with support for
%                        partial structure
%         08/18/2004 JMT Add support for float and double output
%         01/23/2006 JMT M-Lint corrections
%

%  NOTE UPDATE BY BTEK 
%  Changing the original code, because we do not need scaling. In fact it
%  causes problems, I will add our info names-> to hdr conversion.
%  B. Tek 29-05-08



%our info
%      Filename: 'C:\BORAY\Lung_data\GGO_Examples_analyse\1.2.392.200036.9116.2.2.2.1762671960.1093502276.480590.hdr'
%          FileModDate: '29-Jun-2006 17:53:52'
%          HdrFileSize: 348
%          ImgFileSize: 78643200
%               Format: 'Analyze'
%        FormatVersion: '7.5'
%                Width: 512
%               Height: 512
%             BitDepth: 16
%            ColorType: 'grayscale'
%            ByteOrder: 'ieee-le'
%          HdrDataType: ''
%         DatabaseName: ''
%              Extents: 0
%         SessionError: 0
%              Regular: 1
%           Dimensions: [512 512 150]
%           VoxelUnits: ''
%     CalibrationUnits: ''
%          ImgDataType: 'DT_SIGNED_SHORT'
%      PixelDimensions: [0.6250 0.6250 2]
%          VoxelOffset: 0
%       CalibrationMax: 0
%       CalibrationMin: 0
%           Compressed: 0
%             Verified: 0
%            GlobalMax: 0
%            GlobalMin: 0
%           Descriptor: ''
%              AuxFile: ''
%          Orientation: 'Transverse unflipped'
%           Originator: ''
%            Generated: ''
%           Scannumber: ''
%            PatientID: ''
%         ExposureDate: ''
%         ExposureTime: ''
%                Views: 0
%         VolumesAdded: 0
%           StartField: 0
%            FieldSkip: 0
%                 OMax: 0
%                 OMin: 0
%                 SMax: 0
%                 SMin: 0
%                Depth: 150

% Argument checks
if nargin < 2
    help anwrite2
    return
end

if nargin < 3
    hdr = [];
end

% Cast s to double precision floats
% s = double(s);  why ?????

%-----------------------------------------------------------------
% Tidy up ANALYZE header structure
%-----------------------------------------------------------------

% This will create a header if none was supplied
%hdr.ndim = ndims(s);
% sorry only three dimensional
array_o = 1;
cell_o = 2;
ct_o   = 3;
if (isnumeric(s))
    obj =array_o;
elseif (iscell(s))
    obj =cell_o;
elseif (isa(s,'CT'))
    obj =ct_o;
end
hdr.ndim = 3;
%hdr.dim = size(s);
%change it for c
[size_s] = size(s);
hdr.dim = [size_s(2) size_s(1) size_s(3)];


if ~isfield(hdr,'vsize')
    hdr.vsize = ones(1,hdr.ndim);
end

% Generate autocalibration range including EPS offset for max to
% avoid divide-by-zero scaling error
switch obj
    case  array_o
        autocal = [max(s(:))+eps min(s(:))];
    case cell_o
        autocal = [max(s)+eps min(s)];
    case ct_o
        autocal = [max(s)+eps min(s)];
end



% Handling missing or empty calibration range
if ~isfield(hdr,'cal'); hdr.cal = autocal; end
if isempty(hdr.cal); hdr.cal = autocal; end

% Default datatype
if ~isfield(hdr,'datatype'); hdr.datatype = 4; end

% Set the signed bit depth of the output image

% #define DT_BINARY                1
% #define DT_UNSIGNED_CHAR         2
% #define DT_SIGNED_SHORT          4
% #define DT_SIGNED_INT            8
% #define DT_FLOAT                 16
% #define DT_COMPLEX               32
% #define DT_DOUBLE                64
% #define DT_RGB                   128
% #define DT_ALL                   255

switch hdr.datatype
    case 2
        bitdepth = 8;
    case 4
        bitdepth = 16;
    case {8,16,64}
        bitdepth = 32;
    otherwise
        fprintf('Unkown datatype: %d\n', hdr.datatype);
        return
end

% Voxel range set from bitdepth
% NB: Analyze specification demands signed int16,32.
% However, the AIR registration package uses unsigned int16,32.
% To solve this conflict, we scale the pixel intensity range to
% only the positive half space of the integer, losing one bit
% of dynamic range in the process, but ensuring compatibility
% with both Analyze spec and AIR.

switch hdr.datatype
    case {2,4,8} % Integer types
        vmax = 2^(bitdepth-1);
        hdr.vox = [vmax-1 0];
    case {16,64} % Float and Double types
        hdr.vox = autocal;
    otherwise
        hdr.vox = [1 0];
end

% Write header file
anwritehdr(filestub, hdr);

% Create image data filename
anaimgfile = [filestub '.img'];

nz = size(s,3);

% Write image data as little endian
fd = fopen(anaimgfile, 'w', 'ieee-le');
if fd < 1
    fprintf('Could not open image data file\n');
    return
end

for zc = 1:nz

    % Extract single slice
switch obj
    case  array_o
        sz = s(:,:,zc);    % dont know why but I have to transpose it
    case cell_o
        sz = s{zc};    % dont know why but I have to transpose it
    case ct_o
        sz = getslice(s,zc);
end

    % this is because matlab convention is not good for raster write. 
    sz = sz';

    % Map voxel values from calibrated to unsigned integer ready for writing to file
    %sz = (sz - hdr.cal(2)) / (hdr.cal(1) - hdr.cal(2)) * (hdr.vox(1) - hdr.vox(2)) + hdr.vox(2);

    % Clamp overranged values
    %sz(sz > hdr.vox(1)) = hdr.vox(1);
    %sz(sz < hdr.vox(2)) = hdr.vox(2);

    % Write data
    switch hdr.datatype
        case 2
            fwrite(fd, sz, 'int8');
        case 4
            fwrite(fd, sz, 'int16');
        case 8
            fwrite(fd, sz, 'int32');
        case 16
            fwrite(fd, sz, 'float');
        case 64
            fwrite(fd, sz, 'double');
    end

end

% Close the image file
fclose(fd);