function plot_dose(dose_matrix)
    %function that plot dose map
        % create second axes
        ax2 = axes;

        %define alpha array for transparency
        dose_max = max(dose_matrix, [], 'all');
        cut_off = (dose_matrix>=0.09*dose_max);
        alpha_array = 0.024*(dose_matrix).*cut_off;

        % plot the dose
        hold on;
        imagesc(ax2, dose_matrix, 'AlphaData', alpha_array);
        contour(ax2, dose_matrix, 'LevelStep', ...
        0.14*dose_max, 'Linestyle', '-');
        hold off;
        ax2.YDir = 'normal';

        %manipulate axes
        ax2.Colormap = jet;
        ax2.Visible = 'off';
        ax2.XTick = [];
        ax2.YTick = [];
        %axis(ax2, 'equal');
        colorbar(ax2,'Position',[.94 .11 .02 .82]);
end
