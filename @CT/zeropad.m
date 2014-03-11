function ct_in = zeropad(ct_in,hei, wid, dep)
% function ct_in = zeropad(ct_in,hei, wid, dep)
% will extend the object in given non-zero directions.
%--------------------------------------------------------------------------
% This function implements the zeropad method for CT-scan sets.
%       F. Boray Tek, 28/05/08
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   ct_in: Ct object
%   hei, wid, dep: y,x,z axis extensions
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

in_info = ct_in.info; 
new_hei = in_info.Height+hei; 
new_wid = in_info.Width+wid; 
new_dep = in_info.Depth+dep; 
stpix = getpixel(ct_in,1,1,1); % for type detection
new_cell = cell(1,new_dep);
zm = repmat(stpix-stpix,[new_hei, new_wid]); 
for i = 1:in_info.Depth
        new_cell{i} = ct_in.slice{i};
end

for i = in_info.Depth: new_dep
        new_cell{i} = zm;
end


new_info = ct_in.info; 
new_info.Width = new_wid;
new_info.Height = new_hei;
new_info.Depth = new_dep;
new_info.Dimensions = [new_hei new_wid new_dep];

ct_in = CT(new_cell, new_info);