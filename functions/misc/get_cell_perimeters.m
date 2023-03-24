function cells = get_cell_perimeters(cells)
% GET_CELL_PERIMETERS Calculates the perimeters for each cell.
%   The function calculates the cell perimeters.
%   INPUTS:
%       cells: cell data structure
%   OUTPUT:
%       cells: cell data structure
%   by Aapo Tervonen, 2021

% go through the cells
for k = 1:length(cells)
    
    % calculate perimeters
    cells(k).perimeter = sum(cells(k).leftLengths);
end

end