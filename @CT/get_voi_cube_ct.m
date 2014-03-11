function [voi_ct] = get_voi_cube_ct(ct_in,y_range,x_range,slice_range)
% [voi_ct] = get_voi_cube_ct(ct_in,y_range,x_range,slice_range)
%--------------------------------------------------------------------------
% This function implements get_voi_cube_ct method for a CT object.
% difference than the "get_voi_ct" is that here you can give directly the
% crop boundaries , as 1 dimensional vectors 
%       F. Boray Tek, 22/05/08
%       Last Updated,
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   ct_in    : Input CT object
%   x_range      : x range
%   x_range      : y range
%   slice_range  : slice range to be extracted
%   will not check the border of the image
%
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%
%  voi_ct      : returns a ct object of the same type, i.e. numeric,cell
%
%--------------------------------------------------------------------------
%  Call get_voi_ct,mat if you need a matrix output. around a center pixel
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

if (nargin<4)
    error('CT:get_roi_mat:incorrectarguments', 'number of args must be 4 , see help');
end

dep = length(slice_range); 
wid = length(x_range);
hei = length(y_range);

if (isa(ct_in,'CT'))
    if (iscell(ct_in.slice))
        if (all(slice_range>0) && all(slice_range<=ct_in.info.Depth))
            k =1; 
            voi_wnd = cell(1,dep);
            for i = slice_range
                voi_slice(:,:) = ct_in.slice{i};
                voi_wnd{k} = voi_slice(y_range,x_range);
                k = k+1;
            end
        end
    else
        if (all(slice_range>0) && all(slice_range<=ct_in.info.Depth))
            voi_wnd = ct_in.slice(y_range,x_range,slice_range);
        end
    end
else
    error('CT:cell:errormsg1', 'This function accepts CT object and outputs a 2d matrix');
end

voi_info = ct_in.info; 
voi_info.Width = wid;
voi_info.Height = hei;
voi_info.Depth = dep;
voi_info.Dimensions = [hei wid dep];

voi_ct = CT(voi_wnd, voi_info);