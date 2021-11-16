function cells = get_cell_junction_forces(cells,spar,k)
% GET_JUNCTION_FORCES Calculate forces in the cell-cell junctions
%   The function calculates the forces in the cell-cell junctions between
%   the cells based on a linear spring
%   INPUTS:
%       cells: single cell data structure
%       spar: scaled parameters
%   OUTPUT:
%       cells: single cell data structure
%   by Aapo Tervonen, 2021

% initialize the junction force vectors
cells(k).forces.junctionX = zeros(cells(k).nVertices,1);
cells(k).forces.junctionY = cells(k).forces.junctionX;

% check that there are junctions for the cell k
if numel(cells(k).junctions.pairCells1) > 0
    
    % get the junction data
    junctions = cells(k).junctions;
    
    % initialize the pair vertex coordinate vectors
    pair1VerticesX = zeros(length(junctions.pairCells1),1);
    pair1VerticesY = pair1VerticesX;
    
    % go through the neighboring cells of the first junctions
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
    
    % calculate the junction forces for the first junctions
    cells(k).forces.junctionX(junctions.linkedIdx1) = forceMagnitudes.*(pair1VerticesX - cells(k).verticesX(junctions.linkedIdx1));
    cells(k).forces.junctionY(junctions.linkedIdx1) = forceMagnitudes.*(pair1VerticesY - cells(k).verticesY(junctions.linkedIdx1));
    
    
    % if there are second junctions
    if numel(cells(k).junctions.pairCells2) > 0
        
        % initialize the pair vertex coordinate vectors
        pair2VerticesX = zeros(length(junctions.pairCells2),1);
        pair2VerticesY = pair2VerticesX;
        
        % go through the neighboring cells of the second junctions
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
        
        % calculate the force magnitudes for the junctions (the total
        % junction for is calculate as the average for the vertices with
        % two junctions, hence the multiplication by 0.5 here
        forceMagnitudes = 0.5.*spar.fJunctions.*(distances - spar.junctionLength)./distances;
        
        % calculate the junction forces for the vertices with two junctions
        cells(k).forces.junctionX(junctions.linkedIdx2) = 0.5.*cells(k).forces.junctionX(junctions.linkedIdx2) + forceMagnitudes.*(pair2VerticesX - cells(k).verticesX(junctions.linkedIdx2));
        cells(k).forces.junctionY(junctions.linkedIdx2) = 0.5.*cells(k).forces.junctionY(junctions.linkedIdx2) + forceMagnitudes.*(pair2VerticesY - cells(k).verticesY(junctions.linkedIdx2)); 
    end    
end

end