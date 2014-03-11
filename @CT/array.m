function [data,inf] = array(ct_in) 
% function [data,inf] = array(ct_in) 
%--------------------------------------------------------------------------
% This function implements CT object to numeric array convertor 
%       F. Boray Tek, 29/05/08
%       Last Updated, 19/05/08
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   ct_in    :   Input CT object
%              
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  data: data part, slices, of the CT set
%  inf :  info part, header, of the CT. 
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

inf = ct_in.info;
if (isa(ct_in,'CT'))
    if (iscell(ct_in.slice))
        t = ct_in.slice{1}(1,1); % for type conversation
        data = repmat(t-t,double([inf.Height inf.Width  inf.Depth]));
        for i = 1: inf.Depth
            data(:,:,i) = ct_in.slice{i};
        end
        
    end
    if nargout ==2
        inf = ct_in.info;
    end
    
else
    error('CT:cell:errormsg1', 'This function accepts CT object and outputs a numeric array and structure info');
end
