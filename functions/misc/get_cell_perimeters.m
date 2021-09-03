function cells = get_cell_perimeters(cells)

for k = 1:length(cells)
    cells(k).perimeter = sum(cells(k).leftLengths);
end

end