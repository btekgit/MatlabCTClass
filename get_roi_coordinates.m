function B= get_roi_coordinates(A,wnd_size,overlap)
%function B= get_roi_coordinates(A,wnd_size,overlap)
% 
%--------------------------------------------------------------------------
% This function extracts roi center coordinates for ct objects
% Roi is a linearly spaced two dimensional window of size wnd_size and overlap . 
%       F. Boray Tek, 23/05/08
%       Last Updated, 27/02/2013
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   A    :   this is the input CT set
%  wnd_size        : window size can be 2 dimension as below. 
%   wnd_size(1)    :   window size y
%   wnd_size(2)   :   window size x
%   overlap        : degree of overlap , can be 2 dimension
%
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  B  :  list of coordinate boundaries, cell list
% B = [int16(Y(:)) int16(X(:)) int16(Z(:))];
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
    wnd_size(1:2) = wnd_size;
end

if (length(overlap) ==1 )
    overlap(1:2) = overlap;
end



lin_y =(1+ floor(wnd_size(1)/2)):(wnd_size(1)-overlap(1)):(nrows);
lin_x =(1+ floor(wnd_size(2)/2)):(wnd_size(2)-overlap(2)):(ncols);
lin_z =1:1:nslice;

[Y,X,Z] = meshgrid(int16(lin_y), int16(lin_x), int16(lin_z)) ;

B = [int16(Y(:)) int16(X(:)) int16(Z(:))];

