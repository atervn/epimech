function plot_cells(d,k)
% PLOT_CELLS Plot the cell bodies
%   The function plots the cell bodies based on the selected style.
%   INPUTS:
%       d: main simulation data structure
%       k: current cell index
%   by Aapo Tervonen, 2021

% plot the cells in style 1 (grey filled with internal cells having darker
% shade)
if d.pl.cellStyle == 1
    if d.cells(k).cellState == 0
        fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,[0.8 0.8 0.8], 'linewidth', 2, 'edgecolor', [0.4 0.4 0.4])
    else
        fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,[0.7 0.7 0.7], 'linewidth', 2, 'edgecolor', [0.4 0.4 0.4])
    end
    
% plot the cells in style 2 (red boundaries only)
elseif d.pl.cellStyle == 2
    plot(d.pl.axesHandle,[d.cells(k).verticesX ; d.cells(k).verticesX(1)],[d.cells(k).verticesY ; d.cells(k).verticesY(1)] ,'-r', 'linewidth', 2)

% plot the cells in style 3 (colors showing number of neighbors)
elseif d.pl.cellStyle == 3
    plot_cells_neighbor_numbers(d,k)
    
% plot the cells in style 4 (black filled)
elseif d.pl.cellStyle == 4
    fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,[0 0 0], 'linewidth', 0.5, 'edgecolor', [0 0 0])

% plot the cells in style 5 (cell center shown by a point and lines
% connecting neighboring cells)
elseif d.pl.cellStyle == 5
    plot_cells_lines(d,k)
    
% plot the cellls in style 7:13 (filled based on various cell descriptors)
elseif any(d.pl.cellStyle == 7:13)
    plot_cell_descriptors(d,k)
end

end