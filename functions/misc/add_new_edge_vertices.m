function d = add_new_edge_vertices(d,k,longIdx,pos)
% ADD_NEW_EDGE_VERTICES Adds new edge vertices for the cells
%   The function adds new edge vertices when new vertices are added.
%   New edge vertices is added only if both neighboring vertices are edge
%   vertices. The initial coordinates are defined as a mean of the
%   neighboring vertices' initial coordinates.
%   INPUTS:
%       d: main simulation data structure
%       k: current cell index
%       longIdx: index of the long section (right side vertex)
%       pos: variable to describe if the longIdx is the last vertex (2) or
%       not (1)
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if edge cells
if d.cells(k).cellState == 0
    
    % add one to the indices of the edge vertices that have higher index
    % than longIdx
    if pos == 1
        d.cells(k).edgeVertices(d.cells(k).edgeVertices > longIdx) = d.cells(k).edgeVertices(d.cells(k).edgeVertices > longIdx) + 1;
    end
    
    % if both the neighboring vertices are edge vertices
    if any(d.cells(k).edgeVertices == longIdx) && any(d.cells(k).edgeVertices == longIdx+1)
        
        % find their indices in the edgeVertices vector
        if pos == 1
            prevIdx = d.cells(k).edgeVertices == longIdx;
            nextIdx = d.cells(k).edgeVertices == longIdx+1;
        else
            prevIdx = d.cells(k).edgeVertices == longIdx;
            nextIdx = d.cells(k).edgeVertices == 1;
        end
        
        % add the new vertex to the vector
        d.cells(k).edgeVertices = [d.cells(k).edgeVertices ; longIdx+1];
        
        % calculate the initial position as a mean of the initial positions
        % of the neighboring vertices
        d.cells(k).edgeInitialX = [d.cells(k).edgeInitialX ; 0.5*(d.cells(k).edgeInitialX(prevIdx) + d.cells(k).edgeInitialX(nextIdx))];
        d.cells(k).edgeInitialY = [d.cells(k).edgeInitialY ; 0.5*(d.cells(k).edgeInitialY(prevIdx) + d.cells(k).edgeInitialY(nextIdx))];
        
    end
end

end