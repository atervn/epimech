function edgeCell = create_edge_cell(d)

dist = d.spar.membraneLength;
MiddlePointsInc = d.simset.frame.cornersX(1):dist:d.simset.frame.cornersX(2);
MiddlePointsDec = d.simset.frame.cornersX(2):-dist:d.simset.frame.cornersX(1);
MiddlePointsConstantPlus = d.simset.frame.cornersX(2).*ones(1,length(MiddlePointsDec));
MiddlePointsConstantMinus = -MiddlePointsConstantPlus;
edgeX = [MiddlePointsInc MiddlePointsConstantPlus MiddlePointsDec MiddlePointsConstantMinus]';
edgeY = [MiddlePointsConstantMinus MiddlePointsInc MiddlePointsConstantPlus MiddlePointsDec]';

edgeCell = initialize_cells_struct;

edgeCell.verticesX = edgeX;
edgeCell.verticesY = edgeY;

edgeCell.nVertices = length(edgeCell.verticesX);

% vector that holds the state of the vertices (bound, free, etc.)
edgeCell.vertexStates = zeros(size(edgeCell.verticesX));

edgeCell.division.state = 0;

edgeCell.cellState = 0;

edgeCell.division.vertices = [0;0];

% variable to save the cell division time
edgeCell.division.time = 0;

% matrix to save the information about the cell junctions (which vertex is
% connected to which vertex in which cell)
edgeCell.junctions.cells = zeros(length(edgeCell.verticesX),2);
edgeCell.junctions.vertices = zeros(length(edgeCell.verticesX),2);

% vector to save the distances between boundary vertices
edgeCell = get_boundary_vectors(edgeCell);
edgeCell = get_boundary_lengths(edgeCell);

% variable to save the cell area
edgeCell = get_cell_areas(edgeCell);
edgeCell = get_cell_perimeters(edgeCell);

edgeCell.normArea = edgeCell.area;
edgeCell.normPerimeter = edgeCell.perimeter;

edgeCell.division.targetArea = 0;
edgeCell = get_convexities(edgeCell);
edgeCell = get_vertex_angles(edgeCell);

edgeCell.junctions.linkedIdx1 = zeros(0,1);
edgeCell.junctions.pairCells1 = zeros(0,1);
edgeCell.junctions.pairVertices1 = zeros(0,1);
edgeCell.junctions.linked2CellNumbers1 = zeros(0,1);
edgeCell.junctions.linkedIdx2 = zeros(0,1);
edgeCell.junctions.pairCells2 = zeros(0,1);
edgeCell.junctions.pairVertices2 = zeros(0,1);
edgeCell.junctions.linked2CellNumbers2 = zeros(0,1);

edgeCell = set_empty_cell_properties(edgeCell);
edgeCell.division.newAreas = zeros(2,1);
edgeCell.lineage = 1;

edgeCell.corticalTension = 1;
end