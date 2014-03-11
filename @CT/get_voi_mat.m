function [voi_mat] = get_voi_mat(ct_in,y,x,sliceno,hei,wid,dep)
% [voi_mat] = get_voi_mat(ct_in,y,x,sliceno,hei,wid,dep)
%--------------------------------------------------------------------------
% This function implements get_voi_ mat method for a CT object
%       F. Boray Tek, 21/05/08
%       Last Updated, 26/05/08  added boundary checks
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   ct_in    : Input CT object
%   x,y      : coordinates of the center in xy plane
%   sliceno  : slicenumber to be extracted
%   wid,hei,dep : width and height and depth of window, height and depth is optional,
%   wid will be assumed symmetrical
%   as the x,y center window will be        x-(wid-1)/2:x+(wid-1)/2,
%   expecting an odd value for wid
%   will not check the border of the image
%
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%
%  voi_mat      : returns numeric cell array volume
%
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% see also set_voi_mat, get_voi_ct, get_voi_cube_ct, get_roi_mat,
% set_voi_cube_ct, 

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
    dep = hei;
elseif  (nargin ==6)
    dep = hei;
end

if ((sliceno<1)&&(sliceno>ct_in.info.Depth))
    error('CT:get_roi_mat:incorrectarguments', 'z value out of bounds , see help');
end

% check  boundaries
z1 = double(sliceno-floor(dep/2));
if (z1< 1) 
    z1 = 1; 
end
z2 =double(sliceno+floor(dep/2)); 
if (z2 >ct_in.info.Depth) 
    z2 = double(ct_in.info.Depth); 
end
% update depth 
dep = length(z1:z2); 

y1= double(y-floor(hei/2));
if ( y1 < 1) 
    y1 = 1; 
end
y2= double(y+floor(hei/2));
if ( y2 >ct_in.info.Height) 
    y2 = double(ct_in.info.Height); 
end

% no update for y

x1= double((x-floor(wid/2)));
if ( x1 < 1)
    x1 = int16(1); 
end
x2= double(x+floor(wid/2));
if ( x2 >ct_in.info.Width) 
    x2 = double(ct_in.info.Width); 
end
% or x. 


if (isa(ct_in,'CT'))
    if (iscell(ct_in.slice))
        voi_slices = reshape([ct_in.slice{z1:z2}], [ct_in.info.Height ct_in.info.Width dep]); % this converts the region to a 3d matrix
        %voi_slices = reshape(ct_in.slice(z1:z2), [ct_in.info.Height ct_in.info.Width dep]); % this converts the region to a 3d matrix
        voi_mat = voi_slices(y1:y2,x1:x2,:);
    else
    voi_mat = ct_in.slice(y1:y2,x1:x2,z1:z2);
    end
else
    error('CT:cell:errormsg1', 'This function accepts CT object and outputs a 2d matrix');
end
%a = cputime-t;