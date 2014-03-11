%% THIS EXAMPLE DEMONSTRATES USE OF GET_VOI_MAT AND SET_VOI_MAT ACCESS 
% this two functions let you to cut out/put in a volume of interest from/to
% a CT object. 
% It is very useful for sliding volume processing
% You can use GET_ROI_MAT and SET_ROI_MAT if you would like to process 2D
% windows in the individual slices. 

ct_1 = read_ct_set('testCT.hdr',1);

ct_2= ct_1; 

echo on; 
wnd_size = [15,15,2]; % wnd_size = [y,x,z] ;  
overlap = 0 ;
% get voi centers. 
voi_list = get_voi_coordinates(ct_1,wnd_size, overlap);
echo off;
ct_2 = setval(ct_2, int16(0));
voi_list_length = length(voi_list)
for i = 1: voi_list_length
    % get the voi
     voi_i = get_voi_mat(ct_1,voi_list(i,1),voi_list(i,2),voi_list(i,3),wnd_size(1),wnd_size(2),wnd_size(3) );
     % process it, it is 3d matrix. 
     voi_o = abs(voi_i);
     figure(34);
     sliceview(voi_o);
     % put it back
     ct_2 = set_voi_mat(ct_2,voi_o, voi_list(i,1),voi_list(i,2),voi_list(i,3),wnd_size(1),wnd_size(2),wnd_size(3));
end