function C= times(A,B)
% function C= times(A,B)
% This function overloads C=  A*B for cell arrays
% Only implements element by element multiplication
% both of the arguments can be a cell array.
% B. Tek 19 May 2008 


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


if (iscell(A) & iscell(B)) % first argument is cell
    C = cell(size(A));
    for i = 1: numel(A)
        C{i} = A{i}.*B{i};
        %C{i} = immultiply(A{i},B{i}); IPPL is slower b.tek 20.5.8
    end
elseif (iscell(A)& isscalar(B)) % first argument is cell
    C = cell(size(A));
    for i = 1: numel(A)
        C{i} = A{i}.*B;
%        C{i} = immultiply(A{i},B);
    end
elseif (iscell(B)& isscalar(A))
    C = cell(size(B));
    for i = 1: numel(B)
        C{i} = B{i}.*A;
    end
elseif (iscell(B) & isnumeric(A))
    C = cell(size(B));
    for i = 1: numel(B)
        C{i} = B{i}.*A(:,:,i);
    end
elseif (iscell(A) & isnumeric(B))
    C = cell(size(A));
    for i = 1: numel(A)
        C{i} = A{i}.*B(:,:,i);
    end
    
else
       disp('Unexpected inputs: Only (cell.*cell) (cell.*scalar) is implemented ');
    % in fact is it ever possible to come here.
end