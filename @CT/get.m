function val = get(ct_in,propName)
% function val = get(ct_in,propname)
% Property names are: 'info', 'type', 'iscellarray','isnumeric'
%
%--------------------------------------------------------------------------
% This function implements the get method for CT-scan sets.
%       F. Boray Tek, 19/05/08
%       Last Updated, 27/02/13
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   Get method returns the property
%   ct_in: Ct object
%   propName: property name
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  val   :  Output
%
%
%--------------------------------------------------------------------------
% see also getinfo, size, getsize

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

switch propName
    case 'info'
        val = ct_in.info;
    case 'type'
        val = ct_in.info.type;
    case 'iscellarray'
        val = iscell(ct_in.slice); % boolean
    case 'isnumeric'
        val = isnumeric(ct_in.slice); % boolean
    otherwise
        error([propName ,'Is not a valid CT property'])
end