function cells = get_cell_focal_adhesion_forces(cells,sub)
% CALCULATE_FOCAL_ADHESION_FORCES Calculates forces between the cells and
% the substrate
%   Calculates the forces in the focal adhesions between the cell vertices
%   and the substrate points. Each vertex is connected to the 3 closest
%   substrate points and tries to maintain the original distance to each of
%   them.
%   INPUTS:
%       cells: contains the cell data
%       spar: scaled parameters
%   OUTPUT:
%       cells: cell data including the focal adhesion forces for each
%       vertex

cells.forces.substrateX = zeros(cells.nVertices,1);
cells.forces.substrateY = cells.forces.substrateX;

if any(cells.substrate.connected)
    
    % get the substrate point coordinates for the corresponding
    % interactions
    substrateX = sub.pointsX(cells.substrate.pointsLin);
    substrateY = sub.pointsY(cells.substrate.pointsLin);
    
    adhesionPointsX = sum(reshape(substrateX.*cells.substrate.weightsLin,[],3),2);
    adhesionPointsY = sum(reshape(substrateY.*cells.substrate.weightsLin,[],3),2);
    
    % if stiffness is constant, cells.substrate.fFocalAdhesions is scalar
    % size (1,1), if not, then it has the same length as the number of FAs
    cells.forces.substrateX(cells.substrate.connected) = cells.substrate.fFocalAdhesions.*(adhesionPointsX - cells.verticesX(cells.substrate.connected));
    cells.forces.substrateY(cells.substrate.connected) = cells.substrate.fFocalAdhesions.*(adhesionPointsY - cells.verticesY(cells.substrate.connected));
    
end
end