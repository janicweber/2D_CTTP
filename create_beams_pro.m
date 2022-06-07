function beams = create_beams_pro(dose, image_data, angles)
    % take dose distribution in water, CT image and a set of angles
    % calculate the dose in each beamNo struct for a beamlet
    % return an array of structs

    disp("---creating proton dose fluence matrix")

    angles = angles{1};
    n_angles = numel(angles);
    beamlets = -30:5:30;
    n_beamlets = numel(beamlets);
    beams = cell(1,1);
    
    beamNo = struct;

    counter = 1;
    for i = 1:n_angles
        angle = angles(i);
        rad = calculate_raddepth(image_data, angle);

        for j = 1:n_beamlets
            beamlet = beamlets(j);
            energy_soll = calculate_bragg(image_data, rad, angle, beamlet);
            %------------------------------------------------
            if energy_soll == 0
                continue
            else
                energies = dose.energies;
                diff_1 = (energies-energy_soll(1));
                diff_2 = (energies-energy_soll(2));
                start = find(abs(diff_1) == min(abs(diff_1)));
                start = start(1,1);
                stop = find(abs(diff_2) == min(abs(diff_2)));
                stop = stop(1,1);
                E_range = energies(start:stop);
                n_ranges = numel(E_range);

                for k = 1:n_ranges
                    %------------------------------------------------
                    energy_haben = E_range(k);
                    single_pencil = calculate_proton_pencil_beam_dose(...
                    dose, image_data, angle, energy_haben, beamlet, rad);

                    beamNo.angle = angle;
                    beamNo.raddepth = rad;
                    beamNo.energy = single_pencil.energy;
                    beamNo.beamletpos = beamlet;
                    beamNo.pb = single_pencil;
                    beams{counter} = beamNo;
                    counter = counter + 1;
                end
            end
        end

    end

    return

end