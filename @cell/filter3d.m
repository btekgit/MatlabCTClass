function C= filter3d(A,B)
%function C= filter3d(A,B)
% function implements 3d filtering  function for cell array
% First input should be cell array of type int16,
% second should be a filter of double
% 


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
    t= A{1}(1,1);
    if(isa(t,'int16'))
        C = filter3d_int16(A.slice,B);
    end
else
    error('cell:gt','one of the inputs should be cell');
end

