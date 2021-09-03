function crossCheck = check_junction_crossing(cells,currentCell,currentVertex,pairCell,pairVertex)

crossCheck = 1;

previousBad = 0;
nextBad = 0; 
nextPairCell = [];
nextPairVertex = [];
prevPairCell = [];
prevPairVertex = [];
previous2Bad = 0;
next2Bad = 0; 
next2PairCell = [];
next2PairVertex = [];
prev2PairCell = [];
prev2PairVertex = [];

% finds the indices of the linked vertices in cell k
tempVertexStates = cells(currentCell).vertexStates;
linkedInds = find(tempVertexStates > 0);
linkedInds(linkedInds == currentVertex) = [];
% checks that there are linked vertices
if numel(linkedInds) ~= 0
    
    % if vertex i is between the smallest and largest linked indices
    if currentVertex > max(linkedInds)
        
        % previous link is the one with maximum index
        prevLinkedInd = max(linkedInds);
        
        % next link is the one with minimum index
        nextLinkedIdx = min(linkedInds);
        
        closestPrevDist = currentVertex - prevLinkedInd;
        closestNextDist = cells(currentCell).nVertices - currentVertex + nextLinkedIdx;
        
        if closestPrevDist < 4
             previousBad = 1;
             prevPairCell = cells(currentCell).junctions.cells(prevLinkedInd,1);
             prevPairVertex = cells(currentCell).junctions.vertices(prevLinkedInd,1);
             if tempVertexStates(prevLinkedInd) == 2
                 previous2Bad = 1;
                 prev2PairCell = cells(currentCell).junctions.cells(prevLinkedInd,2);
                 prev2PairVertex = cells(currentCell).junctions.vertices(prevLinkedInd,2);
             end
        end
        
        if closestNextDist < 4
            nextBad = 1;
            nextPairCell = cells(currentCell).junctions.cells(nextLinkedIdx);
            nextPairVertex = cells(currentCell).junctions.vertices(nextLinkedIdx);
            if tempVertexStates(nextLinkedIdx) == 2
                next2Bad = 1;
                next2PairCell = cells(currentCell).junctions.cells(nextLinkedIdx,2);
                next2PairVertex = cells(currentCell).junctions.vertices(nextLinkedIdx,2);
            end
        end
        
    elseif currentVertex < min(linkedInds)
        
        % previous link is the one with maximum index
        prevLinkedInd = max(linkedInds);
        
        % next link is the one with minimum index
        nextLinkedIdx = min(linkedInds);
        
        closestPrevDist = cells(currentCell).nVertices - prevLinkedInd + currentVertex;
        closestNextDist = nextLinkedIdx - currentVertex;

        if closestPrevDist < 4
             previousBad = 1;
             prevPairCell = cells(currentCell).junctions.cells(prevLinkedInd,1);
             prevPairVertex = cells(currentCell).junctions.vertices(prevLinkedInd,1);
             if tempVertexStates(prevLinkedInd) == 2
                 previous2Bad = 1;
                 prev2PairCell = cells(currentCell).junctions.cells(prevLinkedInd,2);
                 prev2PairVertex = cells(currentCell).junctions.vertices(prevLinkedInd,2);
             end
        end
        
        if closestNextDist < 4
            nextBad = 1;
            nextPairCell = cells(currentCell).junctions.cells(nextLinkedIdx);
            nextPairVertex = cells(currentCell).junctions.vertices(nextLinkedIdx);
            if tempVertexStates(nextLinkedIdx) == 2
                next2Bad = 1;
                next2PairCell = cells(currentCell).junctions.cells(nextLinkedIdx,2);
                next2PairVertex = cells(currentCell).junctions.vertices(nextLinkedIdx,2);
            end
        end
        
        
    % otherwise
    else
        
        dists = linkedInds - currentVertex;
        
        closestPrevDist = max(dists(dists < 0));
        if closestPrevDist > -4
            previousBad = 1;
            closestPrevDist = dists == closestPrevDist;
            prevLinkedInd = linkedInds(closestPrevDist);
            prevPairCell = cells(currentCell).junctions.cells(prevLinkedInd,1);
            prevPairVertex = cells(currentCell).junctions.vertices(prevLinkedInd,1);
            if tempVertexStates(prevLinkedInd) == 2
                previous2Bad = 1;
                prev2PairCell = cells(currentCell).junctions.cells(prevLinkedInd,2);
                prev2PairVertex = cells(currentCell).junctions.vertices(prevLinkedInd,2);
            end
        end
        
        closestNextDist = min(dists(dists > 0));
        if closestNextDist < 4
            nextBad = 1;
            closestNextDist = dists == closestNextDist;
            nextLinkedIdx = linkedInds(closestNextDist);
            nextPairCell = cells(currentCell).junctions.cells(nextLinkedIdx,1);
            nextPairVertex = cells(currentCell).junctions.vertices(nextLinkedIdx,1);
            if tempVertexStates(nextLinkedIdx) == 2
                next2Bad = 1;
                next2PairCell = cells(currentCell).junctions.cells(nextLinkedIdx,2);
                next2PairVertex = cells(currentCell).junctions.vertices(nextLinkedIdx,2);
            end
        end
    end
end

if numel(nextPairCell) > 0 && numel(prevPairCell) > 0 && nextPairCell == prevPairCell && nextPairVertex < pairVertex && prevPairVertex > pairVertex && prevPairCell == pairCell
    return
end

% coordinates of vertex i
vertexX = cells(currentCell).verticesX(currentVertex);
vertexY = cells(currentCell).verticesY(currentVertex);

% coordinates of pair vertex
pairX = cells(pairCell).verticesX(pairVertex);
pairY = cells(pairCell).verticesY(pairVertex);

% checks that there is an previous link
if previousBad
    
    % coordinates of the previous linked vertex
    previousVertexX = cells(currentCell).verticesX(prevLinkedInd);
    previousVertexY = cells(currentCell).verticesY(prevLinkedInd);

    % coodinates of the previous link's pair
    previousPairX = cells(prevPairCell).verticesX(prevPairVertex);
    previousPairY = cells(prevPairCell).verticesY(prevPairVertex);
    
    % Based on: https://se.mathworks.com/matlabcentral/newsreader/view_thread/63430
    crossCheck =  check_line_intersection(vertexX,vertexY,previousVertexX,previousVertexY,pairX,pairY,previousPairX,previousPairY);
end

% if the link intersects with the previous link
if crossCheck && nextBad
    
    
    % coordinates of the next linked vertex
    nextVertexX = cells(currentCell).verticesX(nextLinkedIdx);
    nextVertexY = cells(currentCell).verticesY(nextLinkedIdx);
    
    % coordinates of the next link's pair
    nextPairX = cells(nextPairCell).verticesX(nextPairVertex);
    nextPairY = cells(nextPairCell).verticesY(nextPairVertex);
    
    crossCheck = check_line_intersection(vertexX,vertexY,nextVertexX,nextVertexY,pairX,pairY,nextPairX,nextPairY);
    
end

% checks that there is an previous link
if crossCheck && previous2Bad
    
    % coordinates of the previous linked vertex
    previousVertexX = cells(currentCell).verticesX(prevLinkedInd);
    previousVertexY = cells(currentCell).verticesY(prevLinkedInd);

    % coodinates of the previous link's pair
    previousPairX = cells(prev2PairCell).verticesX(prev2PairVertex);
    previousPairY = cells(prev2PairCell).verticesY(prev2PairVertex);
    
    % Based on: https://se.mathworks.com/matlabcentral/newsreader/view_thread/63430
    crossCheck =  check_line_intersection(vertexX,vertexY,previousVertexX,previousVertexY,pairX,pairY,previousPairX,previousPairY);
end

% if the link intersects with the previous link
if crossCheck && next2Bad
    
    
    % coordinates of the next linked vertex
    nextVertexX = cells(currentCell).verticesX(nextLinkedIdx);
    nextVertexY = cells(currentCell).verticesY(nextLinkedIdx);
    
    % coordinates of the next link's pair
    nextPairX = cells(next2PairCell).verticesX(next2PairVertex);
    nextPairY = cells(next2PairCell).verticesY(next2PairVertex);
    
    crossCheck = check_line_intersection(vertexX,vertexY,nextVertexX,nextVertexY,pairX,pairY,nextPairX,nextPairY);
    
end


end
