function cells = get_cell_areas(cells)

for k = 1:length(cells)
    cells(k).area = calculate_area(cells(k).verticesX,cells(k).verticesY);
end

end