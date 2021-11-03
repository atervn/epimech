function d = create_cell(d,cellCenter,varargin)
% CREATE_CELL Create a new cell
%   The function defines the properties of a new cell cell for a new
%   simulation.
%   INPUT:
%       d: main simulation data structure
%       cellCenter: center coordinates for the cell
%       varargin: used to indicate if only the cell data needed for simple
%       plotting is required
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% get a round number of boundary points based on the circle perimeter and
% normal vertex distance
nBoundary = round(2*pi*d.spar.rCell/d.spar.membraneLength);

% use the number of vertices to calculate a new radius so that the vertex
% distance are at the default values
d.spar.rCell = nBoundary*d.spar.membraneLength/(2*pi);

% get the x and y-coordinates for the cell boundary (and create the cells)
d.cells(end+1).verticesX = d.spar.rCell.*cos(2.*pi.*(0:1/nBoundary:1-1/nBoundary)') + cellCenter(1)/d.spar.scalingLength;
d.cells(end).verticesY = d.spar.rCell.*sin(2.*pi.*(0:1/nBoundary:1-1/nBoundary)') + cellCenter(2)/d.spar.scalingLength;

% vertex velocities
d.cells(end).velocitiesX = zeros(size(d.cells(end).verticesX));
d.cells(end).velocitiesY = zeros(size(d.cells(end).verticesY));

% get the number of vertices
d.cells(end).nVertices = length(d.cells(end).verticesX);

% create a vector for the vertex states
d.cells(end).vertexStates = zeros(d.cells(end).nVertices,1);

% set the cell state
d.cells(end).cellState = 0;

% return if the cell is created for a simple plot
if numel(varargin) > 0 && strcmp(varargin{1}, 'simple_plot')
    
    % check if this is the first cell (since the struct is formed
    % beforehand, the end+1 creates the first actual cell at index 2,
    % therefore the first is an empty cell)
    
    if isempty(d.cells(1).verticesX)
        % remove the first empty cell
        d.cells(1) = [];
    end
    
    return
end

% initialize the main cell-cell junction data matrices
d.cells(end).junctions.cells = zeros(length(d.cells(end).verticesX),2);
d.cells(end).junctions.vertices = d.cells(end).junctions.cells;

% initialize the additional junction data matrices
d.cells(end).junctions.linkedIdx1 = zeros(0,1);
d.cells(end).junctions.linkedIdx2 = zeros(0,1);
d.cells(end).junctions.pairCells1 = zeros(0,1);
d.cells(end).junctions.pairCells2 = zeros(0,1);
d.cells(end).junctions.pairVertices1 = zeros(0,1);
d.cells(end).junctions.pairVertices2 = zeros(0,1);
d.cells(end).junctions.linked2CellNumbers1 = zeros(0,1);
d.cells(end).junctions.linked2CellNumbers2 = zeros(0,1);

% get boundary vectors and lengths
d.cells(end) = get_boundary_vectors(d.cells(end));
d.cells(end) = get_boundary_lengths(d.cells(end));

% get cell area and perimeter
d.cells(end) = get_cell_areas(d.cells(end));
d.cells(end) = get_cell_perimeters(d.cells(end));

% set normal area and perimeter
d.cells(end).normArea = d.cells(end).area;
d.cells(end).normPerimeter = d.cells(end).perimeter;

% get outside vertex angles
d.cells(end) = get_vertex_angles(d.cells(end));

% if growth simulation
if d.simset.simulationType == 1
    
    % set the division state
    d.cells(end).division.state = 0;
    
% otherwise
else
    d.cells(end).division.state = -1;
end

% initialize division vertices, division, target area and new
% areas, and square division distance
d.cells(end).division.vertices = [0;0];
d.cells(end).division.time = 0;
d.cells(end).division.targetArea = 0;
d.cells(end).division.newAreas = zeros(2,1);
d.cells(end).division.distanceSq = 0;

% set the cell lineage (only the cell itself)
d.cells(end).lineage = length(d.cells);

% set the individual vertex cortical multipliers, the whole cell cortical
% strength and the perimeter-dependent tension constant
d.cells(end).cortex.vertexMultipliers = ones(length(d.cells(end).verticesX),1);
d.cells(end).cortex.fCortex = d.spar.fCortex;
d.cells(end).cortex.perimeterConstant = d.spar.perimeterConstant;

% check if this is the first cell (since the struct is formed beforehand,
% the end+1 creates the first actual cell at index 2, therefore the first
% is an empty cell)
if isempty(d.cells(1).verticesX)
    
    % get the normal membrane section length
    d.spar.membraneLength = d.cells(end).leftLengths(1);
        
    % get the normal cell area (unused if mdck cell size)
    d.spar.normArea = d.cells(end).normArea;
    
    % remove the first empty cell
    d.cells(1) = [];
    
    % reduce the lineage index of the first actual cell
    d.cells(end).lineage = d.cells(end).lineage - 1;
end

% set the empty cell propreties
d.cells(end) = set_empty_cell_properties(d.cells(end));

end