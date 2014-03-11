function C= open3d(A,B)
% C=open3d(A,B) for CT  
% Only int16, byte, uint16 input is allowed.
% B is window size. Note that CT resolution is passed to the function
%--------------------------------------------------------------------------
% This function implements 3d morphological opening of a CT set image.
% only a square structuring element is implemented
%       F. Boray Tek, 24/06/08
%       Last Updated, 
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   A    :   this is the CT set, int16, uint16, or byte
%   B    :   this is scalar 
%                 
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  C   :   output CT image containing uint8 output.
%--------------------------------------------------------------------------

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

if (isa(A, 'CT')) % first argument is CT second is numeric
    C = A;
    C.info = A.info;
    if (iscell(A.slice))
        t= A.slice{1}(1,1);
        if(isscalar(B))
            res = [1 1 1];
            if (isfield(A.info, 'PixelDimensions'))
                res = A.info.PixelDimensions;
            end
            C_cell = open3d(A.slice,B,res);
            C.info = update_info(A.info);
            C = CT(C_cell,A.info);
 
        else
                 disp('scalar B is implemented' );
        end
    else
        disp('Numeric array is not implemented, call' );
    end
else
    disp('First argument should be CT set of int16, uint16, uint8');
end

function A = update_info(B)
A = B;
A.BitDepth = 8;
A.ImgDataType = 'DT_UNSIGNED_BYTE';
A.CalibrationMax =  1; % this may be risky I dont know
A.CalibrationMin =  0;
if(isfield(A,'BitsAllocated'))
    A.BitsAllocated = 8; 
    A.BitsStored = 8;
    A.HighBit = 8;
end


