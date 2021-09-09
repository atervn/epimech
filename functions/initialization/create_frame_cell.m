function frameCell = create_frame_cell(d)

dist = d.spar.membraneLength;
MiddlePointsInc = d.simset.frame.cornersX(1):dist:d.simset.frame.cornersX(2);
MiddlePointsDec = d.simset.frame.cornersX(2):-dist:d.simset.frame.cornersX(1);
MiddlePointsConstantPlus = d.simset.frame.cornersX(2).*ones(1,length(MiddlePointsDec));
MiddlePointsConstantMinus = -MiddlePointsConstantPlus;
edgeX = [MiddlePointsInc MiddlePointsConstantPlus MiddlePointsDec MiddlePointsConstantMinus]';
edgeY = [MiddlePointsConstantMinus MiddlePointsInc MiddlePointsConstantPlus MiddlePointsDec]';

frameCell = initialize_cells_struct;

frameCell.verticesX = edgeX;
frameCell.verticesY = edgeY;

frameCell.nVertices = length(frameCell.verticesX);

% vector that holds the state of the vertices (bound, free, etc.)
frameCell.vertexStates = zeros(size(frameCell.verticesX));

frameCell.division.state = 0;

frameCell.cellState = 0;

frameCell.division.vertices = [0;0];

% variable to save the cell division time
frameCell.division.time = 0;

% matrix to save the information about the cell junctions (which vertex is
% connected to which vertex in which cell)
frameCell.junctions.cells = zeros(length(frameCell.verticesX),2);
frameCell.junctions.vertices = zeros(length(frameCell.verticesX),2);

% vector to save the distances between boundary vertices
frameCell = get_boundary_vectors(frameCell);
frameCell = get_boundary_lengths(frameCell);

% variable to save the cell area
frameCell = get_cell_areas(frameCell);
frameCell = get_cell_perimeters(frameCell);

frameCell.normArea = frameCell.area;
frameCell.normPerimeter = frameCell.perimeter;

frameCell.division.targetArea = 0;
frameCell = get_vertex_angles(frameCell);

frameCell.junctions.linkedIdx1 = zeros(0,1);
frameCell.junctions.pairCells1 = zeros(0,1);
frameCell.junctions.pairVertices1 = zeros(0,1);
frameCell.junctions.linked2CellNumbers1 = zeros(0,1);
frameCell.junctions.linkedIdx2 = zeros(0,1);
frameCell.junctions.pairCells2 = zeros(0,1);
frameCell.junctions.pairVertices2 = zeros(0,1);
frameCell.junctions.linked2CellNumbers2 = zeros(0,1);

frameCell = set_empty_cell_properties(frameCell);
frameCell.division.newAreas = zeros(2,1);
frameCell.lineage = 1;

frameCell.corticalTension = 1;
end