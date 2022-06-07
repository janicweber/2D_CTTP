function [raddepth] = calculate_raddepth(data, angle)
    % raytracing function that calculates radiological depth by given angle
    ct_matrix = data.ct;
    voi_matrix = data.voi;
    voxelsize = data.voxelsize;
%-------------------------------------------------------------------------------
    [m,n] = size(ct_matrix);
    att_matrix = zeros([m,n]);
    rad_matrix = zeros([m,n]);
    v_dir = beam2pat([1;0], angle);
    % measure longest distance
    max_path = voxelsize * round(sqrt(m^2 + n^2),0);
    % calculate stepsize dependent on voxelsize
    stepsize = 0.2 * voxelsize;

%-------------------------------------------------------------------------------
    % convert from Hounsfield units to attenuation coefficient
    ct_zero = ct_matrix < -1000;
    att_matrix(ct_zero) = -1000;

    ct_positive = ct_matrix >= 0;
    att_matrix(ct_positive) = 1 + ct_matrix(ct_positive)/(2000);

    ct_negative = ct_matrix < 0;
    att_matrix(ct_negative) = 1/(1000) * (ct_matrix(ct_negative)+1000);
%-------------------------------------------------------------------------------
    % loop that starts from each patient voxel
    % and sums z_depth in direction of the beam 
    for i = 1:m
        for j = 1:n
            if voi_matrix(i,j) == 0   % patient discriminator
                continue
            else
                for step=1:stepsize:max_path
                    position = ind2xy(i, j, voxelsize) + step*v_dir;
                    [cty, ctx] = xy2ind(position, voxelsize);
                    
                    if voi_matrix(cty,ctx) == 0 % patient discriminator
                        break
                    else
                        rad_matrix(i,j) = rad_matrix(i, j) + att_matrix(cty, ctx)*stepsize;
                    end
                    
                end

            end
        end
    end


%-------------------------------------------------------------------------------
    raddepth = rad_matrix;
    return
end
