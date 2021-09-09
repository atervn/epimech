function cells = get_vertex_angles(cells)
% GET_VERTEX_ANGLES Calculate the angles for each vertex
%   The function takes in the main cell structure and goes through each
%   cell to calculate both the outside angles between the previous and next
%   boundary segment for each vertex. Finally, the cell structure
%   is outputted.
%   by Aapo Tervonen, 2021

% go through the cells
for k = 1:length(cells)
    
    % get the outside angles between the two vectors
    cells(k).outsideAngles = get_angles(cells(k).rightVectorsX, cells(k).rightVectorsY, cells(k).leftVectorsX, cells(k).leftVectorsY);

end

end