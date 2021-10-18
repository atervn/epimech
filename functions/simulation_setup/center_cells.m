function cells = center_cells(cells)
% CENTER_CELLS Center the epithelium patch
%   The function centers the epithelium cells so that the middle point of
%   the epithelium patch is at coordinates (0,0)
%   INPUT:
%       cells: cell data structure
%   OUTPUT:
%       cells: cell data structure
%   by Aapo Tervonen, 2021

% get the number of cells
nCells = length(cells);

% initialize the vectors for the maximum and minimum x and y-coordinates
xMin = zeros(nCells,1);
xMax = zeros(nCells,1);
yMin = zeros(nCells,1);
yMax = zeros(nCells,1);

% go through the cells and get the minimum and maximum vertex coordinates
% for each cell
for k = 1:nCells
    xMin(k) = min(cells(k).verticesX);
    xMax(k) = max(cells(k).verticesX);
    yMin(k) = min(cells(k).verticesY);
    yMax(k) = max(cells(k).verticesY);
end

% find the minimum and maximum coordinates in the whole epithelium
xMin = min(xMin);
xMax = max(xMax);
yMin = min(yMin);
yMax = max(yMax);

% find the amount of displacement required to center the epithelium
xDisplacement = -(xMax + xMin)/2;
yDisplacement = -(yMax + yMin)/2;

% go through the cells
for k = 1:nCells
    
    % adjust the cell coordinates
    cells(k).verticesX = cells(k).verticesX + xDisplacement;
    cells(k).verticesY = cells(k).verticesY + yDisplacement;
end

end