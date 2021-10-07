function cells = get_cell_pointlike_forces(cells,simset,spar,k)
% GET_CELL_POINTLIKE_FORCES Calculate the pointlike micromanipulation
% forces
%   The function calculates the pointlike forces for the manipulated cell.
%   The force is defined to be at full strength for the point closest to
%   the movement direction, and linearly decreases opposite to the movenent
%   direction until being zero at the furthest vertex.
%   INPUTS:
%       cells: single cell data structure
%       simset: simulation settings structure
%       spar: scaled parameter structure
%       k: current cell index
%   OUTPUT:
%       cells: single cell data structure
%   by Aapo Tervonen, 2021

% initialize the force vectors for all cells
cells.forces.pointlikeX = zeros(cells.nVertices,1);
cells.forces.pointlikeY = cells.forces.pointlikeX;

% if the current cell is the manipulated cell
if k == simset.pointlike.cell
    
    % get the multipliers based on their y-component (movement is towards
    % positive y-coordinate) based on linear intrapolation between 1 and 0
    multipliers = (cells.verticesY - min(cells.verticesY))./(max(cells.verticesY) - min(cells.verticesY));
    
    % calculate the pointlike forces between the "virtual" coordinates that
    % are moved and the current cell coordinates
    cells.forces.pointlikeY = multipliers.*spar.fPointlike.*(simset.pointlike.vertexY - cells.verticesY);
    cells.forces.pointlikeX = spar.fPointlike.*(simset.pointlike.vertexX - cells.verticesX);
end

end