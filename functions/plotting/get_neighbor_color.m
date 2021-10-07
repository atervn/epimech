function color = get_neighbor_color(nNeighbors)
% GET_NEIGHBOR_COLOR Gives the color based on the number of neighbors
%   The function output the cell face color based on its number of
%   neighbors.
%       neighbors: number of neighbors
%   by Aapo Tervonen, 2021

% gives the color based on the number of neighbors (none and one are
% clumped together, as are those with more than seven)
if nNeighbors <= 1
    color = [0.6 0.73 0.62];
elseif nNeighbors <= 2
    color = [0.71 0.69 0.55];
elseif nNeighbors <= 3
    color = [0.71 0.59 0.55];
elseif nNeighbors <= 4
    color = [0.71 0.55 0.59];
elseif nNeighbors <= 5
    color = [0.5 0.59 0.71];
elseif nNeighbors <= 6
    color = [0.59 0.63 0.71];
elseif nNeighbors <= 7
    color = [0.55 0.69 0.70];
else
    color = [0.40 0.45 0.41];
end

end