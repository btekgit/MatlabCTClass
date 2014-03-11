function [cell_data,cell_inf] = cell(ct_in) 
% function [cell_data,cell_inf] = cell(ct_in)
%--------------------------------------------------------------------------
% This function converts a CT object to a cell array  
%       F. Boray Tek, 19/05/08
%       Last Updated, 19/05/08
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   ct_in    :   Input CT object
%              
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  cell_data: data part, slices, of the CT set
%  cell_inf: info part, header, of the CT. 
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
    cell_data = ct_in.slice;
    if nargout ==2
        cell_inf = ct_in.info;
    end
    
else
    error('CT:cell:errormsg1', 'This function accepts CT object and outputs a cell array and cell info');
end
