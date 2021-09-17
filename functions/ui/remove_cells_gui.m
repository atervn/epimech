function cells = remove_cells_gui(app, cells, option)

if ~isempty(app.import.removedCells)
    app.import.removedCells = sort(app.import.removedCells);
    removedCellsTemp = app.import.removedCells;
    removedCellsTemp(removedCellsTemp > max(app.import.nCells)) = [];
    
    d.cells = cells;
    
    for k = length(removedCellsTemp):-1:1
        switch option
            case 'simulation'
                d = remove_cell_and_links(d,removedCellsTemp(k));
            case 'basic_plotting'
                d.cells(removedCellsTemp(k)) = [];
        end
    end
   
    cells = d.cells;
    
end

end