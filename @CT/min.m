function [C,indx,mnslice]= min(A)
% [C,indx,mnslice]= min(A) for CT overloaded. 
%--------------------------------------------------------------------------
% This function implements global max of a CT set.
%       F. Boray Tek, 30/05/08
%       Last Updated, 06/06/08
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   A    :   this is the first CT set
%   for example 
%   C = min(ct_1);
%              
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  C   :   single numeric value
%  indx : index of the slice 
%  mn_slice: minimum for  each slice
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
dep = A.info.Depth;
bcell_data=  iscell(A.slice);
mnslice = zeros(1,dep);
if (bcell_data)
    for i = 1: dep 
        slice= A.slice{i};
        mnslice(i) = min(slice(:));
    end
else
    for i = 1: dep 
        slice= A.slice(:,:,i);
        mnslice(i) = min(slice(:));
    end
end
     if nargout <2
            C = min(mnslice(:));
    elseif nargout >=2
        [C,indx] = min(mnslice(:));
    end
else
    disp('one of the arguments should be CT set');
end

