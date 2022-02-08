function cells = set_empty_cell_properties(cells)
% SET_EMPTY_CELL_PROPERTIES Initialize various structure for the cell
%   The function initializes the structures used to store focal adhesion
%   data, contact data, force values, vertex increments, and perimeter
%   increments
%   INPUT:
%       cells: cell data structure
%   OUTPUT:
%       cells: cell data structure
%   by Aapo Tervonen, 2021

% focal adhesion structure
cells.substrate.points = [];
cells.substrate.pointsLin = [];
cells.substrate.matrixIdx = [];
cells.substrate.linkCols = [];
cells.substrate.connected = logical([]);
cells.substrate.weights = [];
cells.substrate.weightsLin = [];
cells.substrate.fFocalAdhesions = [];

% contact structure
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

% force structure
cells.forces.divisionX = zeros(cells.nVertices,1);
cells.forces.divisionY = zeros(cells.nVertices,1);
cells.forces.corticalX = zeros(cells.nVertices,1);
cells.forces.corticalY = zeros(cells.nVertices,1);
cells.forces.junctionX = zeros(cells.nVertices,1);
cells.forces.junctionY = zeros(cells.nVertices,1);
cells.forces.areaX = zeros(cells.nVertices,1);
cells.forces.areaY = zeros(cells.nVertices,1);
cells.forces.membraneX = zeros(cells.nVertices,1);
cells.forces.membraneY = zeros(cells.nVertices,1);
cells.forces.substrateX = zeros(cells.nVertices,1);
cells.forces.substrateY = zeros(cells.nVertices,1);
cells.forces.pointlikeX = zeros(cells.nVertices,1);
cells.forces.pointlikeY = zeros(cells.nVertices,1);
cells.forces.contactX = zeros(cells.nVertices,1);
cells.forces.contactY = zeros(cells.nVertices,1);
cells.forces.dampingX = zeros(cells.nVertices,1);
cells.forces.dampingY = zeros(cells.nVertices,1);
cells.forces.totalX = zeros(cells.nVertices,1);
cells.forces.totalY = zeros(cells.nVertices,1);

% movement increment structure
cells.increments.k1X = [];
cells.increments.k1Y = [];
cells.increments.k2X = [];
cells.increments.k2Y = [];
cells.increments.k3X = [];
cells.increments.k3Y = [];
cells.increments.k4X = [];
cells.increments.k4Y = [];

% perimeter increment structure
cells.perimeterIncrements.k1 = [];
cells.perimeterIncrements.k2 = [];
cells.perimeterIncrements.k3 = [];
cells.perimeterIncrements.k4 = [];

end