function ct_in = setval(ct_in,val)
% function ct_in = setval(ct_in,val)
% sets all pixel values of ct_in to value val
% type of val, e.g. will reset type of ct_in to type of val
% E.g  ct_1 = setval(ct_1, double(0));
% will change all values to double.
%--------------------------------------------------------------------------
% This function implements the setval method for CT-scan sets.
%       F. Boray Tek, 28/05/08
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   Setval returns the property
%   ct_in: Ct object
%   val: value to be set.
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  ct_in : input ct object.
%
%
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

zm = repmat(val, size(ct_in.slice{1}));
for i = 1:ct_in.info.Depth
    ct_in.slice{i} = zm;
end
