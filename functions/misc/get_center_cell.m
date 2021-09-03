function centerCell = get_center_cell(cells)

maxPointX = zeros(length(cells),1);
minPointX = maxPointX;
maxPointY = maxPointX;
minPointY = maxPointX;

cellCentersX = maxPointX;
cellCentersY = maxPointX;

for k = 1:length(cells)
    maxPointX(k) = max(cells(k).verticesX);
    minPointX(k) = min(cells(k).verticesX);
    maxPointY(k) = max(cells(k).verticesY);
    minPointY(k) = min(cells(k).verticesY);
    
    cellCentersX(k) = mean(cells(k).verticesX);
    cellCentersY(k) = mean(cells(k).verticesY);
end

maxPointX = max(maxPointX);
minPointX = min(minPointX);
maxPointY = max(maxPointY);
minPointY = min(minPointY);

epiCenterX = (maxPointX + minPointX)/2;
epiCenterY = (maxPointY + minPointY)/2;

[~,centerCell] = min((epiCenterX - cellCentersX).^2 + (epiCenterY - cellCentersY).^2);