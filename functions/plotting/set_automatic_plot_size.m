function set_automatic_plot_size(d)
% SET_AUTOMATIC_PLOT_SIZE Set the plot area size based on the cells
%   The function defines the cell plot area so that the cells in the model
%   fill most of the view

% if automatic sizing is active
if d.pl.automaticSize
    
    % find the square size that fits the epithelium
    maxSize = get_maximum_epithelium_size(d);
    
    % set the size as the largest distance plus default cell radius
    d.pl.windowSize = maxSize + d.spar.rCell;
    
    % set the plot limits
    d.pl.axesHandle.XLim = [-d.pl.windowSize d.pl.windowSize];
    d.pl.axesHandle.YLim = [-d.pl.windowSize d.pl.windowSize];
end

end