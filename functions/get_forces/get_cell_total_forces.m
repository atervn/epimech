function cells = get_cell_total_forces(cells,simulationType)
% GET_FOCAL_TOTAL_FORCES Calculate the total forces for the cell vertices
%   The function calculates the total force for the cell vertices by
%   summing the appropriate forces depending on the simulation.
%   INPUTS:
%       cells: single cell data structure
%       simulationType: type of the current simulation
%   OUTPUT:
%       cells: single cell data structure
%   by Aapo Tervonen, 2021

% sum the main forces used for all simulations
cells.forces.totalX = cells.forces.contactX + cells.forces.corticalX + cells.forces.areaX + cells.forces.junctionX + cells.forces.membraneX;
cells.forces.totalY = cells.forces.contactY + cells.forces.corticalY + cells.forces.areaY + cells.forces.junctionY + cells.forces.membraneY;

% growth simulation
if simulationType == 1
    
    % add the division forces
    cells.forces.totalX = cells.forces.totalX + cells.forces.divisionX;
    cells.forces.totalY = cells.forces.totalY + cells.forces.divisionY;
    
% pointlike simulation
elseif simulationType == 2
    
    % add the pointlike specific forces
    cells.forces.totalX = cells.forces.totalX + cells.forces.substrateX + cells.forces.pointlikeX + cells.forces.edgeX;
    cells.forces.totalY = cells.forces.totalY + cells.forces.substrateY + cells.forces.pointlikeY + cells.forces.edgeY;
    
% lateral stretching simulation
elseif simulationType == 3
    
    % add the lateral stretching specific forces
    cells.forces.totalX = cells.forces.totalX + cells.forces.substrateX + cells.forces.edgeX;
    cells.forces.totalY = cells.forces.totalY + cells.forces.substrateY + cells.forces.edgeY;
    
% optogenetic simulation
elseif simulationType == 5
    
    % add the optogenetic specific forces
    cells.forces.totalX = cells.forces.totalX + cells.forces.substrateX + cells.forces.edgeX;
    cells.forces.totalY = cells.forces.totalY + cells.forces.substrateY + cells.forces.edgeY;
end

end