function cells = remove_single_junction(cells,k,junction2Remove,junctionNumber)
% REMOVE_SINGLE_JUNCTION Removes a junction from the cell
%   The function removes the given junction from the current and the pair
%   cells.
%   INPUT:
%       cells: cell data structure
%       k: current cell index
%       junction2Remove: index of the vertex whose junction is to be
%           removed
%       junctionNumber: first or second junction for the vertex
%   OUTPUT:
%       cells: cell data structure
%   by Aapo Tervonen, 2021

% get pair data
cellIDs = cells(k).junctions.cells(junction2Remove,junctionNumber);
vertexIDs = cells(k).junctions.vertices(junction2Remove,junctionNumber);

% first or second junction for the pair vertex
whichJunction = find(cells(cellIDs).junctions.cells(vertexIDs,:) == k);

% update the pair data
cells(cellIDs).junctions.cells(vertexIDs,whichJunction) = 0;
cells(cellIDs).junctions.vertices(vertexIDs,whichJunction) = 0;

% update the pair vertex states
if cells(cellIDs).vertexStates(vertexIDs) == 2
    cells(cellIDs).vertexStates(vertexIDs) = 1;
    
    % if the removed junction was the first junction for the
    % pair, copy the data from the second to the first
    if whichJunction == 1
        cells(cellIDs).junctions.cells(vertexIDs,1) = cells(cellIDs).junctions.cells(vertexIDs,2);
        cells(cellIDs).junctions.vertices(vertexIDs,1) = cells(cellIDs).junctions.vertices(vertexIDs,2);
        cells(cellIDs).junctions.cells(vertexIDs,2) = 0;
        cells(cellIDs).junctions.vertices(vertexIDs,2) = 0;
    end
else
    cells(cellIDs).vertexStates(vertexIDs) = 0;
end

% reset the junction data for the first junction
cells(k).junctions.cells(junction2Remove,junctionNumber) = 0;
cells(k).junctions.vertices(junction2Remove,junctionNumber) = 0;

end