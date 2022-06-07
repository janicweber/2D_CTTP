function beams = create_beams(dose, image_data, angles)
    % take dose distribution in water, CT image and a set of angles
    % calculate the dose in each beamNo struct for a beamlet
    % return an array of structs

    disp("---creating photon dose fluence matrix")

    angles = angles{1};
    n_angles = numel(angles);
    beamlets = [-20, -15, -10, -5, 0, 5, 10, 15, 20];
    n_beamlets = numel(beamlets);
    beams = cell(n_beamlets*n_angles,1);
    
    beamNo = struct;

    counter = 1;
    for i = 1:n_angles
        angle = angles(i);
        rad = calculate_raddepth(image_data, angle);

        for j = 1:n_beamlets
            beamlet = beamlets(j);
            single_pencil = calculate_pencil_beam_dose(dose, ...
            image_data, angle, beamlet, rad);

            beamNo.angle = angle;
            beamNo.raddepth = rad;
            beamNo.beamletpos = beamlet;
            beamNo.pb = single_pencil;
            beams{counter} = beamNo;
            counter = counter + 1;
        end

    end

    return

end