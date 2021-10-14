function d = get_substrate_edge_points(d)
% GET_SUBSTRATE_EDGE_POINTS Define the edge points for the substrate 
%   The function finds the indices of the points at the edges of the
%   substrate.
%   INPUT:
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if pointlike or optogenetic simulation
if any(d.simset.simulationType == [2,5])
    
    % create a temporary empty matrix
    tempMat = d.sub.emptyMatrix;
    
    % assign one to all locations where there is a direct interactions
    % (unique or counter)
    tempMat(d.sub.interactionLinIdx) = 1;
    tempMat(d.sub.counterInteractionLinIdx) = 1;
    
    % the edge points are the ones with less than 6 direct interactions
    d.sub.edgePoints = sum(tempMat,1) < 6;
end

end