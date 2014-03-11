function analyze_write_ct(fname,ct_in,inf )
% function analyze_write_ct(fname,ct_in,inf )
% Writes CT objects as analyze files by calling a version of 
% Mike Tyszka's function "anwrite2.m"
% Assumes hdr file is provided
% WARNING WRITES SAFELY ONLY WITH SHORT DATA (INT16) 
% fname: filename
% ct_in: ct object
% inf: analyze info
% date: 29.05.08
% written: by B.Tek 


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

if (nargin < 2) 
    help analyze_write_ct
elseif (nargin < 3) 
    inf = getinfo(ct_in); 
    inf = translate_info(inf) ;
end

if(exist(fname,'file'))
    disp('Overwriting existing file');
end

anwrite2(fname, ct_in,inf); 





function inf = translate_info(inf)
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
if(~isfield(inf,'vsize'))
    if(isfield(inf,'PixelDimensions'))
        inf.vsize = [inf.PixelDimensions(2) inf.PixelDimensions(1) inf.PixelDimensions(3)];
    end
end



if(~isfield(inf,'cal'))
    if(isfield(inf,'CalibrationMax')&& isfield(inf,'CalibrationMin'))
        inf.cal = [inf.CalibrationMax inf.CalibrationMin] ;
    end
end

if(~isfield(inf,'datatype'))
    if(isfield(inf,'ImgDataType'))
        if (strcmp(inf.ImgDataType,'DT_SIGNED_SHORT'))
            inf.datatype = 4;
        elseif (strcmp(inf.ImgDataType,'DT_UNSIGNED_CHAR'))
            inf.datatype = 2; 
        elseif (strcmp(inf.ImgDataType,'DT_SIGNED_INT'))
            inf.datatype = 8;
        elseif (strcmp(inf.ImgDataType,'DT_FLOAT'))
                    inf.datatype = 16;
        elseif (strcmp(inf.ImgDataType,'DT_DOUBLE'))
            inf.datatype = 64;
        end
    end
end

if(~isfield(inf,'desc'))
    if(isfield(inf,'Descriptor'))
        inf.desc = inf.Descriptor;
    end
end





