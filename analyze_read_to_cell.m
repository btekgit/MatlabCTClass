function [A, inf] =  analyze_read_to_cell(fname, b_cell)
% [A, inf] =  analyze_read_to_cell(fname, b_cell)
% reads analyze files with matlab reader from a folder, directory
% Assumes hdr file is provided
% fname: name of the HDR file
% b_cell: is boolean flag tells function to read the series into a cell

% A:matrix or cell array. Default behaviour is to read directly to cell.
% inf: analyze info if there is any header

% Cell array is for that every slice is a pointed 2d array, just for memory efficiency. When we
% do this we do not need to reserve a big chunk of memory, but individual
% memories for each slice. Of course you are still limited with the total available memory for matlab
% date: 20.05.08
% written: by B.Tek 

% updated 30.06.08 to call analyze75_read_cell function
% default behaviour changes to read directly to cell. 

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

inf = analyze75info(fname);
if ( nargin ==2) 
    if (b_cell) 
        [A] = analyze75read_cell(inf);
    else
        A = analyze75read(inf);
    end
else
    [A] = analyze75read_cell(inf);
end
    













