function cells = find_closest_vertices(cells, spar, simset)


nCells = size(cells,2);

% create a vector for cell numbers used to find unique neighbors
cellNumbers = 1:nCells;
% create a vector of zeros used by the get unique cells
cellZeroVector = zeros(size(cellNumbers));

% initialize vectors for the cell centers and radii
cellCentersX = zeros(size(cells,2),1);
cellCentersY = zeros(size(cells,2),1);
cellMaxRadii = zeros(size(cells,2),1);

% get the cell center coordinates and the maximum radii for each cell
for k = 1:nCells
    cellCentersX(k) = sum(cells(k).verticesX)/cells(k).nVertices;
    cellCentersY(k) = sum(cells(k).verticesY)/cells(k).nVertices;
    cellMaxRadii(k) = sqrt(max((cells(k).verticesX - cellCentersX(k)).^2 + (cells(k).verticesY - cellCentersY(k)).^2));
end

% if frame simulation, remove the frame cell
if simset.simulationType == 4
    nCells = nCells-1;
end

% if pointlike simulation, find the neighbors of the pointlike cell
if simset.simulationType == 2
    pointlikeNeigbors = [cells(simset.pointlike.cell).junctions.linked2CellNumbers1 ; cells(simset.pointlike.cell).junctions.linked2CellNumbers2];
    vector = cellZeroVector;
    vector(pointlikeNeigbors) = 1;
    pointlikeAndNeighbors = [simset.pointlike.cell cellNumbers(logical(vector(cellNumbers)))];
end

% set the maximum vertex search radius
maxDist = (spar.junctionLength*3).^2;

%% go through the cells
for k = 1:nCells
        
    % set the default value of contacts present
    cells(k).contacts.present = false;
    
    % if pointlike simulation and k is either pointlike cell or its
    % neighbor, have large vertex search radius
    if simset.simulationType == 2
        if any(k == pointlikeAndNeighbors)
            maxDist = (spar.junctionLength*6).^2;
        else
            maxDist = (spar.junctionLength*3).^2;
        end
    end
    
    % calculate the a squared distances between cell k and all the other cells
    cellDistancesSq = (cellCentersX(k) - cellCentersX).^2 + (cellCentersY(k) - cellCentersY).^2;
    
    % find cells that are close enough
    neighboringCells = find(cellDistancesSq < (1.1.*cellMaxRadii(k) + 1.1.*cellMaxRadii + spar.junctionLength).^2);
    
    % if frame simulation
    if simset.simulationType == 4 && neighboringCells(end)
        corner = cells(end).verticesX(1);
        % remove cells that are not close enough to the frame wall
        if ~(abs(corner - cellCentersX(k)) < cellMaxRadii(k)*1.1 || abs(-corner - cellCentersX(k)) < cellMaxRadii(k)*1.1 || abs(corner - cellCentersY(k)) < cellMaxRadii(k)*1.1 || abs(-corner - cellCentersY(k)) < cellMaxRadii(k)*1.1)
            neighboringCells(end) = [];
        end
    end
    
    % remove the cell itself from close cells
    neighboringCells(neighboringCells == k) = [];
    
    % if there are neighboring cells
    if numel(neighboringCells)> 0
        
        % initialize vectors for the IDs and coordinates for the vertices in
        % the suitable cells
        pairCells = [];
        pairVertices = [];
        pairVerticesX = [];
        pairVerticesY = [];
        
        % go through the neighboring cells and get their vertices and their
        % coordinates
        for k2 = neighboringCells'
            pairCells = [pairCells ; k2.*ones(cells(k2).nVertices,1)]; %#ok<*AGROW>
            pairVertices = [pairVertices ; (1:cells(k2).nVertices)']; %#ok<*AGROW>
            
            pairVerticesX = [pairVerticesX ; cells(k2).verticesX];
            pairVerticesY = [pairVerticesY ; cells(k2).verticesY];
        end
        
        % get the indices of the pairs that are too far away from the
        % center of cell k
        tooFar = ((pairVerticesX - cellCentersX(k)).^2) + (pairVerticesY - cellCentersY(k)).^2 > 1.1*cellMaxRadii(k) + spar.junctionLength*3;
        
        % remove too far vertices
        pairCells(tooFar) = [];
        pairVertices(tooFar) = [];
        pairVerticesX(tooFar) = [];
        pairVerticesY(tooFar) = [];

        % get the squared distance matrix between the pairvertices (rows)
        % and the vertices of cell k (columns)
        vertexDistancesSq  = (pairVerticesX - cells(k).verticesX').^2 + (pairVerticesY - cells(k).verticesY').^2;
        
        % find the pairs that are close enough
        possibleInteractions = vertexDistancesSq < maxDist;
        
        % get the vertices that have at least one possible
        % interaction
        atLeastOne = (sum(possibleInteractions,1) > 0)';
        
        % get the indices of the vertices with at least one interaction
        atLeastOneIdx = find(atLeastOne);

        % set too far square distances to NaN
        vertexDistancesSq(~possibleInteractions) = nan;
            
        % sort the square distances for each vertex and get the sorted
        % indices
        [sortedDistancesSq,sortedIdx] = sort(vertexDistancesSq,1);
            
        % find the maximum number possible interaction for the vertices
        % plus one (or the maximum if all interactions are possible for
        % some vertex
        maxPossible = min([max(sum(~isnan(sortedDistancesSq),1))+1,size(sortedDistancesSq,1)]);
        
        % remove the extra part of the sortedDistancesSq matrix
        sortedDistancesSq = sortedDistancesSq(1:maxPossible,:);
           
        % get the indices of NaNs only for the vertices with at least one
        % interaction in the sortedDistancesSq matrix
        areNans = isnan(sortedDistancesSq(:,atLeastOne));
            
        % remove the columns of the vertices with no interactions from the
        % sortedIdx
        sortedIdx = sortedIdx(:,atLeastOne);
           
        % get the number of vertices with at least one interactions
        numberOfAtLeastOne = length(atLeastOneIdx); 
        
        % get the number of pair cells
        numberOfPossiblePairVertices = length(pairCells);
        
        pairCells = repmat(pairCells,1,numberOfAtLeastOne);
        pairVertices = repmat(pairVertices,1,numberOfAtLeastOne);
            
        % get the sorted indices of the possible pairs only for the
        % vertices with at least one interaction
        sortedIdx2 = sortedIdx + (repmat(1:numberOfAtLeastOne,numberOfPossiblePairVertices,1) - 1).*numberOfPossiblePairVertices;
        
        % sort the pairCells and pairVertices so that the according to
        % their closeness for each vertex with at least one interaction
        pairCells=pairCells(sortedIdx2);
        pairVertices=pairVertices(sortedIdx2);
        
        % remove the extra part of the matrix    
        pairCells = pairCells(1:maxPossible,:);
        pairVertices = pairVertices(1:maxPossible,:);
        
        % get pairCells with zeros for all interactions that are not
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
            previousVertices1(i) = cells(closestCells1(i)).nVertices;
        end
        
        % get the differences between closest cells to find from how many
        % cells the closest interactions are from
        cellDifference = (pairCellsZeros(1:end-1,:)-pairCellsZeros(2:end,:));
        
        % find the indices of the vertices indices with at least one 
        % possible interaction that can interact with two different cells
        cellDifferenceNotZero = cellDifference~=0;
        atLeastTwo = find(sum(cellDifferenceNotZero,1) > 1);
        
        % get the rows of the second interaction in the pairCells and
        % pairVertices matrices (first line only gets the rows - 1, so + 1
        % is added)
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
            previousVertices2(i) = cells(closestCells2(i)).nVertices;
        end
            
        % intialize the vectors for the pair coordinates       
        nextSegmentX = zeros(numberOfAtLeastOne,1);
        nextSegmentY = nextSegmentX;
        prevSegmentX = nextSegmentX;
        prevSegmentY = nextSegmentX;
        nextSegmentLength = nextSegmentX;
        prevSegmentLength = nextSegmentX;
        nextSegmentVectorX = nextSegmentX;
        nextSegmentVectorY = nextSegmentX;
        prevSegmentVectorX = nextSegmentX;
        prevSegmentVectorY = nextSegmentX;
        
        % id there are close cells
        if numel(closestCells1)
            
            % get the unique neighbors
            zeroVecTemp = cellZeroVector;
            zeroVecTemp(closestCells1) = 1;
            neighboringCells = cellNumbers(logical(zeroVecTemp(cellNumbers)));
            
            % go through the neighbors
            for k2 = neighboringCells
                
                % find the vertex indices in contact with the other cell
                verticesIdx = closestCells1 == k2;
                
                % get the pair vertex indices
                idx = closestVertices1(verticesIdx);
                
                % get the coordinates, left vectors, and left vector lengths
                % of the closest pair vertex
                nextSegmentX(verticesIdx) = cells(k2).verticesX(idx);
                nextSegmentY(verticesIdx) = cells(k2).verticesY(idx);
                nextSegmentLength(verticesIdx) = cells(k2).leftLengths(idx);
                nextSegmentVectorX(verticesIdx) = cells(k2).leftVectorsX(idx);
                nextSegmentVectorY(verticesIdx) = cells(k2).leftVectorsY(idx);
                
                % get the indices of the vertex previous to (right to) the
                % closest pair vertex
                idx = previousVertices1(verticesIdx);
                
                % get coordinates, left vectors, and left vector lengths of
                % the previous vertex
                prevSegmentX(verticesIdx) = cells(k2).verticesX(idx);
                prevSegmentY(verticesIdx) = cells(k2).verticesY(idx);
                prevSegmentLength(verticesIdx) = cells(k2).leftLengths(idx);
                prevSegmentVectorX(verticesIdx) = cells(k2).leftVectorsX(idx);
                prevSegmentVectorY(verticesIdx) = cells(k2).leftVectorsY(idx);
                
            end
        end
        
        % get the projections between vertices with at least one
        % interaction and the membrane segments on each side of the closest
        % pair vertex
        projectionPrev = ((cells(k).verticesX(atLeastOneIdx) - prevSegmentX).*prevSegmentVectorX + (cells(k).verticesY(atLeastOneIdx) - prevSegmentY).*prevSegmentVectorY)./prevSegmentLength.^2;
        projectionNext = ((cells(k).verticesX(atLeastOneIdx) - nextSegmentX).*nextSegmentVectorX + (cells(k).verticesY(atLeastOneIdx) - nextSegmentY).*nextSegmentVectorY)./nextSegmentLength.^2;
        
        % check if the projections are on the membrane segments
        betweenVerticesPrev =  and(0 <= projectionPrev, projectionPrev <= 1);
        betweenVerticesNext =  and(0 <= projectionNext, projectionNext <= 1);   
        
        % save the information on the vertices whose projection is on the
        % previous segment of the closest vertex
        prev.vertices = atLeastOneIdx(betweenVerticesPrev);
        prev.present = ~isempty(prev.vertices);
        if prev.present
            prev.pairCellIDs = closestCells1(betweenVerticesPrev);
            prev.pairVertexIDs = previousVertices1(betweenVerticesPrev);

            zeroVecTemp = cellZeroVector;
            zeroVecTemp(prev.pairCellIDs) = 1;
            prev.pairCells = cellNumbers(logical(zeroVecTemp(cellNumbers)));
        end
        cells(k).contacts.cell1.prev = prev;
        
        % save the information on the vertices whose projection is on the
        % next segment of the closest vertex
        next.vertices = atLeastOneIdx(betweenVerticesNext);
        next.present = ~isempty(next.vertices);
        if next.present
            next.pairCellIDs = closestCells1(betweenVerticesNext);
            next.pairVertexIDs = closestVertices1(betweenVerticesNext);
            
            zeroVecTemp = cellZeroVector;
            zeroVecTemp(next.pairCellIDs) = 1;
            next.pairCells = cellNumbers(logical(zeroVecTemp(cellNumbers)));
        end
        cells(k).contacts.cell1.next = next;
        
        % find the vertices whose projection is not neither of the membrane
        % segments
        neither = ~or(betweenVerticesPrev,betweenVerticesNext);
        
        % save the information on the vertices whose projection is not on
        % either of the segments neighboring the closest vertex
        vertex.vertices = atLeastOneIdx(neither);
        vertex.present = ~isempty(vertex.vertices);
        if vertex.present
            vertex.pairCellIDs = closestCells1(neither);
            vertex.pairVertexIDs = closestVertices1(neither);
            
            zeroVecTemp = cellZeroVector;
            zeroVecTemp(vertex.pairCellIDs) = 1;
            vertex.pairCells = cellNumbers(logical(zeroVecTemp(cellNumbers)));
        end
        cells(k).contacts.cell1.vertex = vertex;

        % get the indices of the vertices at least two interactions
        atLeastTwo = atLeastOneIdx(atLeastTwo);
        
        % if they exist
        if any(atLeastTwo)
            
            % intialize the vectors for the pair coordinates
            nextSegmentX = zeros(length(atLeastTwo),1);
            nextSegmentY = nextSegmentX;
            prevSegmentX = nextSegmentX;
            prevSegmentY = nextSegmentX;
            nextSegmentLength = nextSegmentX;
            prevSegmentLength = nextSegmentX;
            nextSegmentVectorX = nextSegmentX;
            nextSegmentVectorY = nextSegmentX;
            prevSegmentVectorX = nextSegmentX;
            prevSegmentVectorY = nextSegmentX;
%             
            closestCells2 = nonzeros(closestCells2);
            closestVertices2 = nonzeros(closestVertices2);
            previousVertices2 = nonzeros(previousVertices2);
            
            if numel(closestCells2)
                
                % get the unique neighbors
                zeroVecTemp = cellZeroVector;
                zeroVecTemp(closestCells2) = 1;
                neighboringCells = cellNumbers(logical(zeroVecTemp(cellNumbers)));

                % go through the neighbors
                for k2 = neighboringCells
                    
                    % find the vertex indices in contact with the other cell
                    verticesIdx = closestCells2 == k2;
                    
                    % get the pair vertex indices
                    idx = closestVertices2(verticesIdx);
                    
                    % get the coordinates, left vectors, and left vector lengths
                    % of the closest pair vertex
                    nextSegmentX(verticesIdx) = cells(k2).verticesX(idx);
                    nextSegmentY(verticesIdx) = cells(k2).verticesY(idx);
                    nextSegmentLength(verticesIdx) = cells(k2).leftLengths(idx);
                    nextSegmentVectorX(verticesIdx) = cells(k2).leftVectorsX(idx);
                    nextSegmentVectorY(verticesIdx) = cells(k2).leftVectorsY(idx);
                    
                    % get the indices of the vertex previous to (right to) the
                    % closest pair vertex
                    idx = previousVertices2(verticesIdx);
                    
                    % get coordinates, left vectors, and left vector lengths of
                    % the previous vertex
                    prevSegmentX(verticesIdx) = cells(k2).verticesX(idx);
                    prevSegmentY(verticesIdx) = cells(k2).verticesY(idx);
                    prevSegmentLength(verticesIdx) = cells(k2).leftLengths(idx);
                    prevSegmentVectorX(verticesIdx) = cells(k2).leftVectorsX(idx);
                    prevSegmentVectorY(verticesIdx) = cells(k2).leftVectorsY(idx);
                end
            end
            
            % get the projections between vertices with at least one
            % interaction and the membrane segments on each side of the closest
            % pair vertex
            projectionPrev = ((cells(k).verticesX(atLeastTwo) - prevSegmentX).*prevSegmentVectorX + (cells(k).verticesY(atLeastTwo) - prevSegmentY).*prevSegmentVectorY)./prevSegmentLength.^2;
            projectionNext = ((cells(k).verticesX(atLeastTwo) - nextSegmentX).*nextSegmentVectorX + (cells(k).verticesY(atLeastTwo) - nextSegmentY).*nextSegmentVectorY)./nextSegmentLength.^2;
            
            % check if the projections are on the membrane segments
            betweenVerticesPrev = and(0 <= projectionPrev, projectionPrev <= 1);
            betweenVerticesNext = and(0 <= projectionNext, projectionNext <= 1);
            
            % save the information on the vertices whose projection is on the
            % previous segment of the closest vertex
            prev.vertices = atLeastTwo(betweenVerticesPrev);
            prev.present = ~isempty(prev.vertices);
            if prev.present
                prev.pairCellIDs = closestCells2(betweenVerticesPrev);
                prev.pairVertexIDs = previousVertices2(betweenVerticesPrev);
                
                zeroVecTemp = cellZeroVector;
                zeroVecTemp(prev.pairCellIDs) = 1;
                prev.pairCells = cellNumbers(logical(zeroVecTemp(cellNumbers)));
            else
                prev.pairCellIDs = [];
                prev.pairVertexIDs = [];
                prev.pairCells = [];
            end
            cells(k).contacts.cell2.prev = prev;
            
            % save the information on the vertices whose projection is on the
            % next segment of the closest vertex
            next.vertices = atLeastTwo(betweenVerticesNext);
            next.present = ~isempty(next.vertices);
            if next.present
                next.pairCellIDs = closestCells2(betweenVerticesNext);
                next.pairVertexIDs = closestVertices2(betweenVerticesNext);
                
                zeroVecTemp = cellZeroVector;
                zeroVecTemp(next.pairCellIDs) = 1;
                next.pairCells = cellNumbers(logical(zeroVecTemp(cellNumbers)));
            else
                next.pairCellIDs = [];
                next.pairVertexIDs = [];
                next.pairCells = [];
            end
            cells(k).contacts.cell2.next = next;
            
            % find the vertices whose projection is not neither of the membrane
            % segments
            neither = ~or(betweenVerticesPrev,betweenVerticesNext);
            
            % save the information on the vertices whose projection is not on
            % either of the segments neighboring the closest vertex
            vertex.vertices = atLeastTwo(neither);
            vertex.present = ~isempty(vertex.vertices);
            if vertex.present
                vertex.pairCellIDs = closestCells2(neither);
                vertex.pairVertexIDs = closestVertices2(neither);
                
                zeroVecTemp = cellZeroVector;
                zeroVecTemp(vertex.pairCellIDs) = 1;
                vertex.pairCells = cellNumbers(logical(zeroVecTemp(cellNumbers)));
            else
                vertex.pairCellIDs = [];
                vertex.pairVertexIDs = [];
                vertex.pairCells = [];
            end
            cells(k).contacts.cell2.vertex = vertex;
            
        else
            % if no contacts with second cells
            cells(k).contacts.cell2.prev.present = false;
            cells(k).contacts.cell2.next.present = false;
            cells(k).contacts.cell2.vertex.present = false;
        end
        
        % if there are any contacts, set contacts present to true
        if cells(k).contacts.cell1.prev.present || cells(k).contacts.cell1.next.present || cells(k).contacts.cell1.vertex.present || cells(k).contacts.cell2.prev.present || cells(k).contacts.cell2.next.present || cells(k).contacts.cell2.vertex.present
            cells(k).contacts.present = true;
        end

        %% if junctions are updated
        if simset.junctionModification
            
            % save the vertex indices with possible new junctions
            cells(k).junctions.possible.vertices = find(and(atLeastOne,or(cells(k).vertexStates == 0,cells(k).vertexStates == 1)));
            
            % get the vertices that have at least one possible new junction
            % that can form new junctions
            possibleJunctionsOfAtLeastOneIdx = or(cells(k).vertexStates(atLeastOne) == 0, cells(k).vertexStates(atLeastOne) == 1);
            
            % get the pair vertex and cell indices for those vertices
            cells(k).junctions.possible.pairCellIDs = pairCells(:,possibleJunctionsOfAtLeastOneIdx);
            cells(k).junctions.possible.pairVertexIDs = pairVertices(:,possibleJunctionsOfAtLeastOneIdx);
            
            % get the pair cells of the vertices that already have a single
            % junction and that have at least one possible new junction so
            % that we can rule the cases where vertex would have a junction
            % with two vertices in the same neighboring cell)
            existingJunctionPairCells = cells(k).junctions.cells(find((cells(k).vertexStates == 1).*atLeastOne),1)';
            
            % get the indices of the vertices of the new possible junctions
            % that already have a single junction
            existingJunctionsOfAtLeastOneIdx = nonzeros(cumsum(possibleJunctionsOfAtLeastOneIdx).*(cells(k).vertexStates(atLeastOne) == 1));
            
            % get the size of the possible junction pair matrix
            pairMatrixSize = size(cells(k).junctions.possible.pairCellIDs);
            
            % find the indices of the vertices with new possible junctions
            % that already have a junction and the closest pair vertex is
            % in the same cell as the existing junction vertex pair
            sameCellIdx = cells(k).junctions.possible.pairCellIDs(:,existingJunctionsOfAtLeastOneIdx) == repmat(existingJunctionPairCells,pairMatrixSize(1),1);
            
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
            cells(k).junctions.possible.pairCellIDs(sameCellIdx) = nan;
            
            % find the at least one possible junction indices that are full
            % of NaNs (can only form new junctions with the same cell with
            % which they are already connected with)
            fullNans = find(sum(~isnan(cells(k).junctions.possible.pairCellIDs),1) == 0);
            
            % get the indices of the possibleJunctionsOfAtLeastOneIdx
            possibleJunctionsOfAtLeastOneIdx = find(possibleJunctionsOfAtLeastOneIdx);
            
            % remove all the information of the vertices that could only
            % connect to the same cell which they are already connected to
            if numel(fullNans)
                cells(k).junctions.possible.vertices(fullNans) = [];
                cells(k).junctions.possible.pairCellIDs(:,fullNans) = [];
                cells(k).junctions.possible.pairVertexIDs(:,fullNans) = [];
                possibleJunctionsOfAtLeastOneIdx(fullNans) = [];
            end
            
            % get the squared distances of the remaining vertices
            cells(k).junctions.possible.distances = sortedDistancesSq(:,cells(k).junctions.possible.vertices);
            
            % get the number of vertices with possible new junctions
            nPossibleJunctions = length(possibleJunctionsOfAtLeastOneIdx);
            
            % repmat the pair vertex coorindates
            pairVerticesX = repmat(pairVerticesX,1,nPossibleJunctions);
            pairVerticesY = repmat(pairVerticesY,1,nPossibleJunctions);
            
            % get the indices closest vertices of the remaining vertices
            % that can form new junctions
            sortedIdx2 = sortedIdx(:,possibleJunctionsOfAtLeastOneIdx) + (repmat(1:nPossibleJunctions,numberOfPossiblePairVertices,1) - 1).*numberOfPossiblePairVertices;
            
            % get the pair coordinates
            pairVerticesX = pairVerticesX(sortedIdx2);
            pairVerticesY = pairVerticesY(sortedIdx2);
            
            % remove the extra bits and save
            cells(k).junctions.possible.pairVerticesX = pairVerticesX(1:maxPossible,:);
            cells(k).junctions.possible.pairVerticesY = pairVerticesY(1:maxPossible,:);
        end
        
    end
    
    %% Cell division repulsion
    
    % if the cell is in cytokinesis (state = 2)
    if cells(k).division.state == 2
        
        % number of vertices to consider on left and right sides from the
        % division vertices
        vertices2Include = round(0.1*cells(k).nVertices);

        
        vertexIDs = [];
        pairIDs = [];
        
        % go through the division vertices
        for i = 1:2
            
            % division vertices 1 (smaller index)
            if i == 1
                
                % indices of the vertices left to the division vertex 1 (take
                % 2 extra vertices in addition to the included number of
                % vertices to make sure that the closest vertices to the
                % included vertices are taken into account)
                leftVerticesIdx = cells(k).division.vertices(1) + 1 : cells(k).division.vertices(1) + vertices2Include;
                
                % indices of the vertices right to the division vertex 1
                % (dealt differently if divVertex 1 is close to the first
                % vertex)
                if cells(k).division.vertices(1) > vertices2Include + 1
                    rightVerticesIdx = cells(k).division.vertices(1) - vertices2Include : cells(k).division.vertices(1) - 1;
                else
                    nTemp = cells(k).division.vertices(1)-1;
                    rightVerticesIdx = [cells(k).nVertices-(vertices2Include - nTemp)+1:cells(k).nVertices 1:nTemp];
                end
                
                % division vertex 2 (larger index)
            else
                
                % indices of the vertices right to the division vertex 2 (take
                % 2 extra vertices in addition to the included number of
                % vertices to make sure that the closest vertices to the
                % included vertices are taken into account)
                rightVerticesIdx = cells(k).division.vertices(2) - vertices2Include : cells(k).division.vertices(2) - 1;
                
                % indices of the vertices left to the division vertex 2
                % (dealt differently if divVertex 2 is close to the last
                % vertex)
                if cells(k).division.vertices(2) + vertices2Include <= cells(k).nVertices
                    leftVerticesIdx = cells(k).division.vertices(2) + 1 : cells(k).division.vertices(2) + vertices2Include;
                else
                    nTemp = cells(k).nVertices - cells(k).division.vertices(2);
                    leftVerticesIdx = [cells(k).division.vertices(2)+1:cells(k).nVertices 1:vertices2Include - nTemp];
                end
            end
            
            % get the coordinates of the left side vertices
            leftVerticesX = cells(k).verticesX(leftVerticesIdx);
            leftVerticesY = cells(k).verticesY(leftVerticesIdx);
            
            % get the coordinates of the right side vertices
            rightVerticesX = cells(k).verticesX(rightVerticesIdx);
            rightVerticesY = cells(k).verticesY(rightVerticesIdx);

            vertexDistancesSq  = (rightVerticesX - leftVerticesX').^2 + (rightVerticesY - leftVerticesY').^2;
            
            % find the possible pairs for each vertex
            possibleInteractions = vertexDistancesSq < (3*spar.junctionLength).^2;
            
            atLeastContactLeft = ~(sum(possibleInteractions,1) == 0)';
            
            atLeastContactRight = ~(sum(possibleInteractions,2) == 0)';
            
            leftVerticesIdxSelf = leftVerticesIdx(:,atLeastContactLeft);
            rightVerticesIdxSelf = rightVerticesIdx(:,atLeastContactRight);
            
            vertexDistancesSq(~possibleInteractions) = nan;
            
            vertexDistancesSqLeft = vertexDistancesSq(:,atLeastContactLeft);
            vertexDistancesSqRight = vertexDistancesSq(atLeastContactRight,:);
            
            [~,tempIdx1] = sort(vertexDistancesSqLeft,1);
            
            [~,existingJunctionPairCells] = sort(vertexDistancesSqRight,2);
            
            vertexIDs = [vertexIDs leftVerticesIdxSelf rightVerticesIdxSelf];
            pairIDs = [pairIDs rightVerticesIdx(tempIdx1(1,:)) leftVerticesIdx(existingJunctionPairCells(:,1))];

        end
        
        verticesX = cells(k).verticesX(vertexIDs);
        verticesY = cells(k).verticesY(vertexIDs);
        
        firsts = pairIDs == 1;
        pairsPrev = pairIDs - 1;
        pairsPrev(firsts) = cells(k).nVertices;
        
        nextSegmentX = cells(k).verticesX(pairIDs);
        nextSegmentY = cells(k).verticesY(pairIDs);
        prevSegmentX = cells(k).verticesX(pairsPrev);
        prevSegmentY = cells(k).verticesY(pairsPrev);
        nextSegmentLength = cells(k).leftLengths(pairIDs);
        prevSegmentLength = cells(k).leftLengths(pairsPrev);
        nextSegmentVectorX = cells(k).leftVectorsX(pairIDs);
        nextSegmentVectorY = cells(k).leftVectorsY(pairIDs);
        prevSegmentVectorX = cells(k).leftVectorsX(pairsPrev);
        prevSegmentVectorY = cells(k).leftVectorsY(pairsPrev);
        
        projection1p = ((verticesX - prevSegmentX).*prevSegmentVectorX + (verticesY - prevSegmentY).*prevSegmentVectorY)./prevSegmentLength.^2;
        projection1n = ((verticesX - nextSegmentX).*nextSegmentVectorX + (verticesY - nextSegmentY).*nextSegmentVectorY)./nextSegmentLength.^2;
        
        between1p =  and(0 <= projection1p, projection1p <= 1);
        between1n =  and(0 <= projection1n, projection1n <= 1);   
        
        prev.vertices = vertexIDs(between1p);
        prev.present = ~isempty(prev.vertices);
        if prev.present
            prev.pairIDs = pairsPrev(between1p);
        end
        cells(k).contacts.division.prev = prev;
        
        next.vertices = vertexIDs(between1n);
        next.present = ~isempty(next.vertices);
        if next.present
            next.pairIDs = pairIDs(between1n);
        end
        cells(k).contacts.division.next = next;
        
        neither = ~or(between1p,between1n);
        vertex.vertices = vertexIDs(neither);
        vertex.present = ~isempty(vertex.vertices);
        if vertex.present
            vertex.pairIDs = pairIDs(neither);
        end
        cells(k).contacts.division.vertex = vertex;

    end
    
    
end

end