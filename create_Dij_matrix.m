function Dij = create_Dij_matrix(beams)
    % take array of dose structs and create the Dij matrix
    % where the dose in each voxel is a vector

    n_beamlets = numel(beams);
    single_beam = beams{1};
    single_dose = single_beam.pb;
    [m,n] = size(single_dose.dose);
    n_entries = m*n;

    Dij = zeros(n_entries, n_beamlets);
    
    
    for i = 1:n_beamlets
        single_beam = beams{i};
        single_dose = single_beam.pb;
        dose_vector = reshape(single_dose.dose, n_entries, 1);
        Dij(:,i) = dose_vector;
    end

    return
end