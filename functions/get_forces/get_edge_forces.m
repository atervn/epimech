function cells = get_edge_forces(cells,spar)
% GET_FOCAL_ADHESION_FORCES Calculate forces describing the continuity of
% the epithelium
%   The function calculates the forces that describe the effect that the
%   epithelium continues outside the simulated area. The force tries to
%   bring the vertices back to their original position.
%   INPUTS:
%       cells: single cell data structure
%       spar: scaled parameters structure
%   OUTPUT:
%       cells: single cell data structure
%   by Aapo Tervonen, 2021

% initialize the force vectors
cells.forces.edgeX = zeros(cells.nVertices,1);
cells.forces.edgeY = zeros(cells.nVertices,1);

% if the cell is an edge cell
if cells.cellState == 0
    
    % calculate the edge force
    cells.forces.edgeX(cells.edgeVertices) = spar.fEdgeCell.*(cells.edgeInitialX - cells.verticesX(cells.edgeVertices));
    cells.forces.edgeY(cells.edgeVertices) = spar.fEdgeCell.*(cells.edgeInitialY - cells.verticesY(cells.edgeVertices)); 
end
        
end