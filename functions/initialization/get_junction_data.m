function cells = get_junction_data(cells)
% GET_JUNCTION_DATA Derive the additional junction data
%   The function derives the addition junction data from the main junction
%   data.
%   INPUT:
%       cells: cell data structure
%   OUTPUT:
%       cells: cell data structure
%   by Aapo Tervonen, 2021

% zero and cell number vectors needed to get unique cells
zeroVec = zeros(1,length(cells));
cellNumbers = (1:size(cells,2));

% go through the cells
for k = 1:length(cells)
    
    % find the vertices with at least one junction
    cells(k).junctions.linkedIdx1 = find(cells(k).vertexStates > 0);
    
    % find the pair cell and vertex indices for them
    cells(k).junctions.pairCells1 = cells(k).junctions.cells(cells(k).junctions.linkedIdx1,1);
    cells(k).junctions.pairVertices1 = cells(k).junctions.vertices(cells(k).junctions.linkedIdx1,1);
    
    % if there are vertices with junctions, get the unique neighboring
    % cells for the first junctions
    if numel(cells(k).junctions.linkedIdx1) > 0
        cells(k).junctions.linked2CellNumbers1 = get_uniques(cells(k).junctions.pairCells1,cellNumbers,zeroVec)';
    else
        cells(k).junctions.linked2CellNumbers1 = [];
    end
    
    % find the vertices with two junctions
    cells(k).junctions.linkedIdx2 = find(cells(k).vertexStates == 2);
    
    % find the pair cell and vertex indices for them
    cells(k).junctions.pairCells2 = cells(k).junctions.cells(cells(k).junctions.linkedIdx2,2);
    cells(k).junctions.pairVertices2 = cells(k).junctions.vertices(cells(k).junctions.linkedIdx2,2);
    
    % if there are vertices with two junctions, get the unique neighboring
    % cells for the second junctions
    if numel(cells(k).junctions.linkedIdx2) > 0
        cells(k).junctions.linked2CellNumbers2 = get_uniques(cells(k).junctions.pairCells2,cellNumbers,zeroVec)';
    else
        cells(k).junctions.linked2CellNumbers2 = [];
    end
end

end