function cells = get_cell_junction_forces(cells,spar,k)
% CALCULATE_JUNCTION_FORCES Calculates forces in the cell-cell junctions
%   Calculates the forces in the cell-cell junctions between the cells.
%   INPUTS:
%       cells: contains the cell data
%       spar: scaled parameters
%   OUTPUT:
%       cells: cell data including the junctions forces for each
%       vertex

% go through the cells
% for k = 1:nCells



% initialize the junction force vectors
cells(k).forces.junctionX = zeros(cells(k).nVertices,1);
cells(k).forces.junctionY = cells(k).forces.junctionX;

% check that there are junctions for the cell k
if numel(cells(k).junctions.pairCells1) > 0
    
    junctions = cells(k).junctions;
    
    % initialize the pair vertex coordinate vectors
    pair1VerticesX = zeros(length(junctions.pairCells1),1);
    pair1VerticesY = pair1VerticesX;
    
    % go through the neighboring cells
    for i = 1:length(junctions.linked2CellNumbers1)
        
        % get the index of the neighboring point
        otherCell = junctions.linked2CellNumbers1(i);
        
        % get the vertices of cell k that are connected to the
        % neighboring cells
        verticesIdx = junctions.pairCells1 == otherCell;
        
        % get the vertices of the neighboring cell
        otherVerticesIdx = junctions.pairVertices1(verticesIdx);
        
        % get the coordinates of the vertices of the pair vertices in
        % cell k
        pair1VerticesX(verticesIdx) = cells(otherCell).verticesX(otherVerticesIdx);
        pair1VerticesY(verticesIdx) = cells(otherCell).verticesY(otherVerticesIdx);
    end
    
    % calculate the distances between the vertices and their pairs
    distances = sqrt((cells(k).verticesX(junctions.linkedIdx1) - pair1VerticesX).^2 + (cells(k).verticesY(junctions.linkedIdx1) - pair1VerticesY).^2);
    
    % calculate the force magnitudes for the links
    forceMagnitudes = spar.fJunctions.*(distances - spar.junctionLength)./distances;
    
    % find the junction forces for the long junction links
    cells(k).forces.junctionX(junctions.linkedIdx1) = forceMagnitudes.*(pair1VerticesX - cells(k).verticesX(junctions.linkedIdx1));
    cells(k).forces.junctionY(junctions.linkedIdx1) = forceMagnitudes.*(pair1VerticesY - cells(k).verticesY(junctions.linkedIdx1));
    
    if numel(cells(k).junctions.pairCells2) > 0
        % initialize the pair vertex coordinate vectors
        pair2VerticesX = zeros(length(junctions.pairCells2),1);
        pair2VerticesY = pair2VerticesX;
        
        % go through the neighboring cells
        for i = 1:length(junctions.linked2CellNumbers2)
            
            % get the index of the neighboring point
            otherCell = junctions.linked2CellNumbers2(i);
            
            % get the vertices of cell k that are connected to the
            % neighboring cells
            verticesIdx = junctions.pairCells2 == otherCell;
            
            % get the vertices of the neighboring cell
            otherVerticesIdx = junctions.pairVertices2(verticesIdx);
            
            % get the coordinates of the vertices of the pair vertices in
            % cell k
            pair2VerticesX(verticesIdx) = cells(otherCell).verticesX(otherVerticesIdx);
            pair2VerticesY(verticesIdx) = cells(otherCell).verticesY(otherVerticesIdx);
        end
        
        % calculate the distances between the vertices and their pairs
        distances = sqrt((cells(k).verticesX(junctions.linkedIdx2) - pair2VerticesX).^2 + (cells(k).verticesY(junctions.linkedIdx2) - pair2VerticesY).^2);
        
        % calculate the force magnitudes for the links
        forceMagnitudes = 0.5.*spar.fJunctions.*(distances - spar.junctionLength)./distances;
        
        % find the junction forces for the long junction links
        cells(k).forces.junctionX(junctions.linkedIdx2) = 0.5.*cells(k).forces.junctionX(junctions.linkedIdx2) + forceMagnitudes.*(pair2VerticesX - cells(k).verticesX(junctions.linkedIdx2));
        cells(k).forces.junctionY(junctions.linkedIdx2) = 0.5.*cells(k).forces.junctionY(junctions.linkedIdx2) + forceMagnitudes.*(pair2VerticesY - cells(k).verticesY(junctions.linkedIdx2));
        
    end
    
    
end
% end