function crossCheck = check_junction_crossing(cells,currentCell,currentVertex,pairCell,pairVertex)
% CHECK_JUNCTION_CROSSING Checks if new junction intersects with existing
% ones
%   The function checks if the new possible junction intersects any of the
%   junctions near it in the current cell.
%   INPUTS:
%       cells: cell data structure
%       currentCell: cell index
%       currentVertex: vertex index
%       pairCell: pair cell index
%       pairVertex: pair vertex index
%   OUTPUT:
%       crossCheck: logical to indicate if the junctions cross
%   by Aapo Tervonen, 2021

% by default there is no crossing
crossCheck = true;

% initialize variables for the check
previousPossiblyBad = 0;
nextPossiblyBad = 0;
nextPairCell = [];
nextPairVertex = [];
prevPairCell = [];
prevPairVertex = [];
previousPossiblyBad2 = 0;
nextPossiblyBad2 = 0;
nextPairCell2 = [];
nextPairVertex2 = [];
prevPairCell2 = [];
prevPairVertex2 = [];

% finds the indices of the linked vertices in cell k (and remove the
% current vertex)
tempVertexStates = cells(currentCell).vertexStates;
linkedInds = find(tempVertexStates > 0);
linkedInds(linkedInds == currentVertex) = [];

% there are linked vertices
if numel(linkedInds) ~= 0
    
    % if current vertex is between the lowest and highest linked indices
    if currentVertex > max(linkedInds) || currentVertex < min(linkedInds)
        
        % previous junction is the one with maximum index
        prevLinkedInd = max(linkedInds);
        
        % next junction is the one with minimum index
        nextLinkedIdx = min(linkedInds);
        
        % find the distance to both vertices
        if currentVertex > max(linkedInds)
            closestPrevDist = currentVertex - prevLinkedInd;
            closestNextDist = cells(currentCell).nVertices - currentVertex + nextLinkedIdx;
        else
            closestPrevDist = cells(currentCell).nVertices - prevLinkedInd + currentVertex;
            closestNextDist = nextLinkedIdx - currentVertex;
        end
        
        % if the closest right side junction is closer than 4 vertices
        if closestPrevDist < 4
            
            % there is a junction that may affect the new junction on
            % the right
            previousPossiblyBad = 1;
            
            % get the index data on the right side junction
            prevPairCell = cells(currentCell).junctions.cells(prevLinkedInd,1);
            prevPairVertex = cells(currentCell).junctions.vertices(prevLinkedInd,1);
            
            % if is closest right side junction vertex also has another
            % junction
            if tempVertexStates(prevLinkedInd) == 2
                
                % there is another junction that may affect the new
                % junction on the right
                previousPossiblyBad2 = 1;
                
                % get the index data on the other right side junction
                prevPairCell2 = cells(currentCell).junctions.cells(prevLinkedInd,2);
                prevPairVertex2 = cells(currentCell).junctions.vertices(prevLinkedInd,2);
            end
        end
        
        % if the closest left side junction is closer than 4 vertices
        if closestNextDist < 4
            
            % there is a junction that may affect the new junction on
            % the left
            nextPossiblyBad = 1;
            
            % get the index data on the left side junction
            nextPairCell = cells(currentCell).junctions.cells(nextLinkedIdx);
            nextPairVertex = cells(currentCell).junctions.vertices(nextLinkedIdx);
            
            % if is closest left side junction vertex also has another
            % junction
            if tempVertexStates(nextLinkedIdx) == 2
                
                % there is another junction that may affect the new
                % junction on the right
                nextPossiblyBad2 = 1;
                
                % get the index data on the other right side junction
                nextPairCell2 = cells(currentCell).junctions.cells(nextLinkedIdx,2);
                nextPairVertex2 = cells(currentCell).junctions.vertices(nextLinkedIdx,2);
            end
        end
        
        % otherwise
    else
        
        % find the distance between the current vertex and the other linked
        % vertices
        dists = linkedInds - currentVertex;
        
        
        closestPrevDist = max(dists(dists < 0));
        
        % if the distance is more less than 4
        if closestPrevDist > -4
            
            % there is a junction that may affect the new junction on
            % the right
            previousPossiblyBad = 1;
            
            % find the closest right side junction vertex index
            prevLinkedInd = linkedInds(dists == closestPrevDist);
            
            % get the index data on the right side junction
            prevPairCell = cells(currentCell).junctions.cells(prevLinkedInd,1);
            prevPairVertex = cells(currentCell).junctions.vertices(prevLinkedInd,1);
            
            % if is closest right side junction vertex also has another
            % junction
            if tempVertexStates(prevLinkedInd) == 2
                
                % there is another junction that may affect the new
                % junction on the right
                previousPossiblyBad2 = 1;
                
                % get the index data on the other right side junction
                prevPairCell2 = cells(currentCell).junctions.cells(prevLinkedInd,2);
                prevPairVertex2 = cells(currentCell).junctions.vertices(prevLinkedInd,2);
            end
        end
        
        % find the closest distance on right side (smaller positive
        % distance)
        closestNextDist = min(dists(dists > 0));
        
        % if the closest left side junction is closer than 4 vertices
        if closestNextDist < 4
            
            % there is a junction that may affect the new junction on
            % the left
            nextPossiblyBad = 1;
            
            % find the closest left side junction vertex index
            nextLinkedIdx = linkedInds(dists == closestNextDist);
            
            % get the index data on the left side junction
            nextPairCell = cells(currentCell).junctions.cells(nextLinkedIdx,1);
            nextPairVertex = cells(currentCell).junctions.vertices(nextLinkedIdx,1);
            
            % if is closest left side junction vertex also has another
            % junction
            if tempVertexStates(nextLinkedIdx) == 2
                
                % there is another junction that may affect the new
                % junction on the left
                nextPossiblyBad2 = 1;
                
                % get the index data on the other left side junction
                nextPairCell2 = cells(currentCell).junctions.cells(nextLinkedIdx,2);
                nextPairVertex2 = cells(currentCell).junctions.vertices(nextLinkedIdx,2);
            end
        end
    end
end

% if there are junctions on both sides of the current vertex, check if the
% they junctions are connected on the same cell and have indices smaller
% and higher than the possible pair (i.e. if the new junction is formed in
% a area between two cells and not near junction between three cells)
if numel(nextPairCell) > 0 && numel(prevPairCell) > 0 && nextPairCell == prevPairCell && nextPairVertex < pairVertex && prevPairVertex > pairVertex && prevPairCell == pairCell
    return
end

% coordinates of current vertex
vertexX = cells(currentCell).verticesX(currentVertex);
vertexY = cells(currentCell).verticesY(currentVertex);

% coordinates of possible pair vertex
pairX = cells(pairCell).verticesX(pairVertex);
pairY = cells(pairCell).verticesY(pairVertex);

% checks that there is a right side junction
if previousPossiblyBad
    
    % coordinates of the right sidejunction vertex
    previousVertexX = cells(currentCell).verticesX(prevLinkedInd);
    previousVertexY = cells(currentCell).verticesY(prevLinkedInd);
    
    % coodinates of the right side vertexes pair
    previousPairX = cells(prevPairCell).verticesX(prevPairVertex);
    previousPairY = cells(prevPairCell).verticesY(prevPairVertex);
    
    % check if the junctions intersect
    crossCheck =  check_line_intersection(vertexX, vertexY, previousVertexX, previousVertexY, pairX, pairY, previousPairX, previousPairY);
end

% if the junction did not cross with the right side junction and there is a
% junction on the left side
if crossCheck && nextPossiblyBad
    
    % coordinates of the next linked vertex
    nextVertexX = cells(currentCell).verticesX(nextLinkedIdx);
    nextVertexY = cells(currentCell).verticesY(nextLinkedIdx);
    
    % coordinates of the next link's pair
    nextPairX = cells(nextPairCell).verticesX(nextPairVertex);
    nextPairY = cells(nextPairCell).verticesY(nextPairVertex);
    
    % check if the junctions intersect
    crossCheck = check_line_intersection(vertexX, vertexY, nextVertexX, nextVertexY, pairX, pairY, nextPairX, nextPairY);
end

% if the junction did not cross with the right or left side junctions and
% there is a second junction on the left side
if crossCheck && previousPossiblyBad2
    
    % coordinates of the previous linked vertex
    previousVertexX = cells(currentCell).verticesX(prevLinkedInd);
    previousVertexY = cells(currentCell).verticesY(prevLinkedInd);
    
    % coodinates of the previous link's pair
    previousPairX = cells(prevPairCell2).verticesX(prevPairVertex2);
    previousPairY = cells(prevPairCell2).verticesY(prevPairVertex2);
    
    % check if the junctions intersect
    crossCheck =  check_line_intersection(vertexX, vertexY, previousVertexX, previousVertexY, pairX, pairY, previousPairX, previousPairY);
end

% if the junction did not cross with the neither of the right junctions or
% the left side junction and there is a second junction on the left side
if crossCheck && nextPossiblyBad2
    
    % coordinates of the next linked vertex
    nextVertexX = cells(currentCell).verticesX(nextLinkedIdx);
    nextVertexY = cells(currentCell).verticesY(nextLinkedIdx);
    
    % coordinates of the next link's pair
    nextPairX = cells(nextPairCell2).verticesX(nextPairVertex2);
    nextPairY = cells(nextPairCell2).verticesY(nextPairVertex2);
    
    % check if the junctions intersect
    crossCheck = check_line_intersection(vertexX,vertexY,nextVertexX,nextVertexY,pairX,pairY,nextPairX,nextPairY);
end

end
