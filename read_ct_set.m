function [ct_out] = read_ct_set(fname,bcell)
% function [ct_out] = read_ct_set(fname,bcell) % for analyze
% function [ct_out] = read_ct_set(directoryname,bcell) % for dicom.
%--------------------------------------------------------------------------
% This function reads volumetric images sets of Analyze of Dicom format into
% an output ct object
%       F. Boray Tek, 22/05/08
%       Updated, 27/02/13 , added directory name support for dicom.
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   fname    :   input file name character array
%   bcell    : flag to control cell array or array read
%
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  [ct_out]   :   Output CT object 
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

if nargin ==0
    error('read_ct_set:inputarguments', ' incorrect number of arguments at least the filename must be supplied ');
elseif (nargin ==1)
    bcell =1;
end

% check if directory name given.
if (exist(fname,'dir'))
    [A,inf] = dicom_read_series(fname,bcell);
else
    % assume dicom image
    fext = fname(end-2:end);
    if (strcmp(fext,'dcm'))
        [A,inf] = dicom_read_series(fname,bcell);
    elseif (strcmp(fext,'img')|strcmp(fext,'hdr'))
        [A,inf] = analyze_read_to_cell(fname,bcell);
    else
        error('read_ct_set:invalid_format','input format is not recognised');
    end
end

ct_out = CT(A,inf);