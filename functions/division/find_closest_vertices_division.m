function d = find_closest_vertices_division(d)
% FIND_CLOSEST_VERTICES_DIVISION Finds the close vertices around division
% vertices
%   The function find the close vertices around the division vertices to
%   prevent membrane overlapping in the cytokinesis cleavage sites.
%   INPUTS:
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021


% number of vertices to consider on left and right sides from the
% division vertices based on the relative number of vertices in the cell
vertices2Include = round(0.1*d.cells(k).nVertices);

% initialize pair ID data
vertexIDs = [];
pairIDs = [];

% go through the division vertices
for i = 1:2
    
    % division vertices 1 (smaller index)
    if i == 1
        
        % indices of the vertices left to the division vertex 1
        leftVerticesIdx = d.cells(k).division.vertices(1) + 1 : d.cells(k).division.vertices(1) + vertices2Include;
        
        % indices of the vertices right to the division vertex 1 (dealt
        % differently if divVertex 1 is close to the first vertex)
        if d.cells(k).division.vertices(1) > vertices2Include + 1
            rightVerticesIdx = d.cells(k).division.vertices(1) - vertices2Include : d.cells(k).division.vertices(1) - 1;
        else
            nVerticesAtEnd = d.cells(k).division.vertices(1)-1;
            rightVerticesIdx = [d.cells(k).nVertices-(vertices2Include - nVerticesAtEnd)+1:d.cells(k).nVertices 1:nVerticesAtEnd];
        end
        
    % division vertex 2 (higher index)
    else
        
        % indices of the vertices right to the division vertex 2
        rightVerticesIdx = d.cells(k).division.vertices(2) - vertices2Include : d.cells(k).division.vertices(2) - 1;
        
        % indices of the vertices left to the division vertex 2 (dealt 
        % differently if divVertex 2 is close to the last vertex)
        if d.cells(k).division.vertices(2) + vertices2Include <= d.cells(k).nVertices
            leftVerticesIdx = d.cells(k).division.vertices(2) + 1 : d.cells(k).division.vertices(2) + vertices2Include;
        else
            nVerticesAtBeginning = d.cells(k).nVertices - d.cells(k).division.vertices(2);
            leftVerticesIdx = [d.cells(k).division.vertices(2)+1:d.cells(k).nVertices 1:vertices2Include - nVerticesAtBeginning];
        end
    end
    
    % get the coordinates of the left side vertices
    leftVerticesX = d.cells(k).verticesX(leftVerticesIdx);
    leftVerticesY = d.cells(k).verticesY(leftVerticesIdx);
    
    % get the coordinates of the right side vertices
    rightVerticesX = d.cells(k).verticesX(rightVerticesIdx);
    rightVerticesY = d.cells(k).verticesY(rightVerticesIdx);
    
    % get the squared distance between the set of coordinates
    vertexDistancesSq  = (rightVerticesX - leftVerticesX').^2 + (rightVerticesY - leftVerticesY').^2;
    
    % find the possible pairs for each vertex
    possibleInteractions = vertexDistancesSq < (3*d.spar.junctionLength).^2;
    
    % find the vertices on the left that have at least one contact
    atLeastContactLeft = ~(sum(possibleInteractions,1) == 0)';
    
    % find the vertices on the right that have at least one contact
    atLeastContactRight = ~(sum(possibleInteractions,2) == 0)';
    
    % indices of the vertices that have interactions
    leftVerticesIdxSelf = leftVerticesIdx(:,atLeastContactLeft);
    rightVerticesIdxSelf = rightVerticesIdx(:,atLeastContactRight);
    
    % set too long distances to NaN
    vertexDistancesSq(~possibleInteractions) = nan;
    
    % get the squared distances between the pairs and the vertices
    vertexDistancesSqLeft = vertexDistancesSq(:,atLeastContactLeft);
    vertexDistancesSqRight = vertexDistancesSq(atLeastContactRight,:);
    
    % sort the left and right lengths
    [~,closestPairsLeft] = sort(vertexDistancesSqLeft,1);
    [~,closestPairRight] = sort(vertexDistancesSqRight,2);
    
    % save the contact pair data
    vertexIDs = [vertexIDs leftVerticesIdxSelf rightVerticesIdxSelf]; %#ok<*AGROW>
    pairIDs = [pairIDs rightVerticesIdx(closestPairsLeft(1,:)) leftVerticesIdx(closestPairRight(:,1))];
    
end

% get the "self" vertex coordinates
verticesX = d.cells(k).verticesX(vertexIDs);
verticesY = d.cells(k).verticesY(vertexIDs);

% get the previous indices for each pair
pairsPrev = pairIDs - 1;
firsts = pairIDs == 1;
pairsPrev(firsts) = d.cells(k).nVertices;

% get the pair coordinates, and the left and right segment lengths and
% vectors
leftSegmentX = d.cells(k).verticesX(pairIDs);
leftSegmentY = d.cells(k).verticesY(pairIDs);
rightSegmentX = d.cells(k).verticesX(pairsPrev);
rightSegmentY = d.cells(k).verticesY(pairsPrev);
leftSegmentLength = d.cells(k).leftLengths(pairIDs);
rightSegmentLength = d.cells(k).leftLengths(pairsPrev);
leftSegmentVectorX = d.cells(k).leftVectorsX(pairIDs);
leftSegmentVectorY = d.cells(k).leftVectorsY(pairIDs);
rightSegmentVectorX = d.cells(k).leftVectorsX(pairsPrev);
rightSegmentVectorY = d.cells(k).leftVectorsY(pairsPrev);

% project the "self" vertex to the boundary segments on each side of the
% pair vertex
projectionRight = ((verticesX - rightSegmentX).*rightSegmentVectorX + (verticesY - rightSegmentY).*rightSegmentVectorY)./rightSegmentLength.^2;
projectionLeft = ((verticesX - leftSegmentX).*leftSegmentVectorX + (verticesY - leftSegmentY).*leftSegmentVectorY)./leftSegmentLength.^2;

% find the interactions that are on the segments
betweenRight =  and(0 <= projectionRight, projectionRight <= 1);
betweenLeft =  and(0 <= projectionLeft, projectionLeft <= 1);

% save the information on the vertices whose projection is on the right
% segment of the closest vertex
prev.vertices = vertexIDs(betweenRight);
prev.present = ~isempty(prev.vertices);
if prev.present
    prev.pairIDs = pairsPrev(betweenRight);
end
d.cells(k).contacts.division.prev = prev;

% save the information on the vertices whose projection is on the left
% segment of the closest vertex
next.vertices = vertexIDs(betweenLeft);
next.present = ~isempty(next.vertices);
if next.present
    next.pairIDs = pairIDs(betweenLeft);
end
d.cells(k).contacts.division.next = next;

% save the information on the vertices whose projection is on neither of
% the segments
neither = ~or(betweenRight,betweenLeft);
vertex.vertices = vertexIDs(neither);
vertex.present = ~isempty(vertex.vertices);
if vertex.present
    vertex.pairIDs = pairIDs(neither);
end
d.cells(k).contacts.division.vertex = vertex;

end