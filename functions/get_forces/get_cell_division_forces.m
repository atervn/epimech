function cells = get_cell_division_forces(cells,spar)
% GET_DIVISION_FORCES Calculate forces pulling division vertices
%   The function calculates the forces that pull the division points
%   towards each other during cytokinesis
%   INPUTS:
%       cells: single cell data structure
%       spar: scaled parameter structure
%   OUTPUT:
%       cells: single cell data structure
%   by Aapo Tervonen, 2021

% initialize the division force vectors
cells.forces.divisionX = zeros(cells.nVertices,1); cells.forces.divisionY = cells.forces.divisionX;

% check that the cell is dividing
if cells.division.state == 2
    
    % find the distance between the division points
    distance = sqrt((cells.verticesX(cells.division.vertices(1)) - cells.verticesX(cells.division.vertices(2)))^2 + (cells.verticesY(cells.division.vertices(1)) - cells.verticesY(cells.division.vertices(2)))^2);
    
    % calculate the force magnitude
    forceMagnitude = spar.fDivision./distance;
    
    % calculate division forces for the division vertices
    cells.forces.divisionX(cells.division.vertices(1)) = forceMagnitude.*(cells.verticesX(cells.division.vertices(2),:) - cells.verticesX(cells.division.vertices(1),:));
    cells.forces.divisionY(cells.division.vertices(1)) = forceMagnitude.*(cells.verticesY(cells.division.vertices(2),:) - cells.verticesY(cells.division.vertices(1),:));
    
    cells.forces.divisionX(cells.division.vertices(2)) = forceMagnitude.*(cells.verticesX(cells.division.vertices(1),:) - cells.verticesX(cells.division.vertices(2),:));
    cells.forces.divisionY(cells.division.vertices(2)) = forceMagnitude.*(cells.verticesY(cells.division.vertices(1),:) - cells.verticesY(cells.division.vertices(2),:));
end

end
