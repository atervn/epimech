function frameCell = create_frame_cell(d)
% CREATE_FRAME_CELL Define a frame used in the shring frame simulations
%   The function defines the frame used to shrink the epithelium as a cell
%   with whom the other cells can have contact forces with.
%   INPUTS:
%       d: main simulation data structure
%   OUTPUT:
%       frameCell: a frame cell used to frame other cells

%   by Aapo Tervonen, 2021

% define the set of frame vertex coordinate based on the corners and the
% membrane length
increasingCoords = d.simset.frame.cornersX(1):d.spar.membraneLength:d.simset.frame.cornersX(2);
decreasingCoords = d.simset.frame.cornersX(2):-d.spar.membraneLength:d.simset.frame.cornersX(1);
constansPositiveCoords = d.simset.frame.cornersX(2).*ones(1,length(decreasingCoords));
constantNegativeCoords = -constansPositiveCoords;

% build the edge coordinates for x and y
frameX = [increasingCoords constansPositiveCoords decreasingCoords constantNegativeCoords]';
frameY = [constantNegativeCoords increasingCoords constansPositiveCoords decreasingCoords]';

% initialize the structure
frameCell = initialize_cells_struct;

% assign the cell vertex coordinates
frameCell.verticesX = frameX;
frameCell.verticesY = frameY;

% assign cell properties
frameCell.nVertices = length(frameCell.verticesX);
frameCell.vertexStates = zeros(size(frameCell.verticesX));
frameCell.division.state = 0;
frameCell.cellState = 0;
frameCell.division.vertices = [0;0];
frameCell.division.time = 0;
frameCell.junctions.cells = zeros(length(frameCell.verticesX),2);
frameCell.junctions.vertices = zeros(length(frameCell.verticesX),2);

% get the boundary vectors, lengths, and angles
frameCell = get_boundary_vectors(frameCell);
frameCell = get_boundary_lengths(frameCell);
frameCell = get_vertex_angles(frameCell);

% get the area and perimeter (maybe unnecessary)
frameCell = get_cell_areas(frameCell);
frameCell = get_cell_perimeters(frameCell);

% get normal areas and perimeters
frameCell.normArea = frameCell.area;
frameCell.normPerimeter = frameCell.perimeter;
frameCell.division.targetArea = 0;

% initialize the junction properties
frameCell.junctions.linkedIdx1 = zeros(0,1);
frameCell.junctions.pairCells1 = zeros(0,1);
frameCell.junctions.pairVertices1 = zeros(0,1);
frameCell.junctions.linked2CellNumbers1 = zeros(0,1);
frameCell.junctions.linkedIdx2 = zeros(0,1);
frameCell.junctions.pairCells2 = zeros(0,1);
frameCell.junctions.pairVertices2 = zeros(0,1);
frameCell.junctions.linked2CellNumbers2 = zeros(0,1);

% misc definitions
frameCell = set_empty_cell_properties(frameCell);
frameCell.division.newAreas = zeros(2,1);
frameCell.lineage = 1;
frameCell.corticalTension = 1;

end