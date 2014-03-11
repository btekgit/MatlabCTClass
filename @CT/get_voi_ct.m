function [voi_ct] = get_voi_ct(ct_in,y,x,sliceno,hei,wid,dep)
% [voi_ct] = get_voi_ct(ct_in,y,x,sliceno,wid,hei,dep)
%--------------------------------------------------------------------------
% This function implements get_voi_ct method for a CT object
%       F. Boray Tek, 21/05/08
%       Last Updated,
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
%  voi_ct      : returns a ct object of the same type, i.e. numeric,cell
%
%--------------------------------------------------------------------------
%  Call get_voi_mat if you need a matrix output.
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
    error('CT:get_roi_mat:incorrectarguments', 'number of args must be at least 5 , see help');
elseif (nargin ==5)
    hei = wid;
    dep = wid; 
elseif  (nargin ==6)
    dep = wid; 
end


% check  boundaries 
z1 = double((sliceno-(dep-1)/2)>1)*((sliceno-(dep-1)/2));
z2 = (sliceno+(dep-1)/2);
z1 = floor(z1);
z2 = floor(z2);
if ( z2 >ct_in.info.Depth) z2 = ct_in.info.Depth; end
    
y1= double((y-(hei-1)/2)>1)*((y-(hei-1)/2));
y2= (y+(hei-1)/2);
if ( y2 >ct_in.info.Height) y2 = ct_in.info.Height; end
y1 = floor(y1);
y2 = floor(y2);

x1=double((x-(wid-1)/2)>1)*double((x-(wid-1)/2));
x2= (x+(wid-1)/2);
if ( x2 >ct_in.info.Width) x2 = ct_in.info.Width; end
x1 = floor(x1);
x2 = floor(x2);

if (isa(ct_in,'CT'))
    if (iscell(ct_in.slice))
        if ((sliceno>0)&&(sliceno<=ct_in.info.Depth))
            k =1; 
            voi_wnd = cell(1,dep);
            for i =z1:z2
                voi_slice(:,:) = ct_in.slice{i};
                voi_wnd{k} = voi_slice(y1:y2,x1:x2);
                k = k+1;
            end
        end
    else
        if ((sliceno>0)&&(sliceno<=ct_in.info.Depth))
            voi_wnd = ct_in.slice(y1:y2,x1:x2,z1:z2);
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