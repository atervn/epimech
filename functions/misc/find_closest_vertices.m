function d = find_closest_vertices(d)
% FIND_CLOSEST_VERTICES Find the closest vertices in other cells for each
% vertex
%   The function finds the closest vertices in the neighboring cells for
%   each vertex used both for the contact force and the formation of new
%   junctions. New junctions are only created at certain time point or
%   following certain events.
%   INPUTS:
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% number of cells
nCells = size(d.cells,2);

% vectors used to find unique neighbors
cellNumbers = 1:nCells;
zeroVec = zeros(size(cellNumbers));

% initialize vectors for the cell centers and radii
cellCentersX = zeros(size(d.cells,2),1);
cellCentersY = cellCentersX;
cellMaxRadii = cellCentersX;

% get the cell center coordinates and the maximum radii for each cell
for k = 1:nCells
    cellCentersX(k) = sum(d.cells(k).verticesX)/d.cells(k).nVertices;
    cellCentersY(k) = sum(d.cells(k).verticesY)/d.cells(k).nVertices;
    cellMaxRadii(k) = sqrt(max((d.cells(k).verticesX - cellCentersX(k)).^2 + (d.cells(k).verticesY - cellCentersY(k)).^2));
end

% if frame simulation, remove the frame cell
if d.simset.simulationType == 4
    nCells = nCells-1;
end

% if pointlike simulation, find the unique neighbors of the pointlike cell
if d.simset.simulationType == 2
    pointlikeNeigbors = [d.cells(d.simset.pointlike.cell).junctions.linked2CellNumbers1 ; d.cells(d.simset.pointlike.cell).junctions.linked2CellNumbers2];
    pointlikeAndNeighbors = [d.simset.pointlike.cell find(accumarray(pointlikeNeigbors,1))'];%(pointlikeNeigbors,cellNumbers,zeroVec)];
end

% set the maximum squared vertex search radius
maxDist = (d.spar.junctionLength*3).^2;

% go through the cells
for k = 1:nCells
        
    % set the default value of contacts present
    d.cells(k).contacts.present = false;
    
    % if pointlike simulation and k is either pointlike cell or its
    % neighbor, have large vertex search radius
    if d.simset.simulationType == 2
        if any(k == pointlikeAndNeighbors)
            maxDist = (d.spar.junctionLength*6).^2;
        else
            maxDist = (d.spar.junctionLength*3).^2;
        end
    end
    
    % calculate the a squared distances between cell k and all the other cells
    cellDistancesSq = (cellCentersX(k) - cellCentersX).^2 + (cellCentersY(k) - cellCentersY).^2;
    
    % find cells that are close
    neighboringCells = find(cellDistancesSq < (1.1.*cellMaxRadii(k) + 1.1.*cellMaxRadii + d.spar.junctionLength).^2);
    
    % if frame simulation and the frame cell is a neighbor (the last cell)
    if d.simset.simulationType == 4 && any(neighboringCells == nCells)
        
        % coordinate of one of the corners (symmetric, so this describes
        % all corners in both directions)
        corner = d.cells(end).verticesX(1);
        
        % remove cells that are not close enough to the frame wall
        if ~(abs(corner - cellCentersX(k)) < cellMaxRadii(k)*1.1 || abs(-corner - cellCentersX(k)) < cellMaxRadii(k)*1.1 || abs(corner - cellCentersY(k)) < cellMaxRadii(k)*1.1 || abs(-corner - cellCentersY(k)) < cellMaxRadii(k)*1.1)
            neighboringCells(end) = [];
        end
    end
    
    % remove the cell itself from close cells
    neighboringCells(neighboringCells == k) = [];
    
    % if there are neighboring cells
    if numel(neighboringCells)> 0
        
        % initialize vectors for the IDs and coordinates for the vertices
        % in the suitable cells
        pairCells = [];
        pairVertices = [];
        pairVerticesX = [];
        pairVerticesY = [];
        
        % go through the neighboring cells and get their vertices and
        % coordinates
        for k2 = neighboringCells'
            pairCells = [pairCells ; k2.*ones(d.cells(k2).nVertices,1)];  %#ok<*AGROW>
            pairVertices = [pairVertices ; (1:d.cells(k2).nVertices)'];
            pairVerticesX = [pairVerticesX ; d.cells(k2).verticesX];
            pairVerticesY = [pairVerticesY ; d.cells(k2).verticesY];
        end
             
        % get the indices of the possible pair vertices that are too far
        % away from the center of cell k (1.1 times the cell max radius
        % plus 3 times the junction length
        tooFar = ((pairVerticesX - cellCentersX(k)).^2) + (pairVerticesY - cellCentersY(k)).^2 > 1.1*cellMaxRadii(k) + d.spar.junctionLength*3;
        
        % remove too far vertices from the possible pairs
        pairCells(tooFar) = [];
        pairVertices(tooFar) = [];
        pairVerticesX(tooFar) = [];
        pairVerticesY(tooFar) = [];

        % get the squared distance matrix between the pairvertices (rows)
        % and the vertices of cell k (columns)
        vertexDistancesSq  = (pairVerticesX - d.cells(k).verticesX').^2 + (pairVerticesY - d.cells(k).verticesY').^2;
        
        % find the pairs that are close enough
        possibleInteractions = vertexDistancesSq < maxDist;
        
        % get the vertices that have at least one possible
        % interaction
        atLeastOne = (sum(possibleInteractions,1) > 0)';
        
        % save the indices with at least one contact
        d.cells(k).contacts.atLeastOne = atLeastOne;
        
        % get the indices of the vertices with at least one interaction
        atLeastOneIdx = find(atLeastOne);

        % set the too far square distances to NaN
        vertexDistancesSq(~possibleInteractions) = nan;
            
        % sort the square distances for each vertex and get the sorted
        % indices
        [sortedDistancesSq,sortedIdx] = sort(vertexDistancesSq(:,atLeastOne),1);
     
        % find the maximum number possible interaction for the vertices
        % plus one (or the maximum if all interactions are possible for
        % some vertex
        maxPossible = min([max(sum(~isnan(sortedDistancesSq),1))+1,size(sortedDistancesSq,1)]);
        
        % remove the extra part of the sortedDistancesSq matrix
        sortedDistancesSq = sortedDistancesSq(1:maxPossible,:);
           
        % get the indices of NaNs only for the vertices with at least one
        % interaction in the sortedDistancesSq matrix
        areNans = isnan(sortedDistancesSq);
           
        % get the number of vertices with at least one interactions
        numberOfAtLeastOne = length(atLeastOneIdx); 
        
        % get the number of pair cells
        numberOfPossiblePairVertices = length(pairCells);
        
        % make matrices with the pair cell and vertex indices corresponding
        % to each possible junction in the sortedDistancesSq matrix
        pairCells = repmat(pairCells,1,numberOfAtLeastOne);
        pairVertices = repmat(pairVertices,1,numberOfAtLeastOne);
            
        % get the sorted linear indices of the possible pairs only for the
        % vertices with at least one interaction
        sortedIdx2 = sortedIdx + (repmat(1:numberOfAtLeastOne,numberOfPossiblePairVertices,1) - 1).*numberOfPossiblePairVertices;
        
        % sort the pairCells and pairVertices so that they are according to
        % their closeness for each vertex with at least one interaction
        pairCells = pairCells(sortedIdx2);
        pairVertices = pairVertices(sortedIdx2);
        
        % remove the extra part of the matrix    
        pairCells = pairCells(1:maxPossible,:);
        pairVertices = pairVertices(1:maxPossible,:);
        
        % pairCells with zeros for all interactions that are not
        % possible
        pairCellsZeros = pairCells;
        pairCellsZeros(areNans) = 0;
        
        % insert NaNs for all interactions that are not possible
        pairCells(areNans) = nan;
        
        % find the closest neighboring vertex for each vertex with at least
        % one interaction
        closestCells1 = pairCells(1,:);
        closestVertices1 = pairVertices(1,:);
        
        % get the previous vertices for each of the closest neighboring
        % vertices
        previousVertices1 = closestVertices1-1;
        
        % if closest vertex is 1, get the last vertex for that cell
        firstVertices = find(closestVertices1 == 1);
        for i = firstVertices
            previousVertices1(i) = d.cells(closestCells1(i)).nVertices;
        end
        
        % get the differences between closest cells to find from how many
        % cells the closest interactions are
        cellDifference = (pairCellsZeros(1:end-1,:)-pairCellsZeros(2:end,:));
        
        % find the indices of the vertices indices with at least one 
        % possible interaction that can interact with two different cells
        cellDifferenceNotZero = cellDifference~=0;
        atLeastTwo = find(sum(cellDifferenceNotZero,1) > 1);
        
        % get the linear indices of the rows of the second interaction in
        % the pairCells and pairVertices matrices (the first line only gets
        % the rows - 1, so + 1 is added)
        [~, pair2Rows] = max(cellDifferenceNotZero(:,atLeastTwo), [], 1);
        pair2Idx = pair2Rows + (atLeastTwo-1).*size(pairCells,1) + 1;
        
        % find the second closest neighboring vertex for each vertex with
        % at least two interactions
        closestCells2 = pairCells(pair2Idx);
        closestVertices2 = pairVertices(pair2Idx);
        
        % get the previous vertices for each of the second closest
        % neighboring vertices
        previousVertices2 = closestVertices2 - 1;
        firstVertices = find(closestVertices2 == 1);
        for i = firstVertices
            previousVertices2(i) = d.cells(closestCells2(i)).nVertices;
        end
            
        % intialize the vectors for the closest pair coordinates       
        leftSegmentX = zeros(numberOfAtLeastOne,1);
        leftSegmentY = leftSegmentX;
        rightSegmentX = leftSegmentX;
        rightSegmentY = leftSegmentX;
        leftSegmentLength = leftSegmentX;
        rightSegmentLength = leftSegmentX;
        leftSegmentVectorX = leftSegmentX;
        leftSegmentVectorY = leftSegmentX;
        rightSegmentVectorX = leftSegmentX;
        rightSegmentVectorY = leftSegmentX;
        
        % if there are close cells
        if numel(closestCells1)
            
            % get the unique neighbors
            neighboringCells = find(accumarray(closestCells1',1))';%get_uniques(closestCells1,cellNumbers,zeroVec);
            
            % go through the neighbors
            for k2 = neighboringCells
                
                % find the vertex indices in contact with the other cell
                verticesIdx = closestCells1 == k2;
                
                % get the pair vertex indices
                tempIdx = closestVertices1(verticesIdx);
                
                % get the coordinates, left vectors, and left vector
                % lengths of the closest pair vertex
                leftSegmentX(verticesIdx) = d.cells(k2).verticesX(tempIdx);
                leftSegmentY(verticesIdx) = d.cells(k2).verticesY(tempIdx);
                leftSegmentLength(verticesIdx) = d.cells(k2).leftLengths(tempIdx);
                leftSegmentVectorX(verticesIdx) = d.cells(k2).leftVectorsX(tempIdx);
                leftSegmentVectorY(verticesIdx) = d.cells(k2).leftVectorsY(tempIdx);
                
                % get the indices of the vertex previous to (right to) the
                % closest pair vertex
                tempIdx = previousVertices1(verticesIdx);
                
                % get coordinates, left vectors, and left vector lengths of
                % the previous vertex
                rightSegmentX(verticesIdx) = d.cells(k2).verticesX(tempIdx);
                rightSegmentY(verticesIdx) = d.cells(k2).verticesY(tempIdx);
                rightSegmentLength(verticesIdx) = d.cells(k2).leftLengths(tempIdx);
                rightSegmentVectorX(verticesIdx) = d.cells(k2).leftVectorsX(tempIdx);
                rightSegmentVectorY(verticesIdx) = d.cells(k2).leftVectorsY(tempIdx);
                
            end
        end
        
        % get the projections between vertices with at least one
        % interaction and the membrane segments on each side of the closest
        % pair vertex
        projectionRight = ((d.cells(k).verticesX(atLeastOneIdx) - rightSegmentX).*rightSegmentVectorX + (d.cells(k).verticesY(atLeastOneIdx) - rightSegmentY).*rightSegmentVectorY)./rightSegmentLength.^2;
        projectionLeft = ((d.cells(k).verticesX(atLeastOneIdx) - leftSegmentX).*leftSegmentVectorX + (d.cells(k).verticesY(atLeastOneIdx) - leftSegmentY).*leftSegmentVectorY)./leftSegmentLength.^2;
        
        % check if the projections are on the membrane segments
        betweenVerticesRight =  and(0 <= projectionRight, projectionRight <= 1);
        betweenVerticesLeft =  and(0 <= projectionLeft, projectionLeft <= 1);   
        
        % save the information on the vertices whose projection is on the
        % right segment of the closest vertex
        prev.vertices = atLeastOneIdx(betweenVerticesRight);
        prev.present = ~isempty(prev.vertices);
        if prev.present
            prev.pairCellIDs = closestCells1(betweenVerticesRight);
            prev.pairVertexIDs = previousVertices1(betweenVerticesRight);
            prev.pairVerticesX = rightSegmentX(betweenVerticesRight);
            prev.pairVerticesY = rightSegmentY(betweenVerticesRight);
            prev.pairVectorsX = rightSegmentVectorX(betweenVerticesRight);
            prev.pairVectorsY = rightSegmentVectorY(betweenVerticesRight);
            prev.lengths = rightSegmentLength(betweenVerticesRight);

            % get the unique cells
            prev.pairCells = find(accumarray(prev.pairCellIDs',1))';%get_uniques(prev.pairCellIDs,cellNumbers,zeroVec);
        end
        d.cells(k).contacts.cell1.prev = prev;
        
        % save the information on the vertices whose projection is on the
        % left segment of the closest vertex
        next.vertices = atLeastOneIdx(betweenVerticesLeft);
        next.present = ~isempty(next.vertices);
        if next.present
            next.pairCellIDs = closestCells1(betweenVerticesLeft);
            next.pairVertexIDs = closestVertices1(betweenVerticesLeft);
            next.pairVerticesX = leftSegmentX(betweenVerticesLeft);
            next.pairVerticesY = leftSegmentY(betweenVerticesLeft);
            next.pairVectorsX = leftSegmentVectorX(betweenVerticesLeft);
            next.pairVectorsY = leftSegmentVectorY(betweenVerticesLeft);
            next.lengths = leftSegmentLength(betweenVerticesLeft);
            
            % get the unique cells
            next.pairCells = find(accumarray(next.pairCellIDs',1))';%get_uniques(next.pairCellIDs,cellNumbers,zeroVec);
        end
        d.cells(k).contacts.cell1.next = next;
        
        % find the vertices whose projection is not neither of the membrane
        % segments
        neither = ~or(betweenVerticesRight,betweenVerticesLeft);
        
        % save the information on the vertices whose projection is not on
        % either of the segments neighboring the closest vertex
        vertex.vertices = atLeastOneIdx(neither);
        vertex.present = ~isempty(vertex.vertices);
        if vertex.present
            vertex.pairCellIDs = closestCells1(neither);
            vertex.pairVertexIDs = closestVertices1(neither);
            vertex.pairVerticesX = leftSegmentX(neither);
            vertex.pairVerticesY = leftSegmentY(neither);
            
            % get the unique cells
            vertex.pairCells = find(accumarray(vertex.pairCellIDs',1))';%get_uniques(vertex.pairCellIDs,cellNumbers,zeroVec);
        end
        d.cells(k).contacts.cell1.vertex = vertex;

        % get the indices of the vertices with at least two interactions
        atLeastTwo = atLeastOneIdx(atLeastTwo);
        
        % if they exist
        if any(atLeastTwo)
            
            % intialize the vectors for the pair coordinates
            leftSegmentX = zeros(length(atLeastTwo),1);
            leftSegmentY = leftSegmentX;
            rightSegmentX = leftSegmentX;
            rightSegmentY = leftSegmentX;
            leftSegmentLength = leftSegmentX;
            rightSegmentLength = leftSegmentX;
            leftSegmentVectorX = leftSegmentX;
            leftSegmentVectorY = leftSegmentX;
            rightSegmentVectorX = leftSegmentX;
            rightSegmentVectorY = leftSegmentX;
       
            % get nonzero closest vertex indices
            closestCells2 = nonzeros(closestCells2);
            closestVertices2 = nonzeros(closestVertices2);
            previousVertices2 = nonzeros(previousVertices2);
            
            % if they exist
            if numel(closestCells2)
                
                % get the unique neighbors
                neighboringCells = find(accumarray(closestCells2,1))';%get_uniques(closestCells2,cellNumbers,zeroVec);

                % go through the neighbors
                for k2 = neighboringCells
                    
                    % find the vertex indices in contact with the other cell
                    verticesIdx = closestCells2 == k2;
                    
                    % get the pair vertex indices
                    tempIdx = closestVertices2(verticesIdx);
                    
                    % get the coordinates, left vectors, and left vector
                    % lengths of the closest pair vertex
                    leftSegmentX(verticesIdx) = d.cells(k2).verticesX(tempIdx);
                    leftSegmentY(verticesIdx) = d.cells(k2).verticesY(tempIdx);
                    leftSegmentLength(verticesIdx) = d.cells(k2).leftLengths(tempIdx);
                    leftSegmentVectorX(verticesIdx) = d.cells(k2).leftVectorsX(tempIdx);
                    leftSegmentVectorY(verticesIdx) = d.cells(k2).leftVectorsY(tempIdx);
                    
                    % get the indices of the vertex right to the
                    % closest pair vertex
                    tempIdx = previousVertices2(verticesIdx);
                    
                    % get coordinates, left vectors, and left vector
                    % lengths of the previous vertex
                    rightSegmentX(verticesIdx) = d.cells(k2).verticesX(tempIdx);
                    rightSegmentY(verticesIdx) = d.cells(k2).verticesY(tempIdx);
                    rightSegmentLength(verticesIdx) = d.cells(k2).leftLengths(tempIdx);
                    rightSegmentVectorX(verticesIdx) = d.cells(k2).leftVectorsX(tempIdx);
                    rightSegmentVectorY(verticesIdx) = d.cells(k2).leftVectorsY(tempIdx);
                end
            end
            
            % get the projections between vertices with at least two
            % interaction and the membrane segments on each side of the
            % closest pair vertex
            projectionRight = ((d.cells(k).verticesX(atLeastTwo) - rightSegmentX).*rightSegmentVectorX + (d.cells(k).verticesY(atLeastTwo) - rightSegmentY).*rightSegmentVectorY)./rightSegmentLength.^2;
            projectionLeft = ((d.cells(k).verticesX(atLeastTwo) - leftSegmentX).*leftSegmentVectorX + (d.cells(k).verticesY(atLeastTwo) - leftSegmentY).*leftSegmentVectorY)./leftSegmentLength.^2;
            
            % check if the projections are on the membrane segments
            betweenVerticesRight = and(0 <= projectionRight, projectionRight <= 1);
            betweenVerticesLeft = and(0 <= projectionLeft, projectionLeft <= 1);
            
            % save the information on the vertices whose projection is on the
            % previous segment of the closest vertex
            prev.vertices = atLeastTwo(betweenVerticesRight);
            prev.present = ~isempty(prev.vertices);
            if prev.present
                prev.pairCellIDs = closestCells2(betweenVerticesRight);
                prev.pairVertexIDs = previousVertices2(betweenVerticesRight);
                prev.pairVerticesX = rightSegmentX(betweenVerticesRight);
                prev.pairVerticesY = rightSegmentY(betweenVerticesRight);
                prev.pairVectorsX = rightSegmentVectorX(betweenVerticesRight);
                prev.pairVectorsY = rightSegmentVectorY(betweenVerticesRight);
                prev.lengths = rightSegmentLength(betweenVerticesRight);
                
                % get the unique cells
                prev.pairCells = find(accumarray(prev.pairCellIDs,1))';%get_uniques(prev.pairCellIDs,cellNumbers,zeroVec);
            else
                prev.pairCellIDs = [];
                prev.pairVertexIDs = [];
                prev.pairCells = [];
            end
            d.cells(k).contacts.cell2.prev = prev;
            
            % save the information on the vertices whose projection is on the
            % next segment of the closest vertex
            next.vertices = atLeastTwo(betweenVerticesLeft);
            next.present = ~isempty(next.vertices);
            if next.present
                next.pairCellIDs = closestCells2(betweenVerticesLeft);
                next.pairVertexIDs = closestVertices2(betweenVerticesLeft);
                next.pairVerticesX = leftSegmentX(betweenVerticesLeft);
                next.pairVerticesY = leftSegmentY(betweenVerticesLeft);
                next.pairVectorsX = leftSegmentVectorX(betweenVerticesLeft);
                next.pairVectorsY = leftSegmentVectorY(betweenVerticesLeft);
                next.lengths = leftSegmentLength(betweenVerticesLeft);
                
                % get the unique cells
                next.pairCells = find(accumarray(next.pairCellIDs,1))';%get_uniques(next.pairCellIDs,cellNumbers,zeroVec);
            else
                next.pairCellIDs = [];
                next.pairVertexIDs = [];
                next.pairCells = [];
            end
            d.cells(k).contacts.cell2.next = next;
            
            % find the vertices whose projection is not neither of the membrane
            % segments
            neither = ~or(betweenVerticesRight,betweenVerticesLeft);
            
            % save the information on the vertices whose projection is not on
            % either of the segments neighboring the closest vertex
            vertex.vertices = atLeastTwo(neither);
            vertex.present = ~isempty(vertex.vertices);
            if vertex.present
                vertex.pairCellIDs = closestCells2(neither);
                vertex.pairVertexIDs = closestVertices2(neither);
                vertex.pairVerticesX = leftSegmentX(neither);
                vertex.pairVerticesY = leftSegmentY(neither);
                
                % get the unique cells
                vertex.pairCells = find(accumarray(vertex.pairCellIDs,1))';%get_uniques(vertex.pairCellIDs,cellNumbers,zeroVec);
            else
                vertex.pairCellIDs = [];
                vertex.pairVertexIDs = [];
                vertex.pairCells = [];
            end
            d.cells(k).contacts.cell2.vertex = vertex;
            
        else
            % if no contacts with second cells
            d.cells(k).contacts.cell2.prev.present = false;
            d.cells(k).contacts.cell2.next.present = false;
            d.cells(k).contacts.cell2.vertex.present = false;
        end
        
        % if there are any contacts, set contacts present to true
        if d.cells(k).contacts.cell1.prev.present || d.cells(k).contacts.cell1.next.present || d.cells(k).contacts.cell1.vertex.present || d.cells(k).contacts.cell2.prev.present || d.cells(k).contacts.cell2.next.present || d.cells(k).contacts.cell2.vertex.present
            d.cells(k).contacts.present = true;
        end

        % if junctions are updated
        if d.simset.junctionModification
            
            % save the vertex indices with possible new junctions (vertices
            % that have no junctions or one junction and that have at least
            % one close vertex in other cells
            d.cells(k).junctions.possible.vertices = find(and(atLeastOne,or(d.cells(k).vertexStates == 0,d.cells(k).vertexStates == 1)));
            
            % get the vertices that have at least one possible new junction
            % that can form new junctions
            possibleJunctionsOfAtLeastOneIdx = or(d.cells(k).vertexStates(atLeastOne) == 0, d.cells(k).vertexStates(atLeastOne) == 1);
            
            % get the pair vertex and cell indices for those vertices
            d.cells(k).junctions.possible.pairCellIDs = pairCells(:,possibleJunctionsOfAtLeastOneIdx);
            d.cells(k).junctions.possible.pairVertexIDs = pairVertices(:,possibleJunctionsOfAtLeastOneIdx);
            
            % get the pair cells of the vertices that already have a single
            % junction and that have at least one possible new junction so
            % that we can rule the cases where vertex would have a junction
            % with two vertices in the same neighboring cell)
            existingJunctionPairCells = d.cells(k).junctions.cells(find((d.cells(k).vertexStates == 1).*atLeastOne),1)';
            
            % get the indices of the vertices of the new possible junctions
            % that already have a single junction
            existingJunctionsOfAtLeastOneIdx = nonzeros(cumsum(possibleJunctionsOfAtLeastOneIdx).*(d.cells(k).vertexStates(atLeastOne) == 1));
            
            % get the size of the possible junction pair matrix
            pairMatrixSize = size(d.cells(k).junctions.possible.pairCellIDs);
            
            % find the indices of the vertices with new possible junctions
            % that already have a junction and the closest pair vertex is
            % in the same cell as the existing junction vertex pair
            sameCellIdx = d.cells(k).junctions.possible.pairCellIDs(:,existingJunctionsOfAtLeastOneIdx) == repmat(existingJunctionPairCells,pairMatrixSize(1),1);
            
            % find the rows of the same cells
            [sameCellRows,~] = find(sameCellIdx);
            
            % find the columns of the same cells
            sameCellColumns = repmat(existingJunctionsOfAtLeastOneIdx',pairMatrixSize(1),1);
            sameCellColumns = sameCellColumns(:);
            
            % make sameCellIdx linear
            sameCellIdx = sameCellIdx(:);
            
            % remove the columns that are not same cells
            sameCellColumns(sameCellIdx == 0) = [];
            
            % get the linear indices of the interactions with same cells
            sameCellIdx = sub2ind(pairMatrixSize,sameCellRows,sameCellColumns);
            
            % set the same cell interactions to NaN
            d.cells(k).junctions.possible.pairCellIDs(sameCellIdx) = nan;
            
            % find the at least one possible junction indices that are full
            % of NaNs (can only form new junctions with the same cell with
            % which they are already connected with)
            fullNans = find(sum(~isnan(d.cells(k).junctions.possible.pairCellIDs),1) == 0);
            
            % get the indices of the possibleJunctionsOfAtLeastOneIdx
            possibleJunctionsOfAtLeastOneIdx = find(possibleJunctionsOfAtLeastOneIdx);
            
            % remove all the information of the vertices that could only
            % connect to the same cell which they are already connected to
            if numel(fullNans)
                d.cells(k).junctions.possible.vertices(fullNans) = [];
                d.cells(k).junctions.possible.pairCellIDs(:,fullNans) = [];
                d.cells(k).junctions.possible.pairVertexIDs(:,fullNans) = [];
                possibleJunctionsOfAtLeastOneIdx(fullNans) = [];
            end
            
            % get the squared distances of the remaining vertices
            d.cells(k).junctions.possible.distances = sortedDistancesSq(:,possibleJunctionsOfAtLeastOneIdx);
            
            % get the number of vertices with possible new junctions
            nPossibleJunctions = length(possibleJunctionsOfAtLeastOneIdx);
            
            % repmat the pair vertex coorindates
            pairVerticesX = repmat(pairVerticesX,1,nPossibleJunctions);
            pairVerticesY = repmat(pairVerticesY,1,nPossibleJunctions);
            
            % get the linear indices closest vertices of the remaining 
            % vertices that can form new junctions
            sortedIdx2 = sortedIdx(:,possibleJunctionsOfAtLeastOneIdx) + (repmat(1:nPossibleJunctions,numberOfPossiblePairVertices,1) - 1).*numberOfPossiblePairVertices;
            
            % get the pair coordinates
            pairVerticesX = pairVerticesX(sortedIdx2);
            pairVerticesY = pairVerticesY(sortedIdx2);
            
            % remove the extra bits and save
            d.cells(k).junctions.possible.pairVerticesX = pairVerticesX(1:maxPossible,:);
            d.cells(k).junctions.possible.pairVerticesY = pairVerticesY(1:maxPossible,:);
        end
        
    end
    
    % if the cell is in cytokinesis (state = 2)
    if d.cells(k).division.state == 2
        
        % find the closest vertices in the same cell around the division
        % vertices
        d = find_closest_vertices_division(d, k);
    end
end

end