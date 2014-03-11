function C= filter3d(A,B)
% C=filter3d(A,B,'same') for CT  
% Only int16 input is allowed. Check parameters
% filter should be double and 3D
%--------------------------------------------------------------------------
% This function implements 3d filtering of a CT set.
%       F. Boray Tek, 11/06/08
%       Last Updated, 27/02/13
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   A    :   this is the input CT set, int16
%   B    :   double 3D array
%   EG = 1/27.*ones(3,3,3) is a averaging filter,
%              
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  C   :   output CT object
%--------------------------------------------------------------------------
% see also filter2d


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
    if (iscell(A.slice))
        t= A.slice{1}(1,1);
        if(isa(t,'int16'))
            C_cell = filter3d_int16(A.slice,B);
            C = CT(C_cell,A.info);
        else
                 disp('Only int16 input is implemented' );
        end
        
        
    else
        disp('Numeric array is not implemented, call convn(array(A),B))' );
    end
else
    disp('First argument should be CT set');
end

