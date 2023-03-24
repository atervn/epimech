function centerCell = get_center_cell(cells)
% GET_CENTER_CELL Find the cell closests to the epithelium center
%   The function find the cell whose center point is closest to the center
%   point of the whole epithelium patch.
%   INPUT:
%       cells: cell data structure
%   OUTPUT:
%       centerCell: index of the center cell
%   by Aapo Tervonen, 2021

% initialize the maximum and minimum coordinate vectors
maxPointX = zeros(length(cells),1);
minPointX = maxPointX;
maxPointY = maxPointX;
minPointY = maxPointX;

% initialize vectors for cell center coordinates
cellCentersX = maxPointX;
cellCentersY = maxPointX;

% go through the cells
for k = 1:length(cells)
    
    % get the maximun and minimum vertex coordinates in each directions
    maxPointX(k) = max(cells(k).verticesX);
    minPointX(k) = min(cells(k).verticesX);
    maxPointY(k) = max(cells(k).verticesY);
    minPointY(k) = min(cells(k).verticesY);
    
    % get the cell center coordinates
    cellCentersX(k) = mean(cells(k).verticesX);
    cellCentersY(k) = mean(cells(k).verticesY);
end

% find the maximum coordinate in each direction
maxPointX = max(maxPointX);
minPointX = min(minPointX);
maxPointY = max(maxPointY);
minPointY = min(minPointY);

% find the middle point of the epithelium patch
epiCenterX = (maxPointX + minPointX)/2;
epiCenterY = (maxPointY + minPointY)/2;

% find the index of the cell whose center is closest to the epithelium
% patch center
[~,centerCell] = min((epiCenterX - cellCentersX).^2 + (epiCenterY - cellCentersY).^2);

end