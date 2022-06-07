function energy_range = calculate_bragg(image_data, rad, angle, latpos)
    % calculate energy necessary to achieve bragg peak in target tissue
    % slow ray tracing algorithm
    [m_ct,n_ct] = size(rad);
    ct_voxelsize = image_data.voxelsize;
    voi_matrix = image_data.voi;
    max_length = n_ct * ct_voxelsize;
    max_step = 0.1 * ct_voxelsize;
    ind_tumor = image_data.tumor_center;
    step_x = beam2pat([1;0], angle);
    probe = (max_length:-max_step:-max_length).*step_x + ...
    ind2xy(ind_tumor(1),ind_tumor(2),ct_voxelsize);
    % shift line in x direction
    shift = beam2pat([0; latpos], angle);
    probe(2,:) = probe(2,:) + shift(2);
    probe(1,:) = probe(1,:) + shift(1);
    ind_tumor = find(contains(image_data.voinames, image_data.oir));

    tumor_array = [0];
    rad_array = [0;0];
    counter = 1;
    for i = 1:size(probe,2)
        coord = probe(:,i);
        if coord(1) >= (m_ct-1) * ct_voxelsize || coord(1) <= ct_voxelsize
            continue
        elseif coord(2) >= (n_ct-1) * ct_voxelsize || coord(2) <= ct_voxelsize
            continue
        else
            [y_i,x_i] = xy2ind(coord, ct_voxelsize);
            voi = voi_matrix(y_i, x_i);
            tumor_array(counter) = voi;
            rad_array(:, counter) = [y_i;x_i];
            counter = counter + 1;
        end
    end
    
    start = find(tumor_array==ind_tumor,1, 'first');
    stop = find(tumor_array==ind_tumor,1, 'last');
    
    if isempty(start)==1 || isempty(stop)==1
        energy_range = 0;
    else    
        start_y = rad_array(1, start);
        start_x = rad_array(2, start);
        stop_y = rad_array(1, stop);
        stop_x = rad_array(2, stop);
        rad_start = rad(start_y, start_x);
        rad_stop = rad(stop_y, stop_x);

        range = [rad_start,rad_stop];
        energy_range = (range/0.022).^(0.565);
    end

    return
end