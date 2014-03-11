function val = iscellarray(ct_in)
% function val = iscellarray(ct_in)
% 
%--------------------------------------------------------------------------
% This function implements the iscellarray method for CT-scan sets. 
% alternatively 'get' method can be called
%       F. Boray Tek, 19/05/08
%       Last Updated, 20/05/08
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   Iscellarray method returns a boolean true if data is made of cell array
%   ct_in: Ct object
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  val   :  Output 0 or 1 
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

if (~isa(ct_in, 'CT'))
    error('CT:iscellarray','ct_in Is not a valid CT object')
end

val = iscell(ct_in.slice);
