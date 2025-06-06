function d = find_closest_vertices_self(d, k)
% FIND_CLOSEST_VERTICES_SELF Finds the close vertices for the other side of
% the cell
%   The function find the close vertices on the other side of the cell to
%   prevent membrane overlapping.
%   INPUTS:
%       d: main simulation data structure
%       k: current cell index
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021


% initialize pair ID data
% vertexIDs = [];
% pairIDs = [];

% get the squared distance between the set of coordinates
vertexDistancesSq = (d.cells(k).verticesX - d.cells(k).verticesX').^2 + (d.cells(k).verticesY - d.cells(k).verticesY').^2;
vertexDistancesSq = vertexDistancesSq + ...
    diag(100.*ones(d.cells(k).nVertices,1)) + diag(100.*ones(d.cells(k).nVertices-1,1),1) + diag(100.*ones(d.cells(k).nVertices-1,1),-1) + ...
    diag(100.*ones(d.cells(k).nVertices-2,1),2) + diag(100.*ones(d.cells(k).nVertices-2,1),-2) + diag(100.*ones(d.cells(k).nVertices-3,1),3) + ...
    diag(100.*ones(d.cells(k).nVertices-3,1),-3) + diag(100.*ones(d.cells(k).nVertices-4,1),4) + diag(100.*ones(d.cells(k).nVertices-4,1),-4);

% go through the division vertices
% for i = 1:2
%         
%     % get the coordinates of the left side vertices
%     leftVerticesX = d.cells(k).verticesX(leftVerticesIdx);
%     leftVerticesY = d.cells(k).verticesY(leftVerticesIdx);
%     
%     % get the coordinates of the right side vertices
%     rightVerticesX = d.cells(k).verticesX(rightVerticesIdx);
%     rightVerticesY = d.cells(k).verticesY(rightVerticesIdx);
%     
%     
%     
%     % find the possible pairs for each vertex
%     possibleInteractions = vertexDistancesSq < (3*d.spar.junctionLength).^2;
%     
%     % find the vertices on the left that have at least one contact
%     atLeastContactLeft = ~(sum(possibleInteractions,1) == 0)';
%     
%     % find the vertices on the right that have at least one contact
%     atLeastContactRight = ~(sum(possibleInteractions,2) == 0)';
%     
%     % indices of the vertices that have interactions
%     leftVerticesIdxSelf = leftVerticesIdx(:,atLeastContactLeft);
%     rightVerticesIdxSelf = rightVerticesIdx(:,atLeastContactRight);
%     
%     % set too long distances to NaN
%     vertexDistancesSq(~possibleInteractions) = nan;
%     
%     % get the squared distances between the pairs and the vertices
%     vertexDistancesSqLeft = vertexDistancesSq(:,atLeastContactLeft);
%     vertexDistancesSqRight = vertexDistancesSq(atLeastContactRight,:);
%     
%     % sort the left and right lengths
%     [~,closestPairsLeft] = sort(vertexDistancesSqLeft,1);
%     [~,closestPairRight] = sort(vertexDistancesSqRight,2);
%     
%     % save the contact pair data
%     vertexIDs = [vertexIDs leftVerticesIdxSelf rightVerticesIdxSelf]; %#ok<*AGROW>
%     pairIDs = [pairIDs rightVerticesIdx(closestPairsLeft(1,:)) leftVerticesIdx(closestPairRight(:,1))];
%     
% end
% 
% % get the "self" vertex coordinates
% verticesX = d.cells(k).verticesX(vertexIDs);
% verticesY = d.cells(k).verticesY(vertexIDs);
% 
% % get the previous indices for each pair
% pairsPrev = pairIDs - 1;
% firsts = pairIDs == 1;
% pairsPrev(firsts) = d.cells(k).nVertices;
% 
% % get the pair coordinates, and the left and right segment lengths and
% % vectors
% leftSegmentX = d.cells(k).verticesX(pairIDs);
% leftSegmentY = d.cells(k).verticesY(pairIDs);
% rightSegmentX = d.cells(k).verticesX(pairsPrev);
% rightSegmentY = d.cells(k).verticesY(pairsPrev);
% leftSegmentLength = d.cells(k).leftLengths(pairIDs);
% rightSegmentLength = d.cells(k).leftLengths(pairsPrev);
% leftSegmentVectorX = d.cells(k).leftVectorsX(pairIDs);
% leftSegmentVectorY = d.cells(k).leftVectorsY(pairIDs);
% rightSegmentVectorX = d.cells(k).leftVectorsX(pairsPrev);
% rightSegmentVectorY = d.cells(k).leftVectorsY(pairsPrev);
% 
% % project the "self" vertex to the boundary segments on each side of the
% % pair vertex
% projectionRight = ((verticesX - rightSegmentX).*rightSegmentVectorX + (verticesY - rightSegmentY).*rightSegmentVectorY)./rightSegmentLength.^2;
% projectionLeft = ((verticesX - leftSegmentX).*leftSegmentVectorX + (verticesY - leftSegmentY).*leftSegmentVectorY)./leftSegmentLength.^2;
% 
% % find the interactions that are on the segments
% betweenRight =  and(0 <= projectionRight, projectionRight <= 1);
% betweenLeft =  and(0 <= projectionLeft, projectionLeft <= 1);
% 
% % save the information on the vertices whose projection is on the right
% % segment of the closest vertex
% prev.vertices = vertexIDs(betweenRight);
% prev.present = ~isempty(prev.vertices);
% if prev.present
%     prev.pairIDs = pairsPrev(betweenRight);
% end
% d.cells(k).contacts.division.prev = prev;
% 
% % save the information on the vertices whose projection is on the left
% % segment of the closest vertex
% next.vertices = vertexIDs(betweenLeft);
% next.present = ~isempty(next.vertices);
% if next.present
%     next.pairIDs = pairIDs(betweenLeft);
% end
% d.cells(k).contacts.division.next = next;
% 
% % save the information on the vertices whose projection is on neither of
% % the segments
% neither = ~or(betweenRight,betweenLeft);
% vertex.vertices = vertexIDs(neither);
% vertex.present = ~isempty(vertex.vertices);
% if vertex.present
%     vertex.pairIDs = pairIDs(neither);
% end
% d.cells(k).contacts.division.vertex = vertex;

end