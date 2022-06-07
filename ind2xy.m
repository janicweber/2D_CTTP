function [p]=ind2xy(ix,iy, voxelsize)
% function [p]=ind2xp(ix,iy)
% 
% returns the position p = (x;y) of a voxel with indices (ix,iy) 

x=(ix-1) * voxelsize;
y=(iy-1) * voxelsize;

p=[x;y];

return