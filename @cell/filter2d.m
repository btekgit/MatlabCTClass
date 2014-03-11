function C= filter2d(A,B)
% function C= filter2d(A,B)
% function implements cell by cell filtering  function for cell array
% First input should be cell array, second should be 2 filter
% see also filter3d

% update 27/02/2013
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

cell_a = iscell(A);
if (cell_a)
    C = cell(size(A));
    for i = 1: numel(A)
        C{i} = imfilter(A{i},B,'same');
    end
else
        error('cell:gt','one of the inputs should be cell');
end

    