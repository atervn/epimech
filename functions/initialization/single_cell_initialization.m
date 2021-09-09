function d = single_cell_initialization(d,middlePoint)

% rounded number of boundary vertices based on the membrane resolution and radius
nBoundary = round(2*pi*d.spar.rCell/d.spar.membraneLength);

% Calculate new cell radius based on the membrane resolution and number of
% boundary vertices
d.spar.rCell = nBoundary*d.spar.membraneLength/(2*pi);

% x- and y-coordinates for the cell boundary
d.cells(end+1).verticesX = d.spar.rCell.*cos(2.*pi.*(0:1/nBoundary:1-1/nBoundary)') + middlePoint(1);
d.cells(end).verticesY = d.spar.rCell.*sin(2.*pi.*(0:1/nBoundary:1-1/nBoundary)') + middlePoint(2);

d.cells(end).nVertices = length(d.cells(end).verticesX);

% vector that holds the state of the vertices (bound, free, etc.)
d.cells(end).vertexStates = zeros(size(d.cells(end).verticesX));

if d.simset.simulationType == 1
    % variable that describes the state of the cell in the cell cycle
    d.cells(end).division.state = 0;
else
    d.cells(end).division.state = -1;
end

d.cells(end).cellState = 0;

% variable to save the vertices that are used in the cytokinesis
d.cells(end).division.vertices = [0;0];

% variable to save the cell division time
d.cells(end).division.time = 0;

% matrix to save the information about the cell junctions (which vertex is
% connected to which vertex in which cell)
d.cells(end).junctions.cells = zeros(length(d.cells(end).verticesX),2);
d.cells(end).junctions.vertices = d.cells(end).junctions.cells;

% vector to save the distances between boundary vertices
d.cells(end) = get_boundary_vectors(d.cells(end));
d.cells(end) = get_boundary_lengths(d.cells(end));

% variable to save the cell area
d.cells(end) = get_cell_areas(d.cells(end));
d.cells(end) = get_cell_perimeters(d.cells(end));

d.cells(end).normArea = d.cells(end).area;
d.cells(end).normPerimeter = d.cells(end).perimeter;

d.cells(end).division.targetArea = 0;
d.cells(end) = get_vertex_angles(d.cells(end));

d.cells(end).junctions.linkedIdx1 = zeros(0,1);
d.cells(end).junctions.linkedIdx2 = zeros(0,1);
d.cells(end).junctions.pairCells1 = zeros(0,1);
d.cells(end).junctions.pairCells2 = zeros(0,1);
d.cells(end).junctions.pairVertices1 = zeros(0,1);
d.cells(end).junctions.pairVertices2 = zeros(0,1);
d.cells(end).junctions.linked2CellNumbers1 = zeros(0,1);
d.cells(end).junctions.linked2CellNumbers2 = zeros(0,1);

d.cells(end) = set_empty_cell_properties(d.cells(end));

d.cells(end).division.newAreas = zeros(2,1);
d.cells(end).lineage = length(d.cells);

d.cells(end).vertexCorticalTensions = ones(length(d.cells(end).verticesX),1);

% calculate the normal boundary vertex distance
d.spar.membraneLength = d.cells(end).leftLengths(1);
d.spar.normArea = d.cells(end).normArea;

if isempty(d.cells(1).verticesX)
   d.cells(1) = [];
   d.cells(end).lineage = d.cells(end).lineage - 1;
end

end