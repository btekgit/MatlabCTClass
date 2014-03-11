function [ct_in] = union_voi_mat(ct_in,A,y,x,sliceno,hei,wid,dep, union_function_name)
% [ct_in] = union_voi_mat(ct_in,A,y,x,sliceno,hei,wid,dep,union_function_name)
%--------------------------------------------------------------------------
% This function implements set_voi_mat method for a CT object
% It replaces a voi in a ct object with the given matrix A. 
% width height depth parameters may seem unnecessary given the matrice A
% has already its size, but this is to prevent misplacing the corner windows 
% I have to get the original intended size of the window, around center to
% place it properly.
%       F. Boray Tek, 27/05/08
%       Last Updated, 28/05/08 changed calling convention to suit matlab
%       matrix calling convention. 
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   ct_in    : Input CT object
%   A        : Input matrix: 
%   x,y      : coordinates of the center in xy plane
%   sliceno  : slicenumber to be extracted
%  hei,width, dep : sizes of the originally intended window, note that this
%  is not equal to [hei, wid, dep ] = size(A); for non-corner windows.
%   union_function_name  : is the function name whichever you want to use when
%   merging
    
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%
%  ct_1      : returns ct_1 
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

if (nargin ==5)
    [hei,wid, dep] = size(A);
    disp('non corner window will be placed symmetrical to its center');
elseif nargin < 5
    disp('CT:set_roi_mat:incorrectarguments', 'number of args must be at least 5 , see help');
    return; 
end
    
if ((sliceno<1)&&(sliceno>ct_in.info.Depth))
    error('CT:get_roi_mat:incorrectarguments', 'z value out of bounds , see help');
end

% no need to check  boundaries?
z1 = double(sliceno-floor(dep/2));
if (z1< 1) 
    z1 = double(1); 
end
z2 =double(sliceno+floor(dep/2)); 
if (z2 >ct_in.info.Depth) 
    z2 = double(ct_in.info.Depth); 
end

% update depth 
%dep = length(z1:z2); 


y1= double(y-floor(hei/2));
if ( y1 < 1) 
    y1 = double(1); 
end
y2= double(y+floor(hei/2));
if ( y2 >ct_in.info.Height) 
    y2 = double(ct_in.info.Height); 
end

% no update for y
x1= double(x-floor(wid/2));
if ( x1 < 1)
    x1 = double(1); 
end
x2= double(x+floor(wid/2));
if ( x2 >ct_in.info.Width) 
    x2 = double(ct_in.info.Width); 
end

% or x. 

if (isa(ct_in,'CT'))
    if (iscell(ct_in.slice))
        k =1; 
        for ix = z1:z2
            tmp_slice =ct_in.slice{ix};
            inp_slice = A(:,:,k);
            cls_id = class(tmp_slice(1));
            inp_slice = cast(inp_slice, cls_id);
            B = tmp_slice(y1:y2,x1:x2);
            tmp_slice(y1:y2,x1:x2)= feval(union_function_name,inp_slice,B); 
            ct_in.slice{ix}= tmp_slice; 
            k = k+1;
        end
    else
        B = ct_in.slice(y1:y2,x1:x2,z1:z2);

        cls_id = class(B(1));
        A = cast(A, cls_id);
            
        B = feval(union_function_name, A,B);
        ct_in.slice(y1:y2,x1:x2,z1:z2) = B;
    end
else
    error('CT:cell:errormsg1', 'This function accepts CT object and a 3d matrix');
end
%b = cputime-t