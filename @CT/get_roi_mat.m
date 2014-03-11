function [roi_wnd] = get_roi_mat(ct_in,y,x,sliceno,hei,wid)
% function [roi_wnd] = get_roi_mat(ct_in,y,x,sliceno,hei,wid)
%--------------------------------------------------------------------------
% This function implements get_roi_mat method for a CT object
%       F. Boray Tek, 21/05/08
%       Last Updated, 03/06/80 updating for the borders
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   ct_in    : Input CT object
%   x,y      : coordinates of the center in xy plane
%   sliceno  : slicenumber to be extracted
%   wid,hei  : width and height of window, height is optional, wid will be
%   assumed symmetrical
%   as the x,y center window will be        x-(wid-1)/2:(wid-1)/2,
%   expecting an odd value for wid
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%
%  roi      : returns 2d-array window numeric
%
%--------------------------------------------------------------------------
%  Call get_roi_ct if you need ct object output.
%--------------------------------------------------------------------------
% see also set_roi_mat, set_voi_mat, get_voi_ct, get_voi_cube_ct, set_voi_cube_ct


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
    wid = hei; % matlab convention
end


if ((sliceno<1)&&(sliceno>ct_in.info.Depth))
    error('CT:get_roi_mat:incorrectarguments', 'z value out of bounds , see help');
end

y1= double((y-floor(hei/2))>0)*double((y-floor(hei/2)));
y2= double(y+floor(hei/2));
if (y2 > ct_in.info.Height) 
    y2 = double(ct_in.info.Height); 
end

% no update for y

x1= double((x-floor(wid/2))>0)*double(x-floor(wid/2));
x2= double(x+floor(wid/2));
if (x2 > ct_in.info.Width) 
    x2 = double(ct_in.info.Width); 
end
% or x. 


if (isa(ct_in,'CT'))
    if (iscell(ct_in.slice))
            roi_wnd = ct_in.slice{sliceno}(y1:y2,x1:x2);
    else
            roi_wnd = ct_in.slice(y1:y2,x1:x2,sliceno);
    end
else
    error('CT:get_roi_mat:errormsg1', 'This function accepts CT object and outputs a 2d matrix');
end
