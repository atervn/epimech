function cells = save_forces(cells, tempCells, simulationType)
% SAVE_FORCES Saves the cell forces
%   The function saves the cell forces for plotting, exporting, etc.
%   INPUTS:
%       cells: cell data structure
%       tempCells: temporary cell data structure
%       simulationType: type of the current simulation
%   OUTPUT:
%       cells: single cell data structure
%   by Aapo Tervonen, 2021

% save the forces used in all simulations
cells.forces.contactX = tempCells.forces.contactX;
cells.forces.contactY = tempCells.forces.contactY;
cells.forces.corticalX = tempCells.forces.corticalX;
cells.forces.corticalY = tempCells.forces.corticalY;
cells.forces.junctionX = tempCells.forces.junctionX;
cells.forces.junctionY = tempCells.forces.junctionY;
cells.forces.areaX = tempCells.forces.areaX;
cells.forces.areaY = tempCells.forces.areaY;
cells.forces.membraneX = tempCells.forces.membraneX;
cells.forces.membraneY = tempCells.forces.membraneY;
cells.forces.totalX = tempCells.forces.totalX;
cells.forces.totalY = tempCells.forces.totalY;

% save the growth specific forces
if simulationType == 1
    cells.forces.divisionX = tempCells.forces.divisionX;
    cells.forces.divisionY = tempCells.forces.divisionY;
    
% save the pointlike specific forces
elseif simulationType == 2
    cells.forces.substrateX = tempCells.forces.substrateX;
    cells.forces.substrateY = tempCells.forces.substrateY;
    cells.forces.pointlikeX = tempCells.forces.pointlikeX;
    cells.forces.pointlikeY = tempCells.forces.pointlikeY;
    
% save the stretching specific forces
elseif simulationType == 3
    cells.forces.substrateX = tempCells.forces.substrateX;
    cells.forces.substrateY = tempCells.forces.substrateY;
  
% save the optogenetic specific forces
elseif simulationType == 5
    cells.forces.substrateX = tempCells.forces.substrateX;
    cells.forces.substrateY = tempCells.forces.substrateY;
end

end