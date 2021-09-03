function cells = get_cell_membrane_forces(cells,spar)

    leftVerticesX = circshift(cells.verticesX,-1,1);
    leftVerticesY = circshift(cells.verticesY,-1,1);

    reciprocalTempLengths = 1./cells.leftLengths;

    forceMagnitudes = spar.fMembrane*(cells.leftLengths - spar.membraneLength.^2.*reciprocalTempLengths + (0.6*spar.membraneLength./(3.5*spar.membraneLength - cells.leftLengths)).^6).*reciprocalTempLengths;
    cells.forces.membraneX = forceMagnitudes.*(leftVerticesX - cells.verticesX);
    cells.forces.membraneY = forceMagnitudes.*(leftVerticesY - cells.verticesY);
    
    cells.forces.membraneX = cells.forces.membraneX - circshift(cells.forces.membraneX,1,1);
    cells.forces.membraneY = cells.forces.membraneY - circshift(cells.forces.membraneY,1,1);
    
end