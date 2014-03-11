function sliceviewOverlay(inp,inp2,titlename,sc)
%function sliceview(inp, titlename,sc)
%------------------------------------------------------
% Displays slices of volumetric image set. It is memory friendly
% This "v3.0" version works on both cell arrays and ct objects
% inp, can be an 3D array, a CT object of cell array or matrix
% It enables a slider to change the current slice view,
% titlename, is optional adds the filename as the title
% sc, is optional CLIM = [CLOW, CHIGH] to scale image values for display
% default behaviour of the display will scale between min and max of the slice.

% version: 1.0
% date: 06.05.08
% updated 20.05.08  added sc parameter
% sc is CLIM = [CLOW, CHIGH] to use in imagescale to scale values for
% desired interval.
% written: B. Tek

%
% version: 2.0
% date : 30.05.08
% desired interval.
% written: B. Tek

% version: 3.0
% date : 09.05.08
% changing default behaviour of the display. It will scale with scan max
% and min the all slices.
% B.Tek

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


switch nargin
    case 0
        disp('function "sliceview" displayes an image formed of slices..')
        disp('usage: sliceview(inp, titlename*)')
        return
    case 1
        inp2 =[];
        titlename = 'Unknown';
        sc = 0 ;
    case 2
        titlename = 'Unknown';
        sc = 0;
    case 3 
        sc = 0;
end

if (isa(inp, 'CT'))
    [nrows, ncols,nslice] = size(inp); % take size
    if (sc==0)
        sc(1)= min(inp);
        sc(2)= max(inp);
    end
elseif (iscell(inp))
    nslice =  length(inp);
    [nrows, ncols] = size(inp{1}); % take size
    % convert to 3-d array. It is not the best.
else
    % else do this
    [nrows, ncols, nslice] = size(inp); % take size
    if (sc==0)
        sc(1)= min(inp(:));
        sc(2)= max(inp(:));
    end
    if ( islogical(inp))
        inp = uint8(inp);
    end
    
end

disp(strcat('Displaying set of: ', int2str(nslice),' slices')); %Display what you read

fg_hnd =  figure('Visible','off','Position',[0,0,650,650]);  % create a figure, f is the handle
ax_hnd = axes('Units','Pixels','Position',[70,70,512,512]);     % create an axes

st_hnd = uicontrol(fg_hnd,'Style','text','String','Data Set name','Units','Pixels','Position',[20 620 500 30]);     % create and static textbox for filename
slice_txt_hnd = uicontrol(fg_hnd,'Style','text','String','Data Set name','Units','Pixels','Position',[50 600 500 30]); % create a static textbox for slice number

sld_hnd = uicontrol(fg_hnd,'Style','slider','Max',nslice,'Min',1,'Value',1,'SliderStep',...
    [1/(nslice-1) 1/(nslice-1)*20],'Position',[250 20 100 20],'Callback',{@SliceNumberChange_Callback2,inp,ax_hnd,slice_txt_hnd,nslice,sc,inp2});  %create a slider for the slice manuplation.

% put a name
set(fg_hnd,'Name','Slice View');
% write the name of the file
if(~isempty(titlename))
    set(st_hnd,'String',titlename);
end
% Move the GUI to the center of the screen.
movegui(fg_hnd,'center');
% Make the GUI visible.
set(fg_hnd,'Visible','on');

SliceNumberChange_Callback2(sld_hnd,0,inp,ax_hnd,slice_txt_hnd,nslice,sc, inp2);




% Slider callback..
function SliceNumberChange_Callback2(hObject,eventdata,inpt_img,ax_hndle,txt_hndl, n_slice,clim,ov1)

axes(ax_hndle);
s = get(hObject,'value'); % get slider value
s = fix(s);
if ( (s > n_slice) || (s<1) )
    return;
end
set(txt_hndl,'String',strcat(' Slice: ',int2str(s))); % set the textbox filename with slice no;


if (isa(inpt_img, 'CT'))
    slic = getslice(inpt_img,s);
elseif (iscell(inpt_img))
    slic = inpt_img{s};
elseif (isnumeric(inpt_img))
    slic = inpt_img(:,:,s);
end
dispimage(:,:,1) = uint8(slic);
dispimage(:,:,2) = uint8(slic);
dispimage(:,:,3) = uint8(slic);

if (~isempty(ov1))
    if (isa(inpt_img, 'CT'))
        slice_ov = getslice(ov1,s);
    elseif (iscell(ov1))
        slice_ov = ov1{s};
    elseif (isnumeric(ov1)|islogical(ov1))
        slice_ov = ov1(:,:,s);
    end
    dispimage(:,:,slice_ov>0) = 255;
end

if (clim ==0 )
    image(dispimage,'Parent',ax_hndle); %
else
    image(dispimage,'CDataMapping','scaled', 'Parent',ax_hndle); %
    set(ax_hndle,'CLim',clim);
end
impixelinfo(ax_hndle);
