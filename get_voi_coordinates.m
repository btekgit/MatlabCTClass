function B= get_voi_coordinates(A,wnd_size,overlap)
%function B= get_voi_coordinates(A,wnd_size,overlap)
% Assuming 3 dimensional input, % use get_roi_coordinates for 2d instead 
%--------------------------------------------------------------------------
% This function extracts voi coordinates from CT object A
% Vois are placed linearly, of size wnd_size and overlap by value overlap
% pixels
%       F. Boray Tek, 23/05/08
%       Last Updated,
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   A    :   this is the input CT set
%  wnd_size        : window size can be 3 dimension as below. 
%   wnd_size(1)    :   window size y
%   wnd_size(2)   :   window size x
%   wnd_size(3)    :   window size z
%   overlap        : degree of overlap , can be 3 dimension
%
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  B  :  list of coordinate boundaries, cell list
%--------------------------------------------------------------------------
% see also get_roi_coordinates


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

if (nargin < 3) 
    disp('usage function B= sum(A,wnd_size,overlap)');
    return;
end


if (isa(A, 'CT'))
    [nrows, ncols,nslice] = getsize(A); % take size of ct
elseif(iscell(A))
    nslice =  length(A);
    [nrows, ncols] = size(A{1}); % take size for cell
else
    [nrows, ncols] = size(A); % take size for numeric
end


if (length(wnd_size) ==1 )
    wnd_size(1:3) = wnd_size;
end

if (length(overlap) ==1 )
    overlap(1:3) = overlap;
end



lin_y =int16((1+ floor(wnd_size(1)/2)):(wnd_size(1)-overlap(1)):((nrows)+floor(wnd_size(1)/2)));
lin_x =int16((1+ floor(wnd_size(2)/2)):(wnd_size(2)-overlap(2)):((ncols)+floor(wnd_size(2)/2)));
lin_z =int16((1+ floor(wnd_size(3)/2)):(wnd_size(3)-overlap(3)):((nslice)+floor(wnd_size(3)/2)));

[Y,X,Z] = meshgrid( lin_y, lin_x, lin_z) ;

B = [int16(Y(:)) int16(X(:)) int16(Z(:))];

