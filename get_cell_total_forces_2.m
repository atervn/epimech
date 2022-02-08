function [totalX, totalY] = get_cell_total_forces_2(cells,simulationType)
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
totalX = cells.forces.contactX + cells.forces.corticalX + cells.forces.areaX + cells.forces.junctionX + cells.forces.membraneX + cells.forces.dampingX;
totalY = cells.forces.contactY + cells.forces.corticalY + cells.forces.areaY + cells.forces.junctionY + cells.forces.membraneY + cells.forces.dampingY;

% growth simulation
if simulationType == 1
    
    % add the division forces
    totalX = totalX + cells.forces.divisionX;
    totalY = totalY + cells.forces.divisionY;
    
% pointlike simulation
elseif simulationType == 2
    
    % add the pointlike specific forces
    totalX = totalX + cells.forces.pointlikeX + cells.forces.substrateX + cells.forces.edgeX;
    totalY = totalY + cells.forces.pointlikeY + cells.forces.substrateY + cells.forces.edgeY;
    
% lateral stretching simulation
elseif simulationType == 3
    
    % add the lateral stretching specific forces
    totalX = totalX + cells.forces.substrateX + cells.forces.edgeX;
    totalY = totalY + cells.forces.substrateY + cells.forces.edgeY;
    
% optogenetic simulation
elseif simulationType == 5
    
    % add the optogenetic specific forces
    totalX = totalX + cells.forces.substrateX + cells.forces.edgeX;
    totalY = totalY + cells.forces.substrateY + cells.forces.edgeY;
end

end