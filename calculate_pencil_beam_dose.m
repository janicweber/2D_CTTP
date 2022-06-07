function [pb] = calculate_pencil_beam_dose(dose_data, image_data, angle, latpos, raddepth)
    % calculate realistic pencil beam dose
%-------------------------------------------------------------------------------
    water_matrix = dose_data.dose;
    [m_dose, ~  ] = size(water_matrix);
    water_voxelsize = dose_data.voxelsize;
    centralaxis = dose_data.centralaxis_x;

    rad_matrix = raddepth;
    voi_matrix = image_data.voi;
    ct_voxelsize = image_data.voxelsize;
    [m_ct,n_ct] = size(rad_matrix);
    dose_matrix = zeros([m_ct,n_ct]);
    
    x_prime = centralaxis * water_voxelsize;

    % Angle tracing
    max_length = n_ct * ct_voxelsize;
    max_step = 0.05 * ct_voxelsize;
    ind_tumor = image_data.tumor_center;
    step_x = beam2pat([1;0], angle);
    % beam central axis line
    tumor = (-max_length:max_step:max_length).*step_x + ind2xy(ind_tumor(1),ind_tumor(2),ct_voxelsize);
    % shift line in x direction
    shift = beam2pat([0; latpos], angle);
    tumor(2,:) = tumor(2,:) + shift(2);
    tumor(1,:) = tumor(1,:) + shift(1);

%-------------------------------------------------------------------------------
    % cycle through the ct matrix
    for i = 1:m_ct
        for j = 1:n_ct
            if voi_matrix(i,j) == 0  % patient discriminator
                continue
            else
                position = ind2xy(i,j, ct_voxelsize);
                % calculate the distance from position to central axis
                x_delta_vector = [position(1) - tumor(1,:);position(2) - tumor(2,:)];
                % perpendicular line
                x_delta = min( sqrt( x_delta_vector(1,: ).^2 + x_delta_vector(2,:).^2));
                x = x_prime + x_delta; %assume that dose distribution is symmetric

                % check if position is outside of majority of dose
                if abs(x_delta) > (m_dose * 0.4) * water_voxelsize
                    dose_matrix(i, j) = 0;
                else
                    % check depth
                    z = rad_matrix(i, j);
                    dose_position = [x;z];
                    % convert position in index
                    [x_ind, z_ind] = xy2ind(dose_position, water_voxelsize);
                    dose_matrix(i, j) = water_matrix(x_ind, z_ind);
                end

            end
        end
    end

%-------------------------------------------------------------------------------
    pb = struct;
    pb.dose = dose_matrix;
    pb.angle = angle;
    pb.latpos = latpos; % voxel unit
    return
end
