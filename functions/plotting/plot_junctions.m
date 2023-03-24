function plot_junctions(d)
% PLOT_JUNCTIONS Plots the cell-cell junctions
%   The function plots the cell-cell junctions by finding the end
%   coordinates for each junction connection and then plotting them all at
%   once.
%   INPUTS:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if vertex data is available and the junctions are to be plotted
if isfield(d.cells, 'verticesX') && d.pl.junctions
    
    % initialize matrices for the coordinates
    coordX = [];
    coordY = [];
    
    % create a cell to hold information what junctions have already been
    % collected
    collectedJunctions = cell(1,length(d.cells));
    
    % go through the cells and get the logical indices of all the junction
    % connections per cell
    for k = 1:length(d.cells)
        collectedJunctions{k} = d.cells(k).junctions.cells > 0;
    end
    
    % go through the cells
    for k = 1:length(d.cells)
        
        % go through the neighboring cells for the first junctions
        for j = d.cells(k).junctions.linkedIdx1'
            
            % check if the junction data has already been collected
            if collectedJunctions{k}(j,1)
                
                % get the pair indices
                cellID = d.cells(k).junctions.cells(j,1);
                vertexID = d.cells(k).junctions.vertices(j,1);
                
                % save the junction end coordinates to the coordinate
                % matrices
                coordX = [coordX [d.cells(k).verticesX(j) ; d.cells(cellID).verticesX(vertexID)]]; %#ok<AGROW>
                coordY = [coordY [d.cells(k).verticesY(j) ; d.cells(cellID).verticesY(vertexID)]]; %#ok<AGROW>
                
                % junction data has been collected, set the indices to
                % false for both the current vertex and the pair (for pair,
                % check which junction this is for it)
                collectedJunctions{k}(j,1) = false;
                whichJunction = d.cells(cellID).junctions.cells(vertexID,:) == k;
                collectedJunctions{cellID}(vertexID,whichJunction) = false;
            end
        end
        
        % go through the neighboring cells for the second junctions
        for j = d.cells(k).junctions.linkedIdx2'
            
            % check if the junction data has already been collected
            if collectedJunctions{k}(j,2)
                
                % get the pair indices
                cellID = d.cells(k).junctions.cells(j,2);
                vertexID = d.cells(k).junctions.vertices(j,2);
                
                % save the junction end coordinates to the coordinate
                % matrices
                coordX = [coordX [d.cells(k).verticesX(j) ; d.cells(cellID).verticesX(vertexID)]]; %#ok<AGROW>
                coordY = [coordY [d.cells(k).verticesY(j) ; d.cells(cellID).verticesY(vertexID)]]; %#ok<AGROW>
                
                % junction data has been collected, set the indices to
                % false for both the current vertex and the pair (for pair,
                % check which junction this is for it)
                collectedJunctions{k}(j,2) = false;
                whichJunction = d.cells(cellID).junctions.cells(vertexID,:) == k;
                collectedJunctions{cellID}(vertexID,whichJunction) = false;
            end
        end
    end
    
    % plot all junction connections
    plot(d.pl.axesHandle,coordX,coordY, '-k', 'linewidth', 1.5);
end

end