function cells = get_vertex_angles(cells)
% GET_VERTEX_ANGLES Calculate the angles for each vertex
%   The function goes through each cells to calculate both the outside
%   angles between the previous and next boundary segment for each vertex.
%   INPUTS:
%       cells: cell structure
%   OUTPUT:
%       cells: cell structure
%   by Aapo Tervonen, 2021

% go through the cells
for k = 1:length(cells)
    
    % get the outside angles between the two vectors
    cells(k).outsideAngles = get_angles(cells(k).rightVectorsX, cells(k).rightVectorsY, cells(k).leftVectorsX, cells(k).leftVectorsY);

end

end