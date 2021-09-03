function cells = get_cell_area_forces(cells,spar)
% CALCULATE_AREA_FORCE Calculates forces originating from the cell area
%   The strength of the area force is dependend on the difference between
%   the current area and the normal cell area. The direction is normal to
%   the cell surface. The method is based on the vertex method, for more
%   information, see DOI: 10.1016/j.pbiomolbio.2013.09.003.
%   INPUTS:
%       cells: contains the cell data
%       spar: scaled parameters
%   OUTPUT:
%       cells: cell data including the area forces for each vertex


% calculate the area gradient, basically describing the force vector
% direction
meanVectorsX = 0.5.*(cells.leftVectorsX + cells.rightVectorsX);
meanVectorsY = 0.5.*(cells.leftVectorsY + cells.rightVectorsY);

% Calculate the area force magnitude

% dividing cell (multiplier to take into account the higher target
% area)
if cells.division.state == 1
    
    forceMagnitude = spar.cellGrowthForceConstant*spar.fArea*(cells.area - cells.normArea)/cells.normArea;
    
% quiescent cell
else
    forceMagnitude = spar.fArea*(cells.area - cells.normArea)/cells.normArea;
end

% assign the same force magnitude for all of the vertices
forceMagnitudes = repmat(forceMagnitude,cells.nVertices,1);

% calculate the area forces
cells.forces.areaX = forceMagnitudes.*-meanVectorsY;
cells.forces.areaY = forceMagnitudes.*meanVectorsX;

end