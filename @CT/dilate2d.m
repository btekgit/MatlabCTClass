function C = dilate2d(A, se)
% function C = dilate2d(A, se)
%--------------------------------------------------------------------------
% This function applies 2d slice by slice dilation
% If you do not supply the structuring element it will use default 3x3
% neighboorhood
%       F. Boray Tek, 13/06/08
%       Last Updated, 27/02/13
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   A    :   this is the first input
%   se    :   structuring element
%              
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  C   :   output CT 
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

inf = A.info; 
A = array(A);
if ( nargin ==1)
    se = strel('square',3);
end
msk = imdilate(A, se);
C = CT(msk,inf);
