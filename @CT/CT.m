function ct_out = CT(varargin)

% function ct_out = CT(B,C)
%--------------------------------------------------------------------------
% "CT" class is designed for 3 dimensional volumetric image analysis. 
% Sýmply put, it is written to replicate the numerical matrix array behaviour of
% Matlab for Volumetric Images. The problem of Matlab is that it requires 
% contigous memory blocks ordinary matrix. However, cell arrays can be 
% allocated in a non-contiguous way. Thus the CT class can be constructed by 
% either a cell array or a three dimensional matrix. If you have memory problems
% when operating on volumetric image sets you must definetly use it with cell arrays. 
% CT class needs the supporting @cell array class. @cell array class
% defines ordinary matrix operations, filters, etc for three dimensional
% cell arrays. 
% 
% Obviuously CT class is slower than MATLAB matrix access and manipulation.
% It is only tested in MATLAB 2009a-b and 32 BIT Machines 
%       F. Boray Tek, 19/05/08
%       Last Updated, 20/05/08 -> added numeric array construction, removed
%       copy constructor.
%       Last Updated, 21/05/08 -> added info compatibility, dicom, analyze
%       Last Updated, 28/05/08 -> changed indexing convention from cell to
%       normal array. 
%--------------------------------------------------------------------------
%   Inputs
%--------------------------------------------------------------------------
%   Default constructor returns an object with empty data and info.
%   B    :   Can be a 3d-array, cell array, or another CT object(copy
%   construction).
%   C    :   Info variable, for scan set info.
%   default_info = struct('type',char(0),'Depth',0, 'Width',0,'Height',0, PixelDimensions,[1 1 1], Dimensions, [0 0 0]);
%
%--------------------------------------------------------------------------
%  Outputs
%--------------------------------------------------------------------------
%  ct_out   :  Output CT object
%
%
%--------------------------------------------------------------------------
% see also cell, array


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

def_info = struct('type',char(0),'Height',0,'Width',0,'Depth',0, 'PixelDimensions',[1 1 1], 'Dimensions', [0 0 0]);

if nargin == 0
    % Default constructor
    ct_out.slice = {[]};
    ct_out.info = def_info;
    ct_out = class(ct_out, 'CT');
else
    n_arg = nargin; % take number of arguments
    bstring_inp = ischar(varargin{1}); % assuming a filename.
    if (bstring_inp)
        error('CT:CT','string input constructor is not implemented');
    end
    bcell_inp =iscell(varargin{1});
    bnumeric_inp = isnumeric(varargin{1});
    slice_data = varargin{1};
    switch n_arg
        case 1
            % cell or array image constructor but no info
            % create info
            def_info.type = 'CT'; % show ct cell
            if (bcell_inp)
                def_info.Depth = length(slice_data);
                [def_info.Height, def_info.Width] = size(slice_data{1});
            elseif (bnumeric_inp)
                [def_info.Height, def_info.Width, def_info.Depth] = size(slice_data);
            end
            def_info.PixelDimensions = [1 1 1];
            def_info.Dimensions = [def_info.Height def_info.Width def_info.Depth];
            if (bcell_inp)
                ct_out = class(struct('slice',{slice_data},'info',def_info), 'CT');
            elseif (bnumeric_inp)
                slice_data = num2cell(slice_data,[1 2]);
                ct_out = class(struct('slice',{slice_data},'info',def_info), 'CT');
            end
        case 2
            %there is info also
            in_info = varargin{2};

            % for compatibility with analyze , adding some fields to the
            % info of dicom
            % def_info.PixelDimensions = [1 1 1];
            % def_info.Dimensions = [def_info.Width def_info.Height def_info.Depth];
            if (bcell_inp)
                in_info.Depth =  length(slice_data);
            elseif (bnumeric_inp)
                in_info.Depth =  size(slice_data,3);
            end
            if(isfield(in_info,'Format'))
                if(strcmp(in_info.Format, 'DICOM'));
                    in_info.PixelDimensions = [in_info.PixelSpacing];
                    in_info.Dimensions = [in_info.Height in_info.Width in_info.Depth];
                elseif (strcmp(in_info.Format, 'Analyze'))
                    in_info.Dimensions = [in_info.Height in_info.Width in_info.Depth];
                end
            end
            % note that matlab convention switching the values
            if (bcell_inp)
                ct_out = class(struct('slice',{slice_data},'info',in_info), 'CT');
            elseif (bnumeric_inp)
                slice_data = num2cell(slice_data,[1 2]);
                ct_out = class(struct('slice',{slice_data},'info',in_info), 'CT');
            end

        otherwise
            error('CT:CT:errmsg1', 'Too many input arguments Expecting a cell array or numeric array, and info structure');
    end
    % no need for copy constructor
end


