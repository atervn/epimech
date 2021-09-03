function cells = initialize_junction_data(cells)

zeroVec = zeros(1,length(cells));
cellNumbers = (1:size(cells,2));

for k = 1:size(cells,2)
    cells(k).junctions.linkedIdx1 = find(cells(k).vertexStates > 0);
    cells(k).junctions.pairCells1 = cells(k).junctions.cells(cells(k).junctions.linkedIdx1,1);
    cells(k).junctions.pairVertices1 = cells(k).junctions.vertices(cells(k).junctions.linkedIdx1,1);
    if numel(cells(k).junctions.linkedIdx1) > 0
        cells(k).junctions.linked2CellNumbers1 = get_uniques(cells(k).junctions.pairCells1,cellNumbers,zeroVec)';
    else
        cells(k).junctions.linked2CellNumbers1 = [];
    end
    
    cells(k).junctions.linkedIdx2 = find(cells(k).vertexStates == 2);
    cells(k).junctions.pairCells2 = cells(k).junctions.cells(cells(k).junctions.linkedIdx2,2);
    cells(k).junctions.pairVertices2 = cells(k).junctions.vertices(cells(k).junctions.linkedIdx2,2);
    if numel(cells(k).junctions.linkedIdx2) > 0
        cells(k).junctions.linked2CellNumbers2 = get_uniques(cells(k).junctions.pairCells2,cellNumbers,zeroVec)';
    else
        cells(k).junctions.linked2CellNumbers2 = [];
    end
    
    
end

end