function pos_pat = beam2pat(pos_beam, theta)
% converts a point in the beam coordinate system to the patient coordinate
% system
%
% theta is the gantry angle in degrees

theta = theta*pi/180;

% anticlockwise
rotMatrix=[cos(theta) sin(theta) ;-sin(theta) cos(theta)];

pos_pat = inv(rotMatrix)*pos_beam;


