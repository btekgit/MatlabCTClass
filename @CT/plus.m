function C= plus(A,B)
% C=plus(A,B) for CT overloaded. 
%--------------------------------------------------------------------------
% This function implements pixel by pixel summation of a CT set, or CT set and 
% numeric, or a CT set and cell array 
%       F. Boray Tek, 19/05/08
%       Last Updated, 
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


a_ct = isa(A, 'CT');
b_ct = isa(B, 'CT');
if (a_ct || b_ct) % first argument is CT second is numeric
  if (a_ct)
    C = A;
    C.info = A.info;
  else
    C = B;
    C.info = B.info;
  end
    if (isnumeric(B))
        C.slice = A.slice+B;
    elseif (b_ct && a_ct)
        C.slice = A.slice+B.slice;
    elseif (b_ct && (~a_ct))
        C.slice = A+B.slice;
    elseif (iscell(B))
        C.slice = A.slice+B;
    end
else
    disp('one of the arguments should be CT set');
end

