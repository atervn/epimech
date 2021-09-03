function cells = get_edge_forces(cells,spar)

cells.forces.edgeX = zeros(cells.nVertices,1);
cells.forces.edgeY = zeros(cells.nVertices,1);

if cells.cellState == 0
    cells.forces.edgeX(cells.edgeVertices) = spar.fEdgeCell.*(cells.edgeInitialX - cells.verticesX(cells.edgeVertices));
    cells.forces.edgeY(cells.edgeVertices) = spar.fEdgeCell.*(cells.edgeInitialY - cells.verticesY(cells.edgeVertices)); 
end
        
end