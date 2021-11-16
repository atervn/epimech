function cells = get_cell_contact_forces(cells,spar,k,option)
% GET_CELL_CONTACT_FORCES Calculate the contact forces between cells
%   The function calculates the contact forces that keep the cells from
%   overlapping. This was also keeps the two sides of the cleavage apart
%   during cytokinesis
%   INPUTS:
%       cells: single cell data structure
%       spar: scaled parameter structure
%       k: current cell index
%   OUTPUT:
%       cells: single cell data structure
%   by Aapo Tervonen, 2021

% if there are contacts
if cells(k).contacts.present
    
    % calculate the contact forces with the closest vertices
    [forcesCell1X, forcesCell1Y] = calculate_contact_forces(cells,spar,k,cells(k).contacts.cell1,option);
    
    % calculate the contact forces with the second to closest vertex in
    % another neighbor
    [forcesCell2X, forcesCell2Y] = calculate_contact_forces(cells,spar,k,cells(k).contacts.cell2,option);
    
    % sum the forces
    cells(k).forces.contactX = forcesCell1X + forcesCell2X;
    cells(k).forces.contactY = forcesCell1Y + forcesCell2Y;
    
% otherwise
else
    
    % if there are no contacts
    cells(k).forces.contactX = zeros(cells(k).nVertices,1);
    cells(k).forces.contactY = zeros(cells(k).nVertices,1);
end

% if the cell is in cytokinesis
if cells(k).division.state == 2
    
    % calculate the division contact forces
    [forcesX, forcesY] = calculate_division_contact_forces(cells,spar,k);

    % sum the contact forces with the normal contact forces
    cells(k).forces.contactX = cells(k).forces.contactX + forcesX;
    cells(k).forces.contactY = cells(k).forces.contactY + forcesY;
end

end

function [forcesX, forcesY] = calculate_contact_forces(cells,spar,k,contactData,option)
% CALCULATE_CONTACT_FORCES Calculate the contact forces with the
% neighboring cells
%   The function calculate the contact forces either for the closest
%   vertices or the second to closest vertices in the next closest cell.
%   INPUT:
%       cells: cell data structure
%       spar: scaled parameter structure
%       k: current cell index
%       contactData: data of the closest vertices either for the closest or
%       second to closest cell
%   OUTPUT:
%       forcesX: x-component contact force vector
%       forcesY: y-component contact force vector
%   by Aapo Tervonen, 2021

% square junction length
junctionLengthSq = spar.junctionLength.^2;

% initialize force vectors
forcesX = zeros(cells(k).nVertices,1);
forcesY = forcesX;

% initialize a vector to store the vertices that are too close to
% previous boundary segment of the other cell
tooClosePrevIdx = [];

% if there are vertices with their projection on the previous boundary
% segment to the closest vertex
if contactData.prev.present
    
    
    
    if option == 1
        prevPairVerticesX = contactData.prev.pairVerticesX;
        prevPairVerticesY = contactData.prev.pairVerticesY;
        prevPairVectorsX = contactData.prev.pairVectorsX;
        prevPairVectorsY = contactData.prev.pairVectorsY;
        prevLengths = contactData.prev.lengths;
    else
        
        % initialize vectors for the coordinates of the vertex previous to
        % the closest vertex, the vector and the distance between the two
        prevPairVerticesX = zeros(length(contactData.prev.vertices),1);
        prevPairVerticesY = prevPairVerticesX;
        prevPairVectorsX = prevPairVerticesX;
        prevPairVectorsY = prevPairVerticesX;
        prevLengths = prevPairVerticesX;
        
        % go through the cells where there are closest vertices
        for k2 = contactData.prev.pairCells
            
            % vertices in cell k that have this contact interaction with
            % cell k2
            verticesIdx = contactData.prev.pairCellIDs == k2;
            
            % the indices of the vertices previous to the closest vertices
            % to the cell k vertices
            pairIdx = contactData.prev.pairVertexIDs(verticesIdx);
            
            % get the coordinates, vectors, and distance for these vertices
            % in cell k2
            prevPairVerticesX(verticesIdx) = cells(k2).verticesX(pairIdx);
            prevPairVerticesY(verticesIdx) = cells(k2).verticesY(pairIdx);
            prevPairVectorsX(verticesIdx) = cells(k2).leftVectorsX(pairIdx);
            prevPairVectorsY(verticesIdx) = cells(k2).leftVectorsY(pairIdx);
            prevLengths(verticesIdx) = cells(k2).leftLengths(pairIdx);
        end
    end
    
    % get reciprocal lengths
    reciprocalPairLengths = 1./prevLengths;
    
    % get the unit vectors from the vertices previous to the closest to
    % the closest
    boundaryUnitVectorsX = prevPairVectorsX.*reciprocalPairLengths;
    boundaryUnitVectorsY = prevPairVectorsY.*reciprocalPairLengths;
    
    % get vectors from the vertex previous to the closest to the
    % vertices in cell k
    pairVectorsX = cells(k).verticesX(contactData.prev.vertices) - prevPairVerticesX;
    pairVectorsY = cells(k).verticesY(contactData.prev.vertices) - prevPairVerticesY;
    
    % calculate the perpendicular, closest distance between the
    % boundary segment previous to the closest and the vertex in cell k
    perpendicularLengths = abs(boundaryUnitVectorsX.*pairVectorsY - boundaryUnitVectorsY.*pairVectorsX);
    
    % get reciprocal of the closest distances
    reciprocalPerpendicularLengths = 1./perpendicularLengths;
    
    % find vertices that are too close to the neighboring cells
    tooClose = perpendicularLengths < spar.junctionLength;
    
    % if there are any
    if any(tooClose)
        
        % get the vertex indices that are too close
        tooClosePrevIdx = contactData.prev.vertices(tooClose);
        
        % calculate the magnitude of the force based on the nonlinear
        % spring
        forceMagnitudes = spar.fContact.*(perpendicularLengths(tooClose) - junctionLengthSq.*reciprocalPerpendicularLengths(tooClose));
        
        % calculate the force vector components (the direction is based
        % on the unit vectors of the previous boundary, since this is
        % perpendicular to it)
        forcesX(tooClosePrevIdx) = forcesX(tooClosePrevIdx) - forceMagnitudes.*boundaryUnitVectorsY(tooClose);
        forcesY(tooClosePrevIdx) = forcesY(tooClosePrevIdx) + forceMagnitudes.*boundaryUnitVectorsX(tooClose);
    end
end

% initialize a vector to store the vertices that are too close to next
% boundary segment of the other cell
tooCloseNextIdx = [];

% if there are vertices with their projection on the next boundary
% segment to the closest vertex
if contactData.next.present
    
    if option == 1
        nextPairVerticesX = contactData.next.pairVerticesX;
        nextPairVerticesY = contactData.next.pairVerticesY;
        nextPairVectorsX = contactData.next.pairVectorsX;
        nextPairVectorsY = contactData.next.pairVectorsY;
        nextLengths = contactData.next.lengths;
        
    else
        
        % initialize vectors for the coordinates of the closest vertex, its
        % next vector and distance to the next vertex
        nextPairVerticesX = zeros(length(contactData.next.vertices),1);
        nextPairVerticesY = nextPairVerticesX;
        nextPairVectorsX = nextPairVerticesX;
        nextPairVectorsY = nextPairVerticesX;
        nextLengths = nextPairVerticesX;
        
        % go through the cells where there are closest vertices
        for k2 = contactData.next.pairCells
            
            % vertices in cell k that have this contact interaction with
            % cell k2
            verticesIdx = contactData.next.pairCellIDs == k2;
            
            % the indices of the closest vertices to the cell k vertices
            pairIdx = contactData.next.pairVertexIDs(verticesIdx);
            
            % get the coordinates, vectors, and distance for these vertices
            % in cell k2
            nextPairVerticesX(verticesIdx) = cells(k2).verticesX(pairIdx);
            nextPairVerticesY(verticesIdx) = cells(k2).verticesY(pairIdx);
            nextPairVectorsX(verticesIdx) = cells(k2).leftVectorsX(pairIdx);
            nextPairVectorsY(verticesIdx) = cells(k2).leftVectorsY(pairIdx);
            nextLengths(verticesIdx) = cells(k2).leftLengths(pairIdx);
        end
    end
    
    % get reciprocal lengths
    reciprocalPairLengths = 1./nextLengths;
    
    % get the unit vectors from the closest vertices to the next
    % vertices
    boundaryUnitVectorsX = nextPairVectorsX.*reciprocalPairLengths;
    boundaryUnitVectorsY = nextPairVectorsY.*reciprocalPairLengths;
    
    % get vectors from the closest vertices to the vertices in cell k
    pairVectorsX = cells(k).verticesX(contactData.next.vertices) - nextPairVerticesX;
    pairVectorsY = cells(k).verticesY(contactData.next.vertices) - nextPairVerticesY;
    
    % calculate the perpendicular, closest distance between the
    % boundary segment next to the closest vertex and the vertex in
    % cell k
    perpendicularLengths = abs(boundaryUnitVectorsX.*pairVectorsY - boundaryUnitVectorsY.*pairVectorsX);
    
    % get reciprocal of the closest distances
    reciprocalPerpendicularLengths = 1./perpendicularLengths;
    
    % find vertices that are two close to the neighboring cells
    tooClose = perpendicularLengths < spar.junctionLength;
    
    % if there are any
    if any(tooClose)
        
        % get the vertex indices that are too close
        tooCloseNextIdx = contactData.next.vertices(tooClose);
        
        % calculate the magnitude of the force based on the nonlinear
        % spring
        forceMagnitudes = spar.fContact.*(perpendicularLengths(tooClose) - junctionLengthSq.*reciprocalPerpendicularLengths(tooClose));
        
        % calculate the force vector components
        forcesX(tooCloseNextIdx) = forcesX(tooCloseNextIdx) - forceMagnitudes.*boundaryUnitVectorsY(tooClose);
        forcesY(tooCloseNextIdx) = forcesY(tooCloseNextIdx) + forceMagnitudes.*boundaryUnitVectorsX(tooClose);
    end
end

% check if there are vertices whose projection does not fall on either
% segment around the closest vertex
if contactData.vertex.present
    
    if option == 1
        vertexPairVerticesX = contactData.vertex.pairVerticesX;
        vertexPairVerticesY = contactData.vertex.pairVerticesY;
        
    else
        
        % initialize coordinate vectors for the closest vertices
        vertexPairVerticesX = zeros(length(contactData.vertex.vertices),1);
        vertexPairVerticesY = vertexPairVerticesX;
        
        % go through the close cells
        for k2 = contactData.vertex.pairCells
            
            % vertices in cell k that have this contact interaction with
            % cell k2
            verticesIdx = contactData.vertex.pairCellIDs == k2;
            
            % the indices of the closest vertices to the cell k vertices
            pairIdx = contactData.vertex.pairVertexIDs(verticesIdx);
            
            % get the coordinates, vectors, and distance for these vertices
            % in cell k2
            vertexPairVerticesX(verticesIdx) = cells(k2).verticesX(pairIdx);
            vertexPairVerticesY(verticesIdx) = cells(k2).verticesY(pairIdx);
        end
    end
    
    % get the vectors between the vertices
    vectorsX = vertexPairVerticesX - cells(k).verticesX(contactData.vertex.vertices);
    vectorsY = vertexPairVerticesY - cells(k).verticesY(contactData.vertex.vertices);
    
    % calculate the vector lengths
    vectorLengths = sqrt(vectorsX.^2 + vectorsY.^2);
    
    % find the vertices that are too close the their neighbors
    tooClose = vectorLengths < spar.junctionLength;
    
    % if there are any
    if any(tooClose)
        
        % get the vector lengths
        vectorLengths = vectorLengths(tooClose);
        
        % get the reciprocal vector lengths
        reciprocalVectors = 1./vectorLengths;
        
        % get the vertices that are too close
        tooCloseIdx = contactData.vertex.vertices(tooClose);
        
        % calculate the force magnitudes
        forceMagnitudes = spar.fContact.*(vectorLengths - junctionLengthSq.*reciprocalVectors).*reciprocalVectors;
        
        % get the forces vector between the vertices
        forcesX(tooCloseIdx) = forcesX(tooCloseIdx) + forceMagnitudes.*vectorsX(tooClose);
        forcesY(tooCloseIdx) = forcesY(tooCloseIdx) + forceMagnitudes.*vectorsY(tooClose);
    end
end

% find the cases where the projection of the vertex is on the line
% segments on both sides of the closest vertex
if ~isempty(tooClosePrevIdx) && ~isempty(tooCloseNextIdx)
    
    % get a zero vector
    zeroVector = zeros(1, max(max(tooClosePrevIdx), max(tooCloseNextIdx)));
    
    % assign ones where there are contact with the previous segment
    zeroVector(tooClosePrevIdx) = 1;
    
    % find those that have contact with both segments
    bothCell1 = tooCloseNextIdx(logical(zeroVector(tooCloseNextIdx)));
else
    
    % if there are none
    bothCell1 = [];
end

% if the exist, halve their forces
if numel(bothCell1) > 0
    forcesX(bothCell1) = forcesX(bothCell1)./2;
    forcesY(bothCell1) = forcesY(bothCell1)./2;
end

end


function [forcesX, forcesY] = calculate_division_contact_forces(cells,spar,k)
% CALCULATE_DIVISON_CONTACT_FORCES Calculate the contact forces with the
% other side of the cytokinesis cleavage
%   The function calculate the contact forces for the dividing cell keeping
%   the sides of the cleavage apart
%   INPUT:
%       cells: cell data structure
%       spar: scaled parameter structure
%       k: current cell index
%   OUTPUT:
%       forcesX: x-component contact force vector
%       forcesY: y-component contact force vector
%   by Aapo Tervonen, 2021

% square junction length
junctionLengthSq = spar.junctionLength.^2;

% initialize force vectors
forcesX = zeros(cells(k).nVertices,1);
forcesY = forcesX;

% temporary structure
contactData = cells(k).contacts.division;

% initialize a vector to store the vertices that are too close to
% previous boundary segment
tooClosePrevIdx = [];

% if there are vertices with their projection on the previous boundary
% segment
if contactData.prev.present
    
    % get the coordinates of the vertex previous to the closest vertex, the
    % vector and the distance between the two
    prevPairVerticesX = cells(k).verticesX(contactData.prev.pairIDs);
    prevPairVerticesY = cells(k).verticesY(contactData.prev.pairIDs);
    prevPairVectorsX = cells(k).leftVectorsX(contactData.prev.pairIDs);
    prevPairVectorsY = cells(k).leftVectorsY(contactData.prev.pairIDs);
    prevLengths = cells(k).leftLengths(contactData.prev.pairIDs);
    
    % get reciprocal lengths
    reciprocalPairLengths = 1./prevLengths;
    
    % get the unit vectors from the vertices previous to the closest to
    % the closest
    boundaryUnitVectorsX = prevPairVectorsX.*reciprocalPairLengths;
    boundaryUnitVectorsY = prevPairVectorsY.*reciprocalPairLengths;
    
    % get vectors from the vertex previous to the closest to the
    % vertices
    pairVectorsX = cells(k).verticesX(contactData.prev.vertices) - prevPairVerticesX;
    pairVectorsY = cells(k).verticesY(contactData.prev.vertices) - prevPairVerticesY;
    
    % calculate the perpendicular, closest distance between the
    % boundary segment previous to the closest and the vertex
    perpendicularLengths = abs(boundaryUnitVectorsX.*pairVectorsY - boundaryUnitVectorsY.*pairVectorsX);
    
    % get reciprocal of the closest distances
    reciprocalPerpendicularLengths = 1./perpendicularLengths;
    
    % find vertices that are too close
    tooClose = perpendicularLengths < spar.junctionLength;
    
    % if there are any
    if any(tooClose)
        
        % get the vertex indices that are too close
        tooClosePrevIdx = contactData.prev.vertices(tooClose);
        
        % calculate the magnitude of the force based on the nonlinear
        % spring
        forceMagnitudes = spar.fContact.*(perpendicularLengths(tooClose) - junctionLengthSq.*reciprocalPerpendicularLengths(tooClose));
        
        % calculate the force vector components (the direction is based
        % on the unit vectors of the previous boundary, since this is
        % perpendicular to it)
        forcesX(tooClosePrevIdx) = forcesX(tooClosePrevIdx) - forceMagnitudes.*boundaryUnitVectorsY(tooClose);
        forcesY(tooClosePrevIdx) = forcesY(tooClosePrevIdx) + forceMagnitudes.*boundaryUnitVectorsX(tooClose);
    end
end

% initialize a vector to store the vertices that are too close to next
% boundary segment
tooCloseNextIdx = [];

% if there are vertices with their projection on the next boundary
% segment to the closest vertex
if contactData.next.present
    
    % get the coordinates of the vertex previous to the closest vertex, the
    % vector and the distance between the two
    nextPairVerticesX = cells(k).verticesX(contactData.next.pairIDs);
    nextPairVerticesY = cells(k).verticesY(contactData.next.pairIDs);
    nextPairVectorsX = cells(k).leftVectorsX(contactData.next.pairIDs);
    nextPairVectorsY = cells(k).leftVectorsY(contactData.next.pairIDs);
    nextLengths = cells(k).leftLengths(contactData.next.pairIDs);
    
    % get reciprocal lengths
    reciprocalPairLengths = 1./nextLengths;
    
    % get the unit vectors from the closest vertices to the next
    % vertices
    boundaryUnitVectorsX = nextPairVectorsX.*reciprocalPairLengths;
    boundaryUnitVectorsY = nextPairVectorsY.*reciprocalPairLengths;
    
    % get vectors from the closest vertices to the vertices
    pairVectorsX = cells(k).verticesX(contactData.next.vertices) - nextPairVerticesX;
    pairVectorsY = cells(k).verticesY(contactData.next.vertices) - nextPairVerticesY;
    
    % calculate the perpendicular, closest distance between the
    % boundary segment next to the closest vertex and the vertex
    perpendicularLengths = abs(boundaryUnitVectorsX.*pairVectorsY - boundaryUnitVectorsY.*pairVectorsX);
    
    % get reciprocal of the closest distances
    reciprocalPerpendicularLengths = 1./perpendicularLengths;
    
    % find vertices that are two close
    tooClose = perpendicularLengths < spar.junctionLength;
    
    % if there are any
    if any(tooClose)
        
        % get the vertex indices that are too close
        tooCloseNextIdx = contactData.next.vertices(tooClose);
        
        % calculate the magnitude of the force based on the nonlinear
        % spring
        forceMagnitudes = spar.fContact.*(perpendicularLengths(tooClose) - junctionLengthSq.*reciprocalPerpendicularLengths(tooClose));
        
        % calculate the force vector components
        forcesX(tooCloseNextIdx) = forcesX(tooCloseNextIdx) - forceMagnitudes.*boundaryUnitVectorsY(tooClose);
        forcesY(tooCloseNextIdx) = forcesY(tooCloseNextIdx) + forceMagnitudes.*boundaryUnitVectorsX(tooClose);
    end
end

% check if there are vertices whose projection does not fall on either
% segment around the closest vertex
if contactData.vertex.present
    
    % get the vectors between the vertices
    vectorsX = cells(k).verticesX(contactData.vertex.pairIDs) - cells(k).verticesX(contactData.vertex.vertices);
    vectorsY = cells(k).verticesY(contactData.vertex.pairIDs) - cells(k).verticesY(contactData.vertex.vertices);
    
    % calculate the vector lengths
    vectorLengths = sqrt(vectorsX.^2 + vectorsY.^2);
    
    % find the vertices that are too close
    tooClose = vectorLengths < spar.junctionLength;
    
    % if there are any
    if any(tooClose)
        
        % get the vector lengths
        vectorLengths = vectorLengths(tooClose);
        
        % get the reciprocal vector lengths
        reciprocalVectors = 1./vectorLengths;
        
        % get the vertices that are too close
        tooCloseIdx = contactData.vertex.vertices(tooClose);
        
        % calculate the force magnitudes
        forceMagnitudes = spar.fContact.*(vectorLengths - junctionLengthSq.*reciprocalVectors).*reciprocalVectors;
        
        % get the forces vector between the vertices
        forcesX(tooCloseIdx) = forcesX(tooCloseIdx) + forceMagnitudes.*vectorsX(tooClose);
        forcesY(tooCloseIdx) = forcesY(tooCloseIdx) + forceMagnitudes.*vectorsY(tooClose);
    end
end

% find the cases where the projection of the vertex is on the line
% segments on both sides of the closest vertex
if ~isempty(tooClosePrevIdx)&&~isempty(tooCloseNextIdx)
    
    % get a zero vector
    zeroVector = zeros(1, max(max(tooClosePrevIdx),max(tooCloseNextIdx)));
    
    % assign ones where there are contact with the previous segment
    zeroVector(tooClosePrevIdx) = 1;
    
    % find those that have contact with both segments
    bothInteractions = tooCloseNextIdx(logical(zeroVector(tooCloseNextIdx)));
else
    
    % if there are none
    bothInteractions = [];
end

% if the exist, halve their forces
if numel(bothInteractions) > 0
    forcesX(bothInteractions) = forcesX(bothInteractions)./2;
    forcesY(bothInteractions) = forcesY(bothInteractions)./2;
end

end