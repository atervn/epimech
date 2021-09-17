function d = remove_cells(d)
% REMOVE_CELLS Removes cells if they are too small
%   The function removes cells from the simulation if they have too few
%   vertices or too small area.
%   INPUTS:
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% go through the cells
for k = length(d.cells):-1:1
    
    % check if there are less than 5 vertices in the cell or the cell area
    % is less than half the minimum cell area allowed for new daughter
    % cells after division
    if d.cells(k).nVertices < 5 || d.cells(k).area < d.spar.minimumCellSize
        
        % remove the cell and its junctions and focal adhesions
        d = remove_cell_and_links(d,k,1);
        
        % set the junction modification to true
        d.simset.junctionModification = true;
    end
end