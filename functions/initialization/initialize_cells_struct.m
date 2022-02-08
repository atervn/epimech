function cells = initialize_cells_struct
% INITIALIZE_CELLS_STRUCTU Initialize the cell data structure
%   The function defines the cell data structrure and initiates everything
%   with empty vectors.
%   OUTPUT:
%       cells: cell data structure
%   by Aapo Tervonen, 2021

% cell coordinates and velocities
cells.verticesX = [];
cells.verticesY = [];
cells.velocitiesX = [];
cells.velocitiesY = [];

% number of vertices
cells.nVertices = [];

% cell and vertex states
cells.cellState = [];
cells.vertexStates = [];

% division related information
cells.division.state = [];
cells.division.vertices = [];
cells.division.time = [];
cells.division.targetArea = [];
cells.division.newAreas = [];
cells.division.distanceSq = [];

% junction relation information
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
cells.junctions.possible = [];

% vertex distance, area, perimeter and normal area and perimeter
cells.leftLengths = [];
cells.rightLengths = [];
cells.area = [];
cells.perimeter = [];
cells.normArea = [];
cells.normPerimeter = [];

% the vectors to each neighbors
cells.leftVectorsX = [];
cells.leftVectorsY = [];
cells.rightVectorsX = [];
cells.rightVectorsY = [];

% outside boundary angles
cells.outsideAngles = [];

% focal adhesion related information
cells.substrate.points = [];
cells.substrate.pointsLin = [];
cells.substrate.matrixIdx = [];
cells.substrate.linkCols = [];
cells.substrate.connected = [];
cells.substrate.weights = [];
cells.substrate.weightsLin = [];
cells.substrate.fFocalAdhesions = [];
    
% contact related information
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

% division contant related information
cells.contacts.division.next.vertices = [];
cells.contacts.division.next.present = [];
cells.contacts.division.next.pairIDs = [];
cells.contacts.division.prev.vertices = [];
cells.contacts.division.prev.present = [];
cells.contacts.division.prev.pairIDs = [];
cells.contacts.division.vertex.vertices = [];
cells.contacts.division.vertex.present = [];
cells.contacts.division.vertex.pairIDs = [];

% vertex forces
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

% vertex increments
cells.increments.k1X = [];
cells.increments.k1Y = [];
cells.increments.k2X = [];
cells.increments.k2Y = [];
cells.increments.k3X = [];
cells.increments.k3Y = [];
cells.increments.k4X = [];
cells.increments.k4Y = [];

% vertex movement
cells.movementX = [];
cells.movementY = [];

% previous vertex positions (needed for plotting during the simulation)
cells.previousVerticesX = [];
cells.previousVerticesY = [];
cells.previousVelocitiesX = [];
cells.previousVelocitiesY = [];

% cell lineage
cells.lineage = [];

% cortex related information
cells.cortex.vertexMultipliers =  [];
cells.cortex.fCortex = [];
cells.cortex.perimeterConstant = [];

% perimeter remodeling increments
cells.perimeterIncrements.k1 = [];
cells.perimeterIncrements.k2 = [];
cells.perimeterIncrements.k3 = [];
cells.perimeterIncrements.k4 = [];

end