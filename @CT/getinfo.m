function [info] = getinfo(ct_in)
% function [info] = getinfo(ct_in)
%--------------------------------------------------------------------------
% This function implements get info operator for a CT object
%       F. Boray Tek, 20/05/08
%       Last Updated, 
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   ct_in    :   Input CT object
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
% info: infor structure which contains type, length, size 
%--------------------------------------------------------------------------
% See also CT/size

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
        info = ct_in.info;
else
    error('CT:getsize:errormsg2', 'This function accepts CT object and outputs info struct');
end
