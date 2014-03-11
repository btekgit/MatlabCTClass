function C= max3open2d(A,opcode,criteria,decision)
% C= max3open2d(A,opcode,criteria,decision) for CT . 
%--------------------------------------------------------------------------
% This function implements 2d slice by slice maxtree opening of a CT set.
% Original maxtree opening code is converted from Erik Urbach's original
% code.
%       F. Boray Tek, 8/01/09
%       Last Updated, 
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   A        :   this is the input CT set
%   opcode   :   operation code ,0: area, 1: 
%   criteria :   lambda for thresholding
%   decision :   the filtering approach
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  C   :   output
%--------------------------------------------------------------------------
%  Usage: <input image> <attrib> <lambda> [decision] [output image] 
% Where attrib is:
% 	0 - Area
% 	1 - Area of min. enclosing rectangle
% 	2 - Square of diagonal of min. enclosing rectangle
% 	3 - Cityblock perimeter
% 	4 - Cityblock complexity (Perimeter/Area)
% 	5 - Cityblock simplicity (Area/Perimeter)
% 	6 - Cityblock compactness (Perimeter^2/(4*PI*Area))
% 	7 - Large perimeter
% 	8 - Large compactness (Perimeter^2/(4*PI*Area))
% 	9 - Small perimeter
% 	10 - Small compactness (Perimeter^2/(4*PI*Area))
% 	11 - Moment of Inertia
% 	12 - Elongation: (Moment of Inertia) / (area)^2
% 	13 - Mean X position
% 	14 - Mean Y position
% 	15 - Jaggedness: Area*Perimeter^2/(8*PI^2*Inertia)
% 	16 - Entropy
% 	17 - Lambda-max (Max.child gray level - current gray level)
% 	18 - Gray level
% and decision is:
% 	0 - Min
% 	1 - Direct
% 	2 - Max
% 	3 - Subtractive (default)

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

if (isa(A, 'CT')) % first argument is CT
    C = A;
    C.info = A.info;
   C.slice = max3open2d(A.slice,opcode,criteria,decision);
   
else
    disp('the first argument should be CT set');
end

