function cells = get_boundary_lengths(cells)
% GET_BOUNDARY_LENGTHS Calculate the lengths between neighboring vertices
%   The function goes through each cell to calculate the lengths for both
%   the left (counterclockwise) and right (clockwise) sided  boundary
%   segment between the vertices. Both sides are calculate the reduce the
%   need to use circshift later.
%   INPUTS:
%       cells: cell structure
%   OUTPUT:
%       cells: cell structure
%   by Aapo Tervonen, 2021

% go through the cells
for k = 1:length(cells)
    
    % calculate the left side lengths
    cells(k).leftLengths = sqrt(cells(k).leftVectorsX.^2 + cells(k).leftVectorsY.^2);
    
    % get the right side lengths
    cells(k).rightLengths = circshift(cells(k).leftLengths,1,1);
end

end