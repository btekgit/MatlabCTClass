function C= dilate3d(A,B, resolution)
% function C= dilate3d(A,B, resolution)
% function implements 3d dilation  function for cell array
% First input should be cell array of type int16,
% second should be dilation window size 
% the output is a Unsigned Byte cell
%morph mex dll operates with
% enum eBinaryOperator
% {
% 	eBinary3dDilate =0
% 	eBinary3dErode=1
% 	eBinary3dOpen=2
% 	eBinary3dClose=3
% 	eBinary3dAreaOpen=4
% 	eBinary3dAreaClose=5
% 	eBinary3dFillHoles=6
% 	eBinary3dGetHoles=7
% 	eBinary3dLabeln=8
% }

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
    help dilate3d 
    return
end

if (nargin == 2)
    resolution = [1.0 1.0 1.0];
end

if (cell_a)
    t= A{1}(1,1);
    if(isscalar(B))
       % C = Dilate_3d_int16_mex(A,resolution(1),resolution(2),resolution(3), B);
        C = morph_mex_int16(A,resolution(1),resolution(2),resolution(3), B,0);
    else
        error('cell:gt','first argument should be a int16 cell and ');        
    end
else
    error('cell:gt','first argument should be cell');
end
