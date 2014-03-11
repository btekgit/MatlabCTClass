function ct_in = setpixel(ct_in,y,x,z, val)
% function  ct_in = setpixel(ct_in,y,x,z, val)
% will change the coord located pixel value
% there is a type check 
%--------------------------------------------------------------------------
% This function implements the setpixel method for CT-scan sets.
%       F. Boray Tek, 02/06/08
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   Setval returns the property
%   ct_in: Ct object
%   coord: coordinates, y, x, z, 
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  ct_in : input ct object.
%
%
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


cell_slice = iscell(ct_in.slice);
if (cell_slice)
    old_cls = class(ct_in.slice{z}(y,x));
else
    old_cls = class(ct_in.slice(y,x,z));
end

new_cls = class(val);
if(~strcmp(old_cls,new_cls))
    disp(strcat('Warning type mismatch input with the object ',old_cls,' :<- ',new_cls));
    val = cast(val,old_cls);

end

if (cell_slice)
    ct_in.slice{z}(y,x) = val;    
else
    ct_in.slice(y,x,z) = val;  
end
    

