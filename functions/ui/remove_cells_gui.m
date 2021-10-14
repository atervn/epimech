function d = remove_cells_gui(app, d, option)
% REMOVE_CELLS_GUI Remove cells before simulation or plotting
%   The function removes the cell defined in the GUI before starting
%   simulation or plotting before simulation.
%   INPUT:
%       app: main application data structure
%       d: main simulation data structure
%       option: variable to indicate if this is for simulation or plotting
%   OUTPUT:
%       cells: cell data structure
%   by Aapo Tervonen, 2021

% if there are cells to remove
if ~isempty(app.import.removedCells)
    
    % sort the cells to be removed
    app.import.removedCells = sort(app.import.removedCells);
    
    % get the cells in a temporary vector
    removedCellsTemp = app.import.removedCells;
    
    % remove the cells that do not exist (e.g. if the chosen time point
    % does not yet include some of the cells that have been removed)
    removedCellsTemp(removedCellsTemp > max(app.import.nCells)) = [];
    
    % go through the cells to remove (in reverse)
    for k = length(removedCellsTemp):-1:1
        
        switch option
            
            % for simulation
            case 'simulation'
                d = remove_cell_and_links(d,removedCellsTemp(k));
                
            % for basic plotting (junctions not needed, so the cell can
            % just be removed)
            case 'basic_plotting'
                d.cells(removedCellsTemp(k)) = [];
        end
    end
end

end