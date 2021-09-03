function cells = remove_cell_and_links(cells,cellToRemove)

cells(cellToRemove) = [];
for k = 1:length(cells)
    linksWithCell2Remove = cells(k).junctions.cells(:) == cellToRemove;
    cells(k).junctions.cells(linksWithCell2Remove) = 0;
    cells(k).junctions.vertices(linksWithCell2Remove) = 0;
    
    cells(k).junctions.cells(cells(k).junctions.cells > cellToRemove) = cells(k).junctions.cells(cells(k).junctions.cells > cellToRemove) - 1;
    
    cells(k).vertexStates = sum(cells(k).junctions.cells > 0,2);
    
    switchJunctions = and((cells(k).vertexStates == 1),(cells(k).junctions.cells(:,1) == 0));
    
    cells(k).junctions.cells(switchJunctions,1) = cells(k).junctions.cells(switchJunctions,2);
    cells(k).junctions.vertices(switchJunctions,1) = cells(k).junctions.vertices(switchJunctions,2);
    cells(k).junctions.cells(switchJunctions,2) = 0;
    cells(k).junctions.cells(switchJunctions,2) = 0;
    
    if cells(k).division.state == 2
        cells(k).vertexStates(cells(k).division.vertices(1)) = -1;
        cells(k).vertexStates(cells(k).division.vertices(2)) = -1;
    end
    
    
end
