function cells = get_cell_area_forces(cells,spar)
% GET_AREA_FORCE Calculate forces originating from the cell area
%   The function calculate the cell area forces. The strength of the area
%   force is dependend on the difference between the current area and the
%   normal cell area. The direction is normal to the cell surface. The
%   method is based on the vertex method.
%   INPUTS:
%       cells: single cell data structure
%       spar: scaled parameter structure
%   OUTPUT:
%       cells: single cell data structure
%   by Aapo Tervonen, 2021

% calculate the area gradient, basically describing the force vector
% directions
meanVectorsX = 0.5.*(cells.leftVectorsX + cells.rightVectorsX);
meanVectorsY = 0.5.*(cells.leftVectorsY + cells.rightVectorsY);

% dividing cell (multiplier to take into account the higher target
% area)
% if cells.division.state == 1

    % calculate the area force magnitude
%     forceMagnitude = spar.cellGrowthForceConstant*spar.fArea*(cells.area - cells.normArea)/cells.normArea;
%     forceMagnitude = spar.fArea*(-0.1);

% quiescent cell
% else
    
    % calculate the area force magnitude
    forceMagnitude = spar.fArea*(cells.area - cells.normArea)/cells.normArea;
% end

% calculate the area forces
cells.forces.areaX = forceMagnitude.*-meanVectorsY;
cells.forces.areaY = forceMagnitude.*meanVectorsX;

end