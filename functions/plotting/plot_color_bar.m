function plot_color_bar(d)
% PLOT_COLOR_BAR Show color bar for cell descriptor plots
%   The function creates the colorbar forthe cell descriptor plot based on
%   the predefined colormap and color magnitude limits

% check if cell descriptor simulation
if any(d.pl.cellStyle == 7:13)
    
    % assign the colormap
    colormap(d.pl.colormap)
    
    % make the color bar to the bottom
    colorbar('southoutside','FontSize',12)
    
    % set the color limits
    caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
end

end