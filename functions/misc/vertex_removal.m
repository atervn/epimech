function d = vertex_removal(d,k,vertex2Remove)
% VERTEX_REMOVAL Remove a vertex and its interactions
%   The function removes a designated vertex, and all data related to it.
%   Also, it edits the junction data of the other cells to take into
%   account the reduction of the vertices whose indices are reduced by one,
%   as well as the focal adhesion data if substrate is included.
%   INPUTS:
%       d: main simulation data structure
%       k: current cell index
%       vertex2Remove: index of the vertex to be removed
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% remove the coordinates for the vertex
d.cells(k).verticesX(vertex2Remove) = [];
d.cells(k).verticesY(vertex2Remove) = [];

% if the vertex has a junction or two
if any(d.cells(k).vertexStates(vertex2Remove) == [1 2])
    for i2 = 1:d.cells(k).vertexStates(vertex2Remove)
        
        % get the pair ID data for the junction
        cellID = d.cells(k).junctions.cells(vertex2Remove,i2);
        vertexID = d.cells(k).junctions.vertices(vertex2Remove,i2);
        
        % which of the junctions this is for the pair
        whichJunction = find(d.cells(cellID).junctions.cells(vertexID,:) == k);
        
        % set the junction and vertex state data to empty for the
        % pair vertex
        d.cells(cellID).junctions.cells(vertexID,whichJunction) = 0;
        d.cells(cellID).junctions.vertices(vertexID,whichJunction) = 0;
        
        % decrease the number of junctions for the pair by one
        if d.cells(cellID).vertexStates(vertexID) == 2
            d.cells(cellID).vertexStates(vertexID) = 1;
            
            % if the removed junction was the first one for the
            % pair, copy the data from the second junction to
            % the first index
            if whichJunction == 1
                d.cells(cellID).junctions.cells(vertexID,1) = d.cells(cellID).junctions.cells(vertexID,2);
                d.cells(cellID).junctions.vertices(vertexID,1) = d.cells(cellID).junctions.vertices(vertexID,2);
                d.cells(cellID).junctions.cells(vertexID,2) = 0;
                d.cells(cellID).junctions.vertices(vertexID,2) = 0;
            end
        else
            d.cells(cellID).vertexStates(vertexID) = 0;
        end
    end
end

% get the vertices in cell k whose pairs junction data has to
% be updated (have higher index than the removed vertex)
junctions2UpdateIdx = find(d.cells(k).vertexStates > 0);
junctions2UpdateIdx(junctions2UpdateIdx <= vertex2Remove) = [];

% go through the junction pairs of the vertices whose indices
% have changed
for j = junctions2UpdateIdx'
    
    % go through the number of pairs
    for i2 = 1:d.cells(k).vertexStates(j)
        
        % temporary indices
        cellID = d.cells(k).junctions.cells(j,i2);
        vertexID = d.cells(k).junctions.vertices(j,i2);
        
        % find which junction this is for the pair
        whichJunction = d.cells(cellID).junctions.cells(vertexID,:) == k;
        
        % reduce the pair's junction vertex index by one
        d.cells(cellID).junctions.vertices(vertexID,whichJunction) = d.cells(cellID).junctions.vertices(vertexID,whichJunction) - 1;
    end
end

% remove vertex from vertexStates
d.cells(k).vertexStates(vertex2Remove) = [];

% remove the junction data
d.cells(k).junctions.cells(vertex2Remove,:) = [];
d.cells(k).junctions.vertices(vertex2Remove,:) = [];

% update the divisionVertices (minus one from the division
% vertice that have higher index than the vertex to be removed
d.cells(k).division.vertices = d.cells(k).division.vertices - 1.*double((d.cells(k).division.vertices) >= vertex2Remove);

% if substrate is included
if any(d.simset.simulationType == [3,5])
    if d.cells(k).substrate.connected(vertex2Remove)
        
        idxTemp = find(find(d.cells(k).substrate.connected) == vertex2Remove);
        
        removedAdhesions = d.cells(k).substrate.points(idxTemp,:);
        removedLinkCols = d.cells(k).substrate.linkCols(idxTemp,:);
        
        % for each removed ahdesion
        for i2 = 1:3
            
            % go through the cells
            for k2 = 1:length(d.cells)
                
                % find if any of that cells vertices is linked with
                % the same point
                sharedPoints = d.cells(k2).substrate.points == removedAdhesions(i2);
                if any(sharedPoints(:))
                    % checks if the shared points have higher index
                    % in the substrateMatrix than the removed
                    % vertice had
                    sharedAndHigher = and(sharedPoints,d.cells(k2).substrate.linkCols > removedLinkCols(i2));
                    
                    % update he linkCols and substrateMatrix
                    % indices
                    d.cells(k2).substrate.linkCols(sharedAndHigher) = d.cells(k2).substrate.linkCols(sharedAndHigher) - 1;
                    d.cells(k2).substrate.matrixIdx = sub2ind([d.sub.nPoints 200],d.cells(k2).substrate.points(:),d.cells(k2).substrate.linkCols(:));
                end
            end
        end
        
        % reduce the adhesion number for the associated substrate points by
        % one
        d.sub.adhesionNumbers(d.cells(k).substrate.points(idxTemp,:)) = d.sub.adhesionNumbers(d.cells(k).substrate.points(idxTemp,:)) - 1;
        
        % remove the vertex from the substrate interaction data
        d.cells(k).substrate.points(idxTemp,:) = [];
        d.cells(k).substrate.weights(idxTemp,:) = [];
        d.cells(k).substrate.linkCols(idxTemp,:) = [];
        
        % recalculate the linear indices in the substrateMatrix
        d.cells(k).substrate.matrixIdx = sub2ind([d.sub.nPoints 200],d.cells(k).substrate.points(:),d.cells(k).substrate.linkCols(:));
    end
    
    % remove the vertex from the connected vertices
    d.cells(k).substrate.connected(vertex2Remove) = [];
    
    % if the cell is an edge cell
    if d.cells(k).cellState == 0
        
        % reduce the indices of the edge vertices with higher indices by
        % one
        d.cells(k).edgeVertices(d.cells(k).edgeVertices > vertex2Remove) = d.cells(k).edgeVertices(d.cells(k).edgeVertices > vertex2Remove) - 1;
        
        % check if the removed vertex if an edge vertex
        if any(d.cells(k).edgeVertices == vertex2Remove)
            
            % if yes, remove it from the edge vertex data
            tempIdx = d.cells(k).edgeVertices == vertex2Remove;
            d.cells(k).edgeVertices(tempIdx) = [];
            d.cells(k).edgeInitialX(tempIdx) = [];
            d.cells(k).edgeInitialY(tempIdx) = [];
        end
    end
end

% Modify the cortex multipliers. The value are edited for the links
% which either have the removed vertex as a start or an end point or have
% the cortical link going over the removed vertex. The new values are
% calculated as the average of the two neighboring links having some
% association with the removed vertex.
originals = d.cells(k).cortex.vertexMultipliers;

% if the removed vertex is the first
if vertex2Remove == 1
    d.cells(k).cortex.vertexMultipliers(end-1) = (originals(end-1) + originals(end))/2;
    d.cells(k).cortex.vertexMultipliers(end) = (originals(end) + originals(1))/2;
    
    % if the removed vertex is the second
elseif vertex2Remove == 2
    d.cells(k).cortex.vertexMultipliers(end) = (originals(end) + originals(1))/2;
    d.cells(k).cortex.vertexMultipliers(1) = (originals(1) + originals(2))/2;
    
    % otherwise
else
    idx = vertex2Remove;
    d.cells(k).cortex.vertexMultipliers(idx-2) = (originals(idx-2) + originals(idx-1))/2;
    d.cells(k).cortex.vertexMultipliers(idx-1) = (originals(idx-1) + originals(idx))/2;
end

% remove the vertex from the cortical multipliers
d.cells(k).cortex.vertexMultipliers(vertex2Remove) = [];

% set junction modification to true
d.simset.junctionModification = true;

end