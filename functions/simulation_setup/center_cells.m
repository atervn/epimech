function cells = center_cells(cells)

nCells = length(cells);
xMin = zeros(nCells,1);
xMax = zeros(nCells,1);
yMin = zeros(nCells,1);
yMax = zeros(nCells,1);

for k = 1:nCells
    xMin(k) = min(cells(k).verticesX);
    xMax(k) = max(cells(k).verticesX);
    yMin(k) = min(cells(k).verticesY);
    yMax(k) = max(cells(k).verticesY);
end

xMin = min(xMin);
xMax = max(xMax);
yMin = min(yMin);
yMax = max(yMax);

xDisplacement = -(xMax + xMin)/2;
yDisplacement = -(yMax + yMin)/2;

for k = 1:nCells
    cells(k).verticesX = cells(k).verticesX + xDisplacement;
    cells(k).verticesY = cells(k).verticesY + yDisplacement;
end