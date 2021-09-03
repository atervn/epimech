function plot_cells_neighbor_numbers(d,k)

neighbors = unique(d.cells(k).junctions.cells(:));
neighbors(neighbors == 0) = [];
cellNumber = length(neighbors);
color = get_neighbor_color(cellNumber);
fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY, color, 'linewidth', 0.1, 'edgecolor', color,'HandleVisibility','off')