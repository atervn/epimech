function cells = get_cell_areas(cells)
% GET_CELL_AREAS Calculate the areas of the cell.
%   The function loops through the cells to get their areas.
%   INPUTS:
%       cells: cell data structure
%   OUTPUT:
%       cells: cell data structure
%   by Aapo Tervonen, 2021

% go through the cells
for k = 1:length(cells)
    
    % calculate their areas
    cells(k).area = calculate_area(cells(k).verticesX,cells(k).verticesY);
end

end