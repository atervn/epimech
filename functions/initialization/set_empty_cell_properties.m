function cells = set_empty_cell_properties(cells)

empty0by1 = zeros(0,1);
empty0by3 = zeros(0,3);
emptyLogical = logical(zeros(0,1)); %#ok<LOGL>

% possible junction stuff
cells.possibleJunctionVertices = empty0by1;
cells.possibleJunctions.pairCellIDs = empty0by1;
cells.possibleJunctions.pairVertexIDs = empty0by1;
cells.possibleJunctions.distances = empty0by1;
cells.possibleJunctions.pairVerticesX = empty0by1;
cells.possibleJunctions.pairVerticesY = empty0by1;

% substrate stuff
cells.substrate.points = empty0by3;
cells.substrate.pointsLin = empty0by1;
cells.substrate.matrixIdx = empty0by1;
cells.substrate.linkCols = empty0by3;
cells.substrate.connected = logical(empty0by1);
cells.substrate.weights = empty0by3;
cells.substrate.weightsLin = empty0by1;
cells.substrate.fFocalAdhesions = empty0by1;

cells.contacts.present = emptyLogical;
cells.contacts.cell1.next.vertices = empty0by1;
cells.contacts.cell1.next.present = emptyLogical;
cells.contacts.cell1.next.pairCellIDs = empty0by1;
cells.contacts.cell1.next.pairVertexIDs = empty0by1;
cells.contacts.cell1.next.pairCells = empty0by1;
cells.contacts.cell1.prev.vertices = empty0by1;
cells.contacts.cell1.prev.present = emptyLogical;
cells.contacts.cell1.prev.pairCellIDs = empty0by1;
cells.contacts.cell1.prev.pairVertexIDs = empty0by1;
cells.contacts.cell1.prev.pairCells = empty0by1;
cells.contacts.cell1.vertex.vertices = empty0by1;
cells.contacts.cell1.vertex.present = emptyLogical;
cells.contacts.cell1.vertex.pairCellIDs = empty0by1;
cells.contacts.cell1.vertex.pairVertexIDs = empty0by1;
cells.contacts.cell1.vertex.pairCells = empty0by1;
cells.contacts.cell2.next.vertices = empty0by1;
cells.contacts.cell2.next.present = emptyLogical;
cells.contacts.cell2.next.pairCellIDs = empty0by1;
cells.contacts.cell2.next.pairVertexIDs = empty0by1;
cells.contacts.cell2.next.pairCells = empty0by1;
cells.contacts.cell2.prev.vertices = empty0by1;
cells.contacts.cell2.prev.present = emptyLogical;
cells.contacts.cell2.prev.pairCellIDs = empty0by1;
cells.contacts.cell2.prev.pairVertexIDs = empty0by1;
cells.contacts.cell2.prev.pairCells = empty0by1;
cells.contacts.cell2.vertex.vertices = empty0by1;
cells.contacts.cell2.vertex.present = emptyLogical;
cells.contacts.cell2.vertex.pairCellIDs = empty0by1;
cells.contacts.cell2.vertex.pairVertexIDs = empty0by1;
cells.contacts.cell2.vertex.pairCells = empty0by1;

cells.forces.divisionX = empty0by1;
cells.forces.divisionY = empty0by1;
cells.forces.corticalX = empty0by1;
cells.forces.corticalY = empty0by1;
cells.forces.junctionX = empty0by1;
cells.forces.junctionY = empty0by1;
cells.forces.areaX = empty0by1;
cells.forces.areaY = empty0by1;
cells.forces.membraneX = empty0by1;
cells.forces.membraneY = empty0by1;
cells.forces.substrateX = empty0by1;
cells.forces.substrateY = empty0by1;
cells.forces.pointlikeX = empty0by1;
cells.forces.pointlikeY = empty0by1;
cells.forces.contactX = empty0by1;
cells.forces.contactY = empty0by1;
cells.forces.totalX = empty0by1;
cells.forces.totalY = empty0by1;

cells.increments.k1X = empty0by1;
cells.increments.k1Y = empty0by1;
cells.increments.k2X = empty0by1;
cells.increments.k2Y = empty0by1;
cells.increments.k3X = empty0by1;
cells.increments.k3Y = empty0by1;
cells.increments.k4X = empty0by1;
cells.increments.k4Y = empty0by1;

cells.movementX = empty0by1;
cells.movementY = empty0by1;

cells.previousVerticesX = empty0by1;
cells.previousVerticesY = empty0by1;

cells.corticalData.perimeter.k1 = empty0by1;
cells.corticalData.perimeter.k2 = empty0by1;
cells.corticalData.perimeter.k3 = empty0by1;
cells.corticalData.perimeter.k4 = empty0by1;
cells.corticalData.tension.k1 = empty0by1;
cells.corticalData.tension.k2 = empty0by1;
cells.corticalData.tension.k3 = empty0by1;
cells.corticalData.tension.k4 = empty0by1;

cells.division.distanceSq = 0;