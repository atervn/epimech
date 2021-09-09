function cells = initialize_cells_struct

cells.verticesX = [];
cells.verticesY = [];
cells.nVertices = [];
cells.vertexStates = [];

cells.division.state = [];
cells.cellState = [];
cells.division.vertices = [];
cells.division.time = [];

cells.junctions.cells = [];
cells.junctions.vertices = [];
cells.junctions.linkedIdx1 = [];
cells.junctions.linkedIdx2 = [];
cells.junctions.pairCells1 = [];
cells.junctions.pairCells2 = [];
cells.junctions.pairVertices1 = [];
cells.junctions.pairVertices2 = [];
cells.junctions.linked2CellNumbers1 = [];
cells.junctions.linked2CellNumbers2 = [];

cells.leftLengths = [];
cells.rightLengths = [];
cells.area = [];
cells.perimeter = [];
cells.normArea = [];
cells.normPerimeter = [];
cells.division.targetArea = [];

cells.leftVectorsX = [];
cells.leftVectorsY = [];
cells.rightVectorsX = [];
cells.rightVectorsY = [];

cells.outsideAngles = [];

% substrate stuff
cells.substrate.points = [];
cells.substrate.pointsLin = [];
cells.substrate.matrixIdx = [];
cells.substrate.linkCols = [];
cells.substrate.connected = [];
cells.substrate.weights = [];
cells.substrate.weightsLin = [];
cells.substrate.fFocalAdhesions = [];

% possible junction stuff
cells.possibleJunctionVertices = [];
cells.possibleJunctions.pairCellIDs = [];
cells.possibleJunctions.pairVertexIDs = [];
cells.possibleJunctions.distances = [];
cells.possibleJunctions.pairVerticesX = [];
cells.possibleJunctions.pairVerticesY = [];
    
cells.contacts.present = [];
cells.contacts.cell1.next.vertices = [];
cells.contacts.cell1.next.present = [];
cells.contacts.cell1.next.pairCellIDs = [];
cells.contacts.cell1.next.pairVertexIDs = [];
cells.contacts.cell1.next.pairCells = [];
cells.contacts.cell1.prev.vertices = [];
cells.contacts.cell1.prev.present = [];
cells.contacts.cell1.prev.pairCellIDs = [];
cells.contacts.cell1.prev.pairVertexIDs = [];
cells.contacts.cell1.prev.pairCells = [];
cells.contacts.cell1.vertex.vertices = [];
cells.contacts.cell1.vertex.present = [];
cells.contacts.cell1.vertex.pairCellIDs = [];
cells.contacts.cell1.vertex.pairVertexIDs = [];
cells.contacts.cell1.vertex.pairCells = [];
cells.contacts.cell2.next.vertices = [];
cells.contacts.cell2.next.present = [];
cells.contacts.cell2.next.pairCellIDs = [];
cells.contacts.cell2.next.pairVertexIDs = [];
cells.contacts.cell2.next.pairCells = [];
cells.contacts.cell2.prev.vertices = [];
cells.contacts.cell2.prev.present = [];
cells.contacts.cell2.prev.pairCellIDs = [];
cells.contacts.cell2.prev.pairVertexIDs = [];
cells.contacts.cell2.prev.pairCells = [];
cells.contacts.cell2.vertex.vertices = [];
cells.contacts.cell2.vertex.present = [];
cells.contacts.cell2.vertex.pairCellIDs = [];
cells.contacts.cell2.vertex.pairVertexIDs = [];
cells.contacts.cell2.vertex.pairCells = [];

cells.forces.divisionX = [];
cells.forces.divisionY = [];
cells.forces.corticalX = [];
cells.forces.corticalY = [];
cells.forces.junctionX = [];
cells.forces.junctionY = [];
cells.forces.areaX = [];
cells.forces.areaY = [];
cells.forces.membraneX = [];
cells.forces.membraneY = [];
cells.forces.substrateX = [];
cells.forces.substrateY = [];
cells.forces.pointlikeX = [];
cells.forces.pointlikeY = [];
cells.forces.contactX = [];
cells.forces.contactY = [];
cells.forces.totalX = [];
cells.forces.totalY = [];

cells.increments.k1X = [];
cells.increments.k1Y = [];
cells.increments.k2X = [];
cells.increments.k2Y = [];
cells.increments.k3X = [];
cells.increments.k3Y = [];
cells.increments.k4X = [];
cells.increments.k4Y = [];

cells.movementX = [];
cells.movementY = [];

cells.previousVerticesX = [];
cells.previousVerticesY = [];
cells.division.newAreas = [];
cells.lineage = [];

cells.vertexCorticalTensions =  [];
cells.corticalTension = [];

cells.corticalData.perimeter.k1 = [];
cells.corticalData.perimeter.k2 = [];
cells.corticalData.perimeter.k3 = [];
cells.corticalData.perimeter.k4 = [];
cells.corticalData.tension.k1 = [];
cells.corticalData.tension.k2 = [];
cells.corticalData.tension.k3 = [];
cells.corticalData.tension.k4 = [];

cells.division.distanceSq = [];

end