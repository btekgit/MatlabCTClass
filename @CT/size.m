function [s1,s2,s3] = size(ct_in,dimens)
% function [s] = size(ct_in)
%--------------------------------------------------------------------------
% This function implements size operator for a CT object
%       F. Boray Tek, 30/05/08
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   ct_in    :   Input CT object
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%   s: y,x,z size of the slices
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

if nargin ==1
    if (isa(ct_in,'CT'))
        h = ct_in.info.Height;
        w = ct_in.info.Width;
        d = ct_in.info.Depth;
    else
        error('CT:getsize:errormsg2', 'This function accepts CT object and outputs sl,sy,sx values');
    end
    if nargout<=1 
        s1=[h w d];  
    else
        s1 = h; s2 = w; s3 = d;  
    end

else
    if nargout==1 
    switch dimens
        case 1
            s1 = ct_in.info.Height;
        case 2
            s1 = ct_in.info.Width;
        case 3
            s1 = ct_in.info.Depth;
    end
    end
end
