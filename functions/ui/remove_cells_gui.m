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

% if the function is called for CMD simulation
if isfield(app,'cmdRemovedCells')
   
    % if cells are removed
    if app.cmdRemovedCells.size >= 0
        
        % get the size for the removal shape
        shapeSize = app.cmdRemovedCells.size*1e-6/d.spar.scalingLength/2;
        
        % initialize cells outside the shape
        outsideShape = [];
        
        % go through the cells
        for k = 1:length(d.cells)
            
            % get the cell center
            cellCenterX = mean(d.cells(k).verticesX);
            cellCenterY = mean(d.cells(k).verticesY);
            
            % if the shape is square, find the cells outside
            if strcmp(app.cmdRemovedCells.type,'s')
                if ~(cellCenterX > -shapeSize && cellCenterX < shapeSize && cellCenterY > -shapeSize && cellCenterY < shapeSize)
                    outsideShape(end+1) = k; %#ok<*AGROW>
                end
                
            % if the shape is circle, find the cells outside
            elseif strcmp(app.cmdRemovedCells.type,'c')
                if ~(sqrt(cellCenterX^2 + cellCenterY^2) <= shapeSize)
                    outsideShape(end+1) = k;
                end
            end
        end
        
        % save the cell outside
        app.import.removedCells = outsideShape;
        
    % otherwise, no cells removed
    else
        app.import.removedCells = [];
    end

end

% if there are cells to remove
if ~isempty(app.import.removedCells)
    
    % sort the cells to be removed
    app.import.removedCells = sort(app.import.removedCells);
    
    % get the cells in a temporary vector
    removedCellsTemp = app.import.removedCells;
    
    % remove the cells that do not exist (e.g. if the chosen time point
    % does not yet include some of the cells that have been removed)
    removedCellsTemp(removedCellsTemp > length(d.cells))= [];
    
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