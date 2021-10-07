function cells = get_cell_cortical_forces(cells,spar)
% GET_CORTICAL_FORCE Calculate the forces from actin cortex
%   The function calculates the forces that originate from the cortical
%   actin and are defined between every other vertex. If a vertex is
%   concave, the link that connects its neighboring vertices travels
%   "behind" the concave vertex. This means that the forces imposed on the
%   neighboring vertices are directed towards the concave point and the
%   link length equals the sum of the distances between the concave vertex
%   and both of the neighboring vertices. This link also pushes the concave
%   vertex outwards at the same time
%   INPUTS:
%       cells: single cell data structure
%       spar: scaled parameter structure
%   OUTPUT:
%       cells: single cell data structure
%   by Aapo Tervonen, 2021

% calculate the magnitude of each cortical force based on the perimeter
% strain
tempMagnitude = (1 + cells.perimeterConstant.*(cells.perimeter - cells.normPerimeter)/cells.normPerimeter).*spar.fCortex;

% make a vector with the vertex indices
cellIdx= uint32(1:cells.nVertices);

% shift the indices for the right and left side
rightIdx = circshift(cellIdx,1,2);
leftIdx = circshift(cellIdx,-1,2);

% get the indices that are on the other end of each left side cortical
% link (so that only one of them has to be calculated)
mirrorIdx = circshift(cellIdx,2,2);

% get the second to right vertex coordinates
second2leftVerticesX = circshift(cells.verticesX,-2,1);
second2leftVerticesY = circshift(cells.verticesY,-2,1);

% vertex indices that have a nonconcave right side neighbor
leftConvexIdx = cellIdx;

% initialize the force vectors
leftConvexForcesX = zeros(cells.nVertices,1); leftConvexForcesY = leftConvexForcesX;
middleConcaveForcesX = leftConvexForcesX; middleConcaveForcesY = leftConvexForcesX;
rightConcaveForcesX = leftConvexForcesX; rightConcaveForcesY = leftConvexForcesX;
leftConcaveForcesX = leftConvexForcesX; leftConcaveForcesY = leftConvexForcesX;

% find the concave vertices
middleConcaveIdx = cells.outsideAngles < pi;

multipliersTemp = cells.vertexCorticalTensions;

% if there are concave vertices
if any(middleConcaveIdx)
    
    % get the indices of the vertices on the right and left side of the
    % concave vertices
    rightConcaveIdx = leftIdx(middleConcaveIdx);
    leftConcaveIdx = rightIdx(middleConcaveIdx);
    
    % get the cortical multipliers for the left side focal adhesions
    leftMultipliers = multipliersTemp(leftConcaveIdx);
    
    % remove the indices with concave vertex as their neighbor
    leftConvexIdx(leftConcaveIdx) = [];
    
    % get the right and left side lengths for the concave vertices
    concaveRightLengths = cells.rightLengths(middleConcaveIdx);
    concaveLeftLengths = cells.leftLengths(middleConcaveIdx);
    
    % calculate the lengths of the focal adhesion links that travel around
    % the convave vertex
    totalConcaveDistance = concaveLeftLengths + concaveRightLengths;

    % get the concave vertex coordinates
    concavesX = cells.verticesX(middleConcaveIdx);
    concavesY = cells.verticesY(middleConcaveIdx);
    
    % calculate the force magnitudes (including the unit vector
    % scaling) (leftConcaveIdx is deliberate, since the has the same
    % multiplier as the that on the other side of the concave vertex due to
    % the indexing: the first element of both rightSideConcaveIdx and
    % leftSideConcaveIdx both correspond to the same middleConcaveIdx
    % vertex -> they both share the same tension multiplier)
    forceMagnitudes = tempMagnitude.*leftMultipliers./concaveLeftLengths.*totalConcaveDistance;
    
    % calculate the cortex forces for vertices with right side concave
    % neighbors
    rightConcaveForcesX(rightConcaveIdx) = forceMagnitudes.*(concavesX - cells.verticesX(rightConcaveIdx));
    rightConcaveForcesY(rightConcaveIdx) = forceMagnitudes.*(concavesY - cells.verticesY(rightConcaveIdx));
    
    % calculate the force magnitudes (including the unit vector
    % scaling)
    forceMagnitudes = tempMagnitude.*leftMultipliers./concaveRightLengths.*totalConcaveDistance;
    
    % calculate the cortex forces for vertices with left side concave
    % neighbors
    leftConcaveForcesX(leftConcaveIdx) = forceMagnitudes.*(concavesX - cells.verticesX(leftConcaveIdx));
    leftConcaveForcesY(leftConcaveIdx) = forceMagnitudes.*(concavesY - cells.verticesY(leftConcaveIdx));
    
    % calculate the force pushing concave vertices outwards (the sum of
    % the negative in the neighboring vertices
    middleConcaveForcesX(middleConcaveIdx) = -rightConcaveForcesX(rightConcaveIdx) - leftConcaveForcesX(leftConcaveIdx);
    middleConcaveForcesY(middleConcaveIdx) = -rightConcaveForcesY(rightConcaveIdx) - leftConcaveForcesY(leftConcaveIdx);
end

% calcualte the force magnitudes
forceMagnitudes = tempMagnitude.*multipliersTemp(leftConvexIdx);

% calculate the cortical forces for the right side without concave
% neighbors
leftConvexForcesX(leftConvexIdx) = forceMagnitudes.*(second2leftVerticesX(leftConvexIdx) - cells.verticesX(leftConvexIdx));
leftConvexForcesY(leftConvexIdx) = forceMagnitudes.*(second2leftVerticesY(leftConvexIdx) - cells.verticesY(leftConvexIdx));

% calculate the left side normal forces (which mirror the rightside
% forces)
rightConvexForcesX = -leftConvexForcesX(mirrorIdx);
rightConvexForcesY = -leftConvexForcesY(mirrorIdx);

% calculate the total cortical forces
cells.forces.corticalX = rightConvexForcesX + leftConvexForcesX + rightConcaveForcesX + leftConcaveForcesX + middleConcaveForcesX;
cells.forces.corticalY = rightConvexForcesY + leftConvexForcesY + rightConcaveForcesY + leftConcaveForcesY + middleConcaveForcesY;

% if the cell is in cytokinesis, set the cortical force to zero for the
% division vertices (the cortical force would hinder the rate of the
% division significantly)
if cells.division.state == 2
    cells.forces.corticalX(cells.division.vertices) = 0;
    cells.forces.corticalY(cells.division.vertices) = 0;
end

end
