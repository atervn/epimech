function set_automatic_plot_size(d)
% SET_AUTOMATIC_PLOT_SIZE Set the plot area size based on the cells
%   The function defines the cell plot area so that the cells in the model
%   fill most of the view

% if automatic sizing is active
if d.pl.automaticSize
    
    % initialize vectors for the maximum and minimum x- and y-coordinates
    maxPointX = zeros(1,length(d.cells));
    minPointX = maxPointX;
    maxPointY = maxPointX;
    minPointY = maxPointX;
    
    % go through the cells and get the maximum and minimum x- and
    % y-coordinates for each cell
    for k = 1:length(d.cells)
        maxPointX(k) = max(d.cells(k).verticesX);
        minPointX(k) = min(d.cells(k).verticesX);
        maxPointY(k) = max(d.cells(k).verticesY);
        minPointY(k) = min(d.cells(k).verticesY);
    end
    
    % get the largest distance from the model center
    maxSize = max(max(abs([maxPointX; minPointX; maxPointY; minPointY])));
    
    % set the size as the largest distance plus default cell radius
    d.pl.windowSize = maxSize + d.spar.rCell;
    
    % set the plot limits
    d.pl.axesHandle.XLim = [-d.pl.windowSize d.pl.windowSize];
    d.pl.axesHandle.YLim = [-d.pl.windowSize d.pl.windowSize];
end

end