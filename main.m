%2D Radiotherapy Treatment Planning System
%===============================================================================
%The following code executes a dose optimisation for a dummy patient in
%when using matlab in command line run: $ run main.m
%===============================================================================
% read data
    path_to_image = 'data_for_PHY471/patientdata.mat';
    path_to_photon_dose = 'data_for_PHY471/photondosedata/beamletdose5mm.mat';
    path_to_proton_dose = 'data_for_PHY471/protondosedata/';
    image = read_file(path_to_image);
    dose_photon_data = read_file(path_to_photon_dose);
    dose_proton_data = read_protondosedata(path_to_proton_dose);
%-------------------------------------------------------------------------------
% initialize TPlan, user input
    disp("---initialize treatment plan:")
    disp(path_to_image)
    image_data = image.TPlan;
%-------------------------------------------------------------------------------
% User input
    image_data.tumor_center = [63,79]; % [y, x]
    regions_to_plot = {'tumor', 'spinal cord', 'esophagus'};
    % Dose Parameters [d_min, d_max, w_o, w_u]
    image_data.d_para_ONA = [0, 18, 3];
    image_data.d_para_OIR = [30, 35, 3, 7];
    image_data.d_para_OAR = [0, 10, 10];
    image_data.oar = {'esophagus', 'spinal cord', 'right lung'};
    image_data.oir = {'tumor'};
%-------------------------------------------------------------------------------
% contour over imagesc
    plot_ct_and_voi(image_data, {regions_to_plot});
%-------------------------------------------------------------------------------
% define beamlet dose
    photon = dose_photon_data.beamletdose;
    proton = dose_proton_data;
%-------------------------------------------------------------------------------
% photon
    % angle_array = 5:31:365;
    % beams = create_beams(photon, image_data, {angle_array});
    % D = create_Dij_matrix(beams);
%-------------------------------------------------------------------------------
% proton
    angle_array = -45:45:45;
    beams = create_beams_pro(proton, image_data, {angle_array});
    D = create_Dij_matrix(beams);
%-------------------------------------------------------------------------------
    TPopt = create_TPopt(image_data);
    bixelw = optimiser(D, TPopt);
    sum_dose_matrix = cramp(D,bixelw, image_data);
    plot_dose(sum_dose_matrix)
%-------------------------------------------------------------------------------
    % lateral = -15;
    % angle = -45;
    % energy=108;
    % rad = calculate_raddepth(image_data, angle);
    % applied = calculate_proton_pencil_beam_dose(proton, image_data, angle, energy, lateral, rad);
    % %applied = calculate_pencil_beam_dose(photon, image_data, angle, lateral, rad);
    % dose_matrix = applied.dose;
    % plot_dose(dose_matrix)
