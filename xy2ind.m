function [ctx,cty]=xy2ind(p, voxelsize)
    % function [ctx,cty]=xy2ind(p)
    % 
    % returns the indices to a ct voxel given a point p = (x;y) coordinate

    x=p(1);
    y=p(2);

    ctx = 1 + round(x/voxelsize);
    cty = 1 + round(y/voxelsize);

    return
end