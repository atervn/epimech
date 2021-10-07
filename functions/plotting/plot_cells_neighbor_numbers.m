function plot_cells_neighbor_numbers(d,k)
% PLOT_CELLS_NEIGHBOR_NUMBERS Plot cells with color indicating number of
% neighbors
%   The function plots the cell bodies with the face color indicating their
%   number of neighbors
%       d: main simulation data structure
%       k: current cell index
%   by Aapo Tervonen, 2021

% find the unique neighboring cells
neighbors = unique(d.cells(k).junctions.cells(:));

% remove the nonjunction neighboring zero
neighbors(neighbors == 0) = [];

% find the number of neighbors
cellNumber = length(neighbors);

% get the color value for this amount of neighbors
color = get_neighbor_color(cellNumber);

% plot the cell body with the corresponding face color
fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY, color, 'linewidth', 0.1, 'edgecolor', color);

end