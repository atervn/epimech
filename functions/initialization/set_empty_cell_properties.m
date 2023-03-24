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