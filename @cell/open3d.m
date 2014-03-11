function C= open3d(A,B, resolution)
% function implements 3d binary opening  function for cell array
% First input should be cell array of type int16, uint16, byte
% second should be open3d window size 
% the output is a Unsigned cell
% needs morph mex dll to operate with



% update 27/02/2013
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

cell_a = iscell(A);
if (nargin < 2) 
    help open3d 
    return
end

if (nargin == 2)
    resolution = [1.0 1.0 1.0];
end

if (cell_a)
    t= A{1}(1,1);
    if(isscalar(B))
        C = morph_mex_int16(A,resolution(1),resolution(2),resolution(3), B,2);
    else
        error('cell:erode3d','first argument should be a int16,uin16, or byte cell second argument is scalar window size  ');        
    end
else
    error('cell:erode3d','first argument should be a int16,uin16, or byte cell');
end
