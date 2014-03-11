function C= sum(A,d)
% C=sum(A) for CT overloaded.
%--------------------------------------------------------------------------
% This function implements summation along the depth: default behaviour
% can implement summation along other dimensions
%       F. Boray Tek, 20/05/08
%       Last Updated,
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   A    :   this is the first CT set
%   d    :   the dimension to the summation
%   h = sum(a, 3) sums the default.
%   h = sum(a, 1) sums on x plane
%
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  C   :   output 2d array
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
    if ( nargin ==1)
        dim_no = 3;
    else
        dim_no = d;
    end
    switch dim_no 
        case 1
            disp('not implemented');
        case 2
            disp('not implemented');
        case 3
            dep = A.info.Depth; 
            C = getslice(A,1);
            for i=2:dep
                C = C+getslice(A,i);
            end
        otherwise
             disp('maximum dimension for summation can be 3');
    end
else
    disp('input argument should be CT object');
end

