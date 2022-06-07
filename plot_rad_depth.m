function plot_rad_depth(rad_matrix)
    %function that plot dose map
        % create second axes
        ax3 = axes;

        %define alpha array for transparency
        rad_max = max(rad_matrix, [], 'all');
        alpha_array = 0.3*(rad_matrix>=0.25*rad_max);

        % plot the dose
        imagesc(ax3, rad_matrix, 'AlphaData', alpha_array);
        ax3.YDir = 'normal';

        %manipulate axes
        ax3.Colormap = hsv;
        ax3.Visible = 'off';
        ax3.XTick = [];
        ax3.YTick = [];
end
