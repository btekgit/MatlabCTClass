function [sy,sx,sz] = getsize(ct_in)
% function [sy,sx,sz] = getsize(ct_in)
%--------------------------------------------------------------------------
% This function implements size operator for a CT object
% but it is not very efficient
% this information should be stored in the header.
%       F. Boray Tek, 19/05/08
%       Last Updated, 28/05/08 changed calling convention
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   ct_in    :   Input CT object
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%   sy,sx: size of the slices
%   sz: slice_no
%--------------------------------------------------------------------------
% SEE ALSO CT/size


% copyright 2008-2013 F. Boray Tek.
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

if (isa(ct_in,'CT'))
        sz = ct_in.info.Depth;
        sy = ct_in.info.Height;
        sx = ct_in.info.Width;
else
    error('CT:getsize:errormsg2', 'This function accepts CT object and outputs sl,sy,sx values');
end
