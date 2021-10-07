function plot_cell_numbers(d,k)
% PLOT_CELL_NUMBERS Plot the cell index
%   The function plots the cell index to the cell center if the cell size
%   is large enough.
%   INPUTS:
%       d: main simulation data structure
%       k: current cell index
%   by Aapo Tervonen, 2021

% if the cell numbers are to be plotted and the cells are plotted (cell
% style is not 0)
if d.pl.cellNumbers && d.pl.cellStyle ~= 0
    
    % get the cell center
    cellCenterX = (max(d.cells(k).verticesX) + min(d.cells(k).verticesX))/2;
    cellCenterY = (max(d.cells(k).verticesY) + min(d.cells(k).verticesY))/2;
    
    % if the cell style is filled black
    if d.pl.cellStyle == 4
        
        % plot the index in white (with clipping on so cell indices outside
        % the plot area are not plotted)
        txt = text(d.pl.axesHandle,cellCenterX, cellCenterY, num2str(k),'Color', [1 1 1], 'HorizontalAlignment','center','VerticalAlignment', 'middle','clipping','on');
    
    % otherwise
    else
        
        % plot the index in black (with clipping on so cell indices outside
        % the plot area are not plotted)
        txt = text(d.pl.axesHandle,cellCenterX, cellCenterY, num2str(k),'HorizontalAlignment','center','VerticalAlignment', 'middle','clipping','on');
    end
    
    % get the axis hangle
    axesHandle = gca;
    
    % get the width of the visualized area in scaled length
    figureSizeScaled = axesHandle.XLim(2) - axesHandle.XLim(1);
    
    % get the width of the visualized area in pixels
    axisSizeInPixels = d.pl.figureHandle.Position(4)*axesHandle.Position(4);
    
    % get how pixel size in scaled length units
    scaledLengthPerPixels = figureSizeScaled/axisSizeInPixels;
    
    % get how many pixels the normal cell radius is
    cellDiamaterInPixels = d.spar.rCell/scaledLengthPerPixels;
    
    % if the radius is pixels is less than 15
    if cellDiamaterInPixels < 15
        
        % do not show the cell indices
        txt.Visible = 'Off';
    
    % otherwise
    else
        
        % show the indices
        txt.Visible = 'On';
        
        % set the index font size as one fourth of the cell diameter in
        % pixels
        fontSize = cellDiamaterInPixels/4;
        
        % if the fontSize is not between 10 and 20, set it to the closest
        % limit
        if fontSize > 20
            fontSize = 20;
        elseif fontSize < 10
            fontSize = 10;
        end
        
        % set the font size for the text
        txt.FontSize = fontSize;
    end
    
    % assign a tag for the text object (can be used to hide or show the
    % text if the image size is changed later)
    txt.Tag = 'cellnumber';
end

end