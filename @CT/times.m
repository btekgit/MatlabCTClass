function C= times(A,B)
% times(A,B)
%--------------------------------------------------------------------------
% This function implements pixel by pixel multiplication of a CT set, or CT set and 
% numeric, or a CT set and cell array 
%       F. Boray Tek, 19/05/08
%       Last Updated, 
%
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   A    :   this is the first CT set
%   B    :   second SET, or number, or cell array
%              
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  C   :   output
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
    if ( isnumeric(B))
        C.slice = A.slice.*B;
    elseif (isa(B, 'CT'))
        C.slice = A.slice.*B.slice;
    elseif (iscell(B))
        C.slice = A.slice.*B;
    end
elseif (isa(B, 'CT')) % second argument is CT first is numeric
    C = B;
    C.info = B.info;
    if ( isnumeric(A))
        C.slice = B.slice.*A;
    elseif (isa(A, 'CT'))
        C.slice = A.slice.*B.slice;
    elseif (iscell(B))
        C.slice = B.slice.*A;
    end
else
    disp('one of the arguments should be CT set');
end

