function cells = remove_cells_gui(app, cells, option)

if ~isempty(app.import.removedCells)
    app.import.removedCells = sort(app.import.removedCells);
    removedCellsTemp = app.import.removedCells;
    removedCellsTemp(removedCellsTemp > max(app.import.nCells)) = [];
    for k = length(removedCellsTemp):-1:1
        switch option
            case 'simulation'
                cells = remove_cell_and_links(cells,removedCellsTemp(k));
            case 'basic_plotting'
                cells(removedCellsTemp(k)) = [];
        end
    end
end