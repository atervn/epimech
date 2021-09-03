function cells = save_forces(cells, tempCells, simulationType)



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


if simulationType == 1
    cells.forces.divisionX = tempCells.forces.divisionX;
    cells.forces.divisionY = tempCells.forces.divisionY;
elseif simulationType == 2
    cells.forces.substrateX = tempCells.forces.substrateX;
    cells.forces.substrateY = tempCells.forces.substrateY;
    cells.forces.pointlikeX = tempCells.forces.pointlikeX;
    cells.forces.pointlikeY = tempCells.forces.pointlikeY;
elseif simulationType == 3
    cells.forces.substrateX = tempCells.forces.substrateX;
    cells.forces.substrateY = tempCells.forces.substrateY;
elseif simulationType == 5
    cells.forces.substrateX = tempCells.forces.substrateX;
    cells.forces.substrateY = tempCells.forces.substrateY;
end

end
