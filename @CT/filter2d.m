function C= filter2d(A,B)
% C=filter(A,B) for CT overloaded. 
%--------------------------------------------------------------------------
% This function implements 2D slice by slice filtering of a CT set.
%       F. Boray Tek, 20/05/08
%       Last Updated, 
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   A    :   this is the input CT set
%   B    :   filter structure, can be created by fspecial 
%   for example 
%   h = fspecial('gaussian', [9 9 ] , 0.7)
%              
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  C   :   output CT object
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

if (isa(A, 'CT')) % first argument is CT second is numeric
    C = A;
    C.info = A.info;
    if (isnumeric(B))
        C.slice = filter2d(A.slice,B);
    end
elseif (isa(B, 'CT')) % second argument is CT first is numeric
    C = B;
    C.info = B.info;
    if (isnumeric(A))
        C.slice = filter2d(B.slice,A);
    end
else
    disp('one of the arguments should be CT set');
end

