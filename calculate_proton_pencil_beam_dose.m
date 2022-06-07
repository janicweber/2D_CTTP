function [pb] = calculate_proton_pencil_beam_dose(dose_data, image_data, angle, energy, latpos, raddepth)
    % calculate realistic proton pencil beam dose
%-------------------------------------------------------------------------------
    % store all proton data
    energies = dose_data.energies;
    energy_diff = (energies-energy);
    energy_index = find(abs(energy_diff) == min(abs(energy_diff)));
    energy_index = energy_index(1,1);
    water_matrix = dose_data.dosedata(energy_index);
    water_matrix_energy = water_matrix{1};

    % store image and depth data
    rad_matrix = raddepth;
    voi_matrix = image_data.voi;
    ct_voxelsize = image_data.voxelsize;
    [m_ct,n_ct] = size(rad_matrix);
    ind_tumor = image_data.tumor_center;
    dose_matrix = zeros([m_ct,n_ct]);

    % Angle tracing
    max_length = n_ct * ct_voxelsize;
    max_step = 0.05 * ct_voxelsize;
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

                % check if position is outside of majority of dose
                if abs(x_delta) > (ct_voxelsize*20)
                    dose_matrix(i, j) = 0;
                else
                    % check depth
                    z = rad_matrix(i, j);
                    % convert variable to index
                    z_proton = water_matrix_energy(:,1);
                    z_ind = find(abs(z_proton - z) == min(abs(z_proton - z)));
                    z_ind = z_ind(1,1); %in case there are 2 values
                    % calculate dose
                    D = water_matrix_energy(z_ind,2);
                    sigma = water_matrix_energy(z_ind, 3);
                    dose_matrix(i, j) = D / (2*pi*sigma^2) ...
                    * exp(-(x_delta^2)/(2*sigma^2));
                end

            end
        end
    end

%-------------------------------------------------------------------------------
    pb = struct;
    pb.dose = dose_matrix;
    pb.angle = angle;
    pb.energy = energies(energy_index);
    pb.latpos = latpos;
    return
end
