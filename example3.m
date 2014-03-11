%% VOI OVERLAPPING EXAMPLE

ct_1 = read_ct_set('C:\BORAY\Lung_data\GGO_Examples_dicom\12646\S1\1.2.392.200036.9116.2.2.2.1762671960.1091672393.30611.dcm',1);

ct_2= ct_1;

RAW_VALUE  =int16(-32768);

ct_2 = setval(ct_2, RAW_VALUE );


wnd_size = [51,51,31]; % wnd_size = [y,x,z] ;
overlap = 3;
% get voi centers.
voi_list = get_voi_coordinates(ct_1,wnd_size, overlap);
voi_list_length = length(voi_list)

for i = 1: voi_list_length
    % get the voi
    voi_in = get_voi_mat(ct_1,voi_list(i,1),voi_list(i,2),voi_list(i,3),wnd_size(1),wnd_size(2),wnd_size(3) );
    % process it, it is 3d matrix.
    voi_processed = voi_in>-500;

    % take the raw one
    voi_raw = get_voi_mat(ct_2,voi_list(i,1),voi_list(i,2),voi_list(i,3),wnd_size(1),wnd_size(2),wnd_size(3) );

    [sy,sx,sz] = size(voi_raw);

    nvoxels = (sz*sy*sx);
    voi_o = voi_raw;
    % do you opearation voxel by voxel, here I did OR
    for k=1:nvoxels
        if ((voi_raw(k))~=RAW_VALUE)
            %voi_o(k) = %(voi_raw(k))+int16(voi_processed(k));
            voi_o(k) =int16(voi_processed(k));
        else
            voi_o(k) = int16(voi_processed(k));
        end
    end

    %sliceview(voi_o);
    % put it back
    ct_2 = set_voi_mat(ct_2,voi_o, voi_list(i,1),voi_list(i,2),voi_list(i,3),wnd_size(1),wnd_size(2),wnd_size(3));
end