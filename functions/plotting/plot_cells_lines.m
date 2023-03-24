function plot_cells_lines(d,k)
% PLOT_CELLS_LINES Plot the cells as points and lines
%   The function plots the cell bodies as points connected by lines to
%   their neighbors
%   INPUTS:
%       d: main simulation data structure
%       k: current cell index
%   by Aapo Tervonen, 2021

% find the unique neighboring cells
neighbors = unique(d.cells(k).junctions.cells(:));

% remove the nonjunction neighboring zero
neighbors(neighbors == 0) = [];

% get the cell center coordinates
centerX = mean(d.cells(k).verticesX);
centerY = mean(d.cells(k).verticesY);

% plot the cell center as a point
plot(d.pl.axesHandle,centerX,centerY,'-ok','MarkerSize',7,'MarkerFaceColor','k')

% if there are neighbors
if numel(neighbors) > 0
    
    % go through the neighbors
    for k2 = neighbors'
        
        % get the neighbor center coordinates
        nCenterX = mean(d.cells(k2).verticesX);
        nCenterY = mean(d.cells(k2).verticesY);
        
        % plot the connecting line between the cells
        plot(d.pl.axesHandle,[centerX nCenterX],[centerY nCenterY],'-ok','MarkerSize',7,'MarkerFaceColor','k')
    end
end

end