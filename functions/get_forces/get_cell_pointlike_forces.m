function cells = get_cell_pointlike_forces(cells,simset,spar,k)


cells.forces.pointlikeX = zeros(cells.nVertices,1);
cells.forces.pointlikeY = cells.forces.pointlikeX;


if k == simset.pointlike.cell
    
    multipliers = (cells.verticesY - min(cells.verticesY))./(max(cells.verticesY) - min(cells.verticesY));
    
    cells.forces.pointlikeY = multipliers.*spar.fPointlike.*(simset.pointlike.vertexY - cells.verticesY);
    cells.forces.pointlikeX = spar.fPointlike.*(simset.pointlike.vertexX - cells.verticesX);
    
end

end