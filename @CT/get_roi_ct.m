function [roi_ct] = get_roi_ct(ct_in,y,x,sliceno,hei,wid)
% [roi_ct] = get_roi_ct(ct_in,y,x,sliceno,hei,wid)
%--------------------------------------------------------------------------
% This function implements get_roi_ct method for a CT object
%       F. Boray Tek, 21/05/08
%       Last Updated 27/02/13
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   ct_in    : Input CT object
%   x,y      : coordinates of the center in xy plane
%   sliceno  : slicenumber to be extracted
%   wid,hei  : width and height of window, height is optional, wid will be
%   assumed symmetrical
%   as the x,y center window will be        x-(wid-1)/2:x+(wid-1)/2,
%   expecting an odd value for wid
%   will not check the border of the image
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%
%  roi_ct     : returns a ct object of the same type, i.e. numeric,cell
%
%--------------------------------------------------------------------------
%  Call get_roi_mat if you need  a matrix output.
%--------------------------------------------------------------------------
%see also set_voi_mat, get_voi_ct, get_voi_cube_ct, get_roi_mat,
%  set_voi_cube_ct, 
  
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
    error('CT:get_roi_mat:incorrectarguments', 'number of args must be at least 5 , see help');
elseif (nargin ==5)
    wid = hei;
end

if (isa(ct_in,'CT'))
    if (iscell(ct_in.slice))
        if ((sliceno>0)&&(sliceno<=ct_in.info.Depth))
            roi_wnd{1} = ct_in.slice{sliceno}((y-(hei-1)/2):(y+(hei-1)/2),(x-(wid-1)/2):(x+(wid-1)/2));
        end
    else
        if ((sliceno>0)&&(sliceno<=ct_in.info.Depth))
            roi_wnd = ct_in.slice((y-(hei-1)/2):(y+(hei-1)/2),(x-(wid-1)/2):(x+(wid-1)/2),sliceno);
        end
    end
else
    error('CT:cell:errormsg1', 'This function accepts CT object and outputs a 2d matrix');
end
roi_info = ct_in.info; 
roi_info.Width = wid;
roi_info.Height = hei;
roi_info.Depth = 1;
roi_info.Dimensions = [hei wid 1];

roi_ct = CT(roi_wnd,roi_info);