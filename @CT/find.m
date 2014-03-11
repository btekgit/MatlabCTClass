function [I,J,K] = find(ct_A)
% function [I,J,K] = find(ct_A)
%--------------------------------------------------------------------------
% This function overloads the find functionality of MATLAB  for CT
%       F. Boray Tek, 14/07/08
%       Last Updated, 27/02/2013
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   ct_A    :   this is the input
%              
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
% I : index use ind2sub(size(ct_in),I) to get multiple indices, or use
% multiple outputs:
% I, J : row and coloumn indexes. 
% K : slice index
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


if (isa(ct_A, 'CT')) % first argument is CT 
    [sy,sx,sz] = size(ct_A);
    sy = double(sy); sx = double(sx); sz = double(sz);

    if(nargout==1)
        I = [];
        for s = 1: sz
            Is = s.*sy.*sx.*find(getslice(ct_A,s));
            I = [I; Is];
        end
    elseif (nargout==2)
        disp('Only 1d and 3d index is supported');
    elseif (nargout==3)
        I = [];
        J = [];
        K = [];
        for s = 1: sz
            [Is,Js] = find(getslice(ct_A, s));
            I = [I; Is];
            J = [J; Js];
            len = length(Is);
            
            if (len)
                Ks = repmat(s,len,1);
                K = [K; Ks];
            end
            
        end
    end
else
    disp('input arguments should be CT set');
end