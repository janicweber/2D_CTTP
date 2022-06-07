function pos_beam = pat2beam(pos_pat, theta)
% converts a point in the patient coordinate system to the beam coordinate
% system
%
% theta is the gantry angle in degrees

theta = theta*pi/180;

% clockwise
rotMatrix=[cos(theta) sin(theta) ; -sin(theta) cos(theta)];

pos_beam = rotMatrix*pos_pat;

return

