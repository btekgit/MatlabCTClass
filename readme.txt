% "CT" class is designed for 3 dimensional volumetric image analysis. 
% Sýmply put, it is written to replicate the numerical matrix array behaviour of
% Matlab for Volumetric Images. The problem of Matlab is that it requires 
% contigous memory blocks ordinary matrices. However, cell arrays can be 
% allocated in a non-contiguous way. Hence the CT class can be constructed by 
% either a cell array or a three dimensional matrix. If you have memory problems
% when operating on volumetric image sets you must definetly use it with cell arrays,
% which will provide the most benefit.
  
% CT class needs the supporting @cell array class provided in the same package
%. @cell array class
% defines ordinary matrix operations, filters, etc for three dimensional
% cell arrays. 
% 
% Obviuously CT class is slower than MATLAB matrix access and manipulation.
% However, it is fast enough to try many ideas
% cell array class has mex functions which perform 2D, and 3D filtering. 
% CT and cell Array classes were only tested in MATLAB 2009a-b and 32 BIT Machines 
% The class and cell array is supplied as it is 
% I do not guarantee any updates. s
% written by F. Boray Tek 
% April 2008-27 Feb 2013

% Copyright 2008-2013 F. Boray Tek.
% All rights reserved.
%

% CT and supporting cell classes are free software; you can redistribute 
% it and/or modify it under the terms of the GNU General Public License 
% as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% CT class is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

% You should have received a copy of the GNU General Public License
% along with CT class.  If not, see <http://www.gnu.org/licenses/>.