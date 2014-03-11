function [A] = getslice(ct_in,sliceno) 
% function [A] = getslice(ct_in,sliceno) 
%--------------------------------------------------------------------------
% This function implements getslice(s) operator for a CT object 
%       F. Boray Tek, 19/05/08
%       Last Updated, 19/05/08
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   ct_in    :   Input CT object 
%   sliceno  :   slicenumber(s) to be extracted             
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  A: 2d array if called ct_in{}
%  A: a cell array of 1,1 if called with ct_in()
% parantheses type makes the difference. 
% matlab builtin functionality. 
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


if (isa(ct_in,'CT'))
    if (length(sliceno)==1)
        if ((sliceno>0)&&(sliceno<=length(ct_in.slice)))
            if (iscell(ct_in.slice))
                A = ct_in.slice{sliceno};
            else
                A = ct_in.slice(:,:,sliceno);
            end
        end
    else
        % use wants more than one slice addressed as a vector
        % no checks , directly access
            if (iscell(ct_in.slice))
                A = ct_in.slice{sliceno};
            else
                A = ct_in.slice(:,:,sliceno);
            end
    end
else
    error('CT:cell:errormsg1', 'This function accepts CT object and outputs a 2d array (or cell)');
end
