function d = remove_cells(d)

areaLimit = 20e-12/d.spar.scalingLength^2;

for k = 1:length(d.cells)
    if k > length(d.cells)
        break
    end
    if d.cells(k).nVertices < 5 || d.cells(k).area < areaLimit
        d.cells = remove_cell_and_links(d.cells,k);
        d.simset.junctionModification = true;
    end
end