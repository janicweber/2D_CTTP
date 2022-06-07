function plot_ct_and_voi(data, vois)
    ct_matrix = data.ct;
    voi_matrix = data.voi;
    voinames = data.voinames;
    voi_array = vois{1};
    %function that visualizes ct and region of interest
    iso_range = [0.5, 0.5];  %isolines for contour plot
        % plot ct image
        ax1 = axes;
        imagesc(ax1, ct_matrix);
        ax1.YDir = 'normal';
        ax1.Colormap = gray;
        %axis(ax1, 'equal');
        
        % check if too many vois should be highlighted
        hold on;
        cind = 1;
        colour_arr = ['w', 'g', 'r', 'm', 'y', 'c', 'b', 'k'];
        if numel(voi_array) > numel(colour_arr)
            disp('Warning: Too many voi for highlighting')
            return
        end
        % plot voi contour
        for i = voi_array
            voi_index = find(contains(voinames, i));
            contour(ax1, voi_matrix==voi_index, ...
            iso_range, Linecolor=colour_arr(cind), LineWidth=1.4);
            cind = cind + 1;
        end
        hold off;
end
