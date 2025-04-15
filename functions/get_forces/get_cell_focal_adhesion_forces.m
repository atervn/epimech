function cells = get_cell_focal_adhesion_forces(cells,sub)
% GET_FOCAL_ADHESION_FORCES Calculate forces between the cells and the
% substrate
%   The function calculates the forces in the focal adhesions between the
%   cell vertices and the substrate points. Each vertex is connected to
%   their original position in relation to the substrate. Therefore, the
%   connection position in the substrate is within a triangle formed by the
%   substrate points. The coordinates of this position are defined based on
%   the three closest substrate points by using the baryocentric coordinate
%   system. The vertices aim to return to their original position in
%   relation to the substrate.
%   INPUTS:
%       cells: single cell data structure
%       sub: substrate data structure
%   OUTPUT:
%       cells: single cell data structure
%   by Aapo Tervonen, 2021

% initialize the force vectors
cells.forces.substrateX = zeros(cells.nVertices,1);
cells.forces.substrateY = cells.forces.substrateX;

% if there are vertices with focal adhesions
if any(cells.substrate.connected)
    
    % get the coordinates for the closest substrate points for each vertex
    substrateX = sub.pointsX(cells.substrate.pointsLin);
    substrateY = sub.pointsY(cells.substrate.pointsLin);
    
    % calculate the adhesion points based on the baryocentric weights
    adhesionPointsX = sum(reshape(substrateX.*cells.substrate.weightsLin,[],3),2);
    adhesionPointsY = sum(reshape(substrateY.*cells.substrate.weightsLin,[],3),2);
    
    % if stiffness is constant, cells.substrate.fFocalAdhesions is scalar
    % size (1,1), if not, then it has the same length as the number of FAs
    try
    cells.forces.substrateX(cells.substrate.connected) = cells.substrate.fFocalAdhesions.*(adhesionPointsX - cells.verticesX(cells.substrate.connected));
    catch 
        a = 1;
    end
    cells.forces.substrateY(cells.substrate.connected) = cells.substrate.fFocalAdhesions.*(adhesionPointsY - cells.verticesY(cells.substrate.connected));
end

end