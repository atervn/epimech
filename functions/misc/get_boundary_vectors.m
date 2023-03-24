function cells = get_boundary_vectors(cells)
% GET_BOUNDARY_VECTORS Calculate the vectors based on vertex coordinates
%   The function goes through each cell to calculate both the left and 
%   right sided boundary vectors for each vertex. The left side vector is
%   from the current vertex to the next (in counterclockwise direction) and
%   the right side vector is from the previous vertex (in clockwise
%   direction) to the current vertex. Thus, both vectores are directed in
%   the counterclockwise direction. Calculting both in this functions once
%   reduces the times that circshift has to be used in the subsequent
%   functions.
%   INPUTS:
%       cells: cell structure
%   OUTPUT:
%       cells: cell structure
%   by Aapo Tervonen, 2021

% go througt the cells
for k = 1:length(cells)
    
    % calculate the left vectors
    cells(k).leftVectorsX = circshift(cells(k).verticesX,-1,1) - cells(k).verticesX;
    cells(k).leftVectorsY = circshift(cells(k).verticesY,-1,1) - cells(k).verticesY;
    
    % get the right vectors
    cells(k).rightVectorsX = circshift(cells(k).leftVectorsX,1,1);
    cells(k).rightVectorsY = circshift(cells(k).leftVectorsY,1,1);
end

end