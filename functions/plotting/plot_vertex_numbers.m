function plot_vertex_numbers(d,k)
% PLOT_VERTEX_NUMBERS Plot the cell vertex indices
%   The function plots the cell vertex index if the cell size is large
%   enough.
%   INPUTS:
%       d: main simulation data structure
%       k: current cell index
%   by Aapo Tervonen, 2021

% if the vertex numbers are to be plotted and the cells are plotted (cell
% style is not 0)
if d.pl.vertexNumbers && d.pl.cellStyle ~= 0
    
    % create a vector of vertex numbers
    numberVector = 1:d.cells(k).nVertices;
    
    % create a char array, make it a cell structure, and remove leading or
    % trailing white space (not sure if necessary anymore)
    numberVector = strtrim(cellstr(num2str(numberVector(:))));
    
    % plot the vertex indices to the vertex coordiantes (with clipping to
    % prevent the plotting of indices outside the shown area)
    txt = text(d.pl.axesHandle,d.cells(k).verticesX, d.cells(k).verticesY, numberVector,'HorizontalAlignment','center','VerticalAlignment', 'middle','clipping','on');
    
    % get the axis hangle
    axesHandle = gca;
    
    % get the width of the visualized area in scaled length
    figureSizeinScaled = axesHandle.XLim(2) - axesHandle.XLim(1);
    
    % get the width of the visualized area in pixels
    axisSizeInPixels = d.pl.figureHandle.Position(4)*axesHandle.Position(4);
    
    % get how many pixels the unit scaled length is
    scaledLengthPerPixels = figureSizeinScaled/axisSizeInPixels;
    
    % get how many pixels the normal cell radius is
    cellRadiusInPixels = d.spar.rCell/scaledLengthPerPixels;
    
    % go through the vertex indices
    for i = 1:length(txt)
        
        % if the radius is pixels is less than 200 pixels
        if cellRadiusInPixels < 200
            
            % hide the index
            txt(i).Visible = 'Off';
            
        % otherwise
        else
            
            % show the index
            txt(i).Visible = 'On';
            
            % set the index font size as one fiftieth of the cell diameter
            % in pixels
            fontSize = cellRadiusInPixels/50;
            
            % if the fontSize is not between 7 and 20, set it to the
            % closest limit
            if fontSize > 20
                fontSize = 20;
            elseif fontSize < 7
                fontSize = 7;
            end
            
            % set the font size for the text
            txt(i).FontSize = fontSize;
        end
        
        % create a white box with black edge around the index to make them
        % easier to read
        txt(i).BackgroundColor = [1 1 1];
        txt(i).EdgeColor = [0 0 0];
        
        % assign a tag for the text object (can be used to hide or show the
        % text if the image size is changed later)
        txt(i).Tag = 'vertexnumber';
    end
end

end