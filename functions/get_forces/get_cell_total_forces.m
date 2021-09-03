function cells = get_cell_total_forces(cells,simulationType)

cells.forces.totalX = cells.forces.contactX + cells.forces.corticalX + cells.forces.areaX + cells.forces.junctionX + cells.forces.membraneX;% + m.*randn(1,1);
cells.forces.totalY = cells.forces.contactY + cells.forces.corticalY + cells.forces.areaY + cells.forces.junctionY + cells.forces.membraneY;% + m.*randn(1,1);

if simulationType == 1
    cells.forces.totalX = cells.forces.totalX + cells.forces.divisionX;
    cells.forces.totalY = cells.forces.totalY + cells.forces.divisionY;
elseif simulationType == 2
    cells.forces.totalX = cells.forces.totalX + cells.forces.substrateX;
    cells.forces.totalY = cells.forces.totalY + cells.forces.substrateY;
    cells.forces.totalX = cells.forces.totalX + cells.forces.pointlikeX;
    cells.forces.totalY = cells.forces.totalY + cells.forces.pointlikeY;
    cells.forces.totalX = cells.forces.totalX + cells.forces.edgeX;
    cells.forces.totalY = cells.forces.totalY + cells.forces.edgeY;
elseif simulationType == 3
    cells.forces.totalX = cells.forces.totalX + cells.forces.substrateX;
    cells.forces.totalY = cells.forces.totalY + cells.forces.substrateY;
    cells.forces.totalX = cells.forces.totalX + cells.forces.edgeX;
    cells.forces.totalY = cells.forces.totalY + cells.forces.edgeY;
elseif simulationType == 5
    cells.forces.totalX = cells.forces.totalX + cells.forces.substrateX;
    cells.forces.totalY = cells.forces.totalY + cells.forces.substrateY;
    cells.forces.totalX = cells.forces.totalX + cells.forces.edgeX;
    cells.forces.totalY = cells.forces.totalY + cells.forces.edgeY;
end

end