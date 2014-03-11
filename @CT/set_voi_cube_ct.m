function [ct_out] = set_voi_cube_ct(ct_in,A_in,y_range,x_range,slice_range)
% [ct_out] = set_voi_cube_ct(ct_in,A_in,y_range,x_range,slice_range)
%--------------------------------------------------------------------------
% This function implements set_voi_cube_ct method for a CT object.
% difference than the "set_voi_ct" is that here you can give directly the
% cube boundaries , with arrays, 
%       F. Boray Tek, 22/05/08
%       Last Updated,
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   ct_in    : Input CT object
%   A_in     : array to replace
%   x_range      : x range
%   x_range      : y range
%   slice_range  : slice range to be extracted
%   will not check the border of the image
%
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%
%  ct_out      : returns a ct object of the same type
%
%--------------------------------------------------------------------------
%  Call set_voi_ct,mat if you need to replace matrix values in a range
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



if (nargin<5)
    error('CT:set_void_cube_ct:incorrectarguments', 'number of args must be 5 , see help');
end

dep = length(slice_range); 
wid = length(x_range);
hei = length(y_range);

[s1,s2,s3] = size(A_in);

if((s1~=hei)|| (s2~=wid) || (s3~=dep))
    error('CT:set_void_cube_ct:incorrectarguments', 'dimensions mismatch , see help');
end


if (isa(ct_in,'CT'))
    ct_out = ct_in;
    if (iscell(ct_in.slice))
        if (all(slice_range>0) && all(slice_range<=ct_in.info.Depth))
            k =1; 
           
            for i = slice_range
                slice = ct_in.slice{i}; 
                org_class = class(slice);
                slice(y_range,x_range) =cast( A_in(:,:,k), org_class);
                ct_out.slice{i} = slice;
                k = k+1;
            end
        end
    end
else
    error('CT:set_void_cube_ct:incorrectarguments', 'This function accepts CT object with cell data ');
end
