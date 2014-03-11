function [pix_value] = getpixel(ct_in,y,x,sliceno) 
% function [pix_value] = getpixel(ct_in,y,x,sliceno) 
%--------------------------------------------------------------------------
% This function implements getpixel operator for a CT object 
%       F. Boray Tek, 19/05/08
%       Last Updated, 28/05/08 changed call convention to match malatab
%       array indexing
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   ct_in    : Input CT object 
%   x,y      : coordinates in xy plane
%   sliceno  : slicenumber to be extracted             
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  pix_value : returns pixel value, no type conversion
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


if ((sliceno<1)||(sliceno>ct_in.info.Depth))
    error('CT:cell:errormsg1', 'sliceno is out of range');
end

if (isa(ct_in,'CT'))
   
         if (iscell(ct_in.slice))
            pix_value = ct_in.slice{sliceno}(y,x);
         else
            pix_value = ct_in.slice(y,x,sliceno); 
         end
   
else
    error('CT:cell:errormsg1', 'The input must be  CT object');
end
