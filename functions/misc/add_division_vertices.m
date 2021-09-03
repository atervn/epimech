function cells = add_division_vertices(cells, k, switched, newIdx, newRightX, newRightY, newLeftX, newLeftY)

% goes through the too long sections, if no, skips this step
for i = 1:length(newIdx)
    
    if switched
        if i == 1
            if newIdx(i) == 1
                newIdx(i) = cells(k).nVertices;
            else
                newIdx(i) = newIdx(i) - 1;
            end
            newVertexX = newLeftX;
            newVertexY = newLeftY;
        elseif i == 2
            newVertexX = newRightX;
            newVertexY = newRightY;
        end
    else
        if i == 1
            newVertexX = newRightX;
            newVertexY = newRightY;
        elseif i == 2
            newIdx(i) = newIdx(i) - 1;
            newVertexX = newLeftX;
            newVertexY = newLeftY;
        end
    end
    
    % the case when too long section is the last one is dealt separately
    if newIdx(i) < cells(k).nVertices
        
        % add the new vertex into the boundaryVertices matrix
        cells(k).verticesX = [cells(k).verticesX(1:newIdx(i)) ; newVertexX ; cells(k).verticesX(newIdx(i)+1:end)];
        cells(k).verticesY = [cells(k).verticesY(1:newIdx(i)) ; newVertexY ; cells(k).verticesY(newIdx(i)+1:end)];
        
        % add the new vertex into the vertexStates vector
        cells(k).vertexStates = [cells(k).vertexStates(1:newIdx(i)) ; 0 ; cells(k).vertexStates(newIdx(i)+1:end)];
        
        % update the divisionVertices vector
        cells(k).division.vertices = cells(k).division.vertices + 1.*(cells(k).division.vertices > newIdx(i));
        
        % add the new vertex into the junctions matrix
        cells(k).junctions.cells = [cells(k).junctions.cells(1:newIdx(i),:) ; [0 0] ; cells(k).junctions.cells(newIdx(i)+1:end,:)];
        cells(k).junctions.vertices = [cells(k).junctions.vertices(1:newIdx(i),:) ; [0 0] ; cells(k).junctions.vertices(newIdx(i)+1:end,:)];

        originals = cells(k).vertexCorticalTensions;
        if newIdx(i) == 1
            cells(k).vertexCorticalTensions(1) = (originals(end) + originals(1))./2;
            cells(k).vertexCorticalTensions = [cells(k).vertexCorticalTensions(1) ; (originals(end) + originals(1))./2 ; cells(k).vertexCorticalTensions(2:end)];
        else
            cells(k).vertexCorticalTensions(newIdx(i)) = (originals(newIdx(i)-1) + originals(newIdx(i)))./2;
            cells(k).vertexCorticalTensions = [cells(k).vertexCorticalTensions(1:newIdx(i)) ; (originals(newIdx(i)-1) + originals(newIdx(i)))./2 ; cells(k).vertexCorticalTensions(newIdx(i)+1:end)];
        end
        
    else
        
        % add the new vertex into the boundaryVertices matrix
        cells(k).verticesX = [cells(k).verticesX ; newVertexX];
        cells(k).verticesY = [cells(k).verticesY ; newVertexY];
        
        % add the new vertex into the vertexStates vector
        cells(k).vertexStates = [cells(k).vertexStates ; 0];
        
        % add the new vertex into the junctions matrix
        cells(k).junctions.cells = [cells(k).junctions.cells ; [0 0]];
        cells(k).junctions.vertices = [cells(k).junctions.vertices ; [0 0]];

        originals = cells(k).vertexCorticalTensions;
        cells(k).vertexCorticalTensions(end) = (originals(end-1) + originals(end))./2;
        cells(k).vertexCorticalTensions = [cells(k).vertexCorticalTensions ; (originals(end-1) + originals(end))./2;];
        
    end
    
    % increase the indices of the following too long sections as a
    % vertex was added into the cell
    
    cells(k).nVertices = cells(k).nVertices + 1;
    
    cells(k).junctions.linkedIdx1 = find(cells(k).vertexStates > 0);
    cells(k).junctions.linkedIdx2 = find(cells(k).vertexStates == 2);
    
    junctions2UpdateIdx = cells(k).junctions.linkedIdx1;
    
    junctions2UpdateIdx(junctions2UpdateIdx <= newIdx(i)) = [];
    
    if numel(junctions2UpdateIdx) > 0
        for j = junctions2UpdateIdx'
            
            % temporary index
            cellID = cells(k).junctions.cells(j,1);
            vertexID = cells(k).junctions.vertices(j,1);
            
            whichJunction = cells(cellID).junctions.cells(vertexID,:) == k;
            
            % update the junction pairs
            cells(cellID).junctions.vertices(vertexID,whichJunction) = cells(cellID).junctions.vertices(vertexID,whichJunction) + 1;
            
            if whichJunction == 1
                tempIdx2 = cells(cellID).junctions.linkedIdx1 == vertexID;
                cells(cellID).junctions.pairVertices1(tempIdx2) = cells(cellID).junctions.pairVertices1(tempIdx2) + 1;
            else
                tempIdx2 = cells(cellID).junctions.linkedIdx2 == vertexID;
                cells(cellID).junctions.pairVertices2(tempIdx2) = cells(cellID).junctions.pairVertices2(tempIdx2) + 1;
            end
        end
    end
    
    junctions2UpdateIdx = cells(k).junctions.linkedIdx2;
    
    junctions2UpdateIdx(junctions2UpdateIdx <= newIdx(i)) = [];
    
    if numel(junctions2UpdateIdx) > 0
        for j = junctions2UpdateIdx'
            
            % temporary index
            cellID = cells(k).junctions.cells(j,2);
            vertexID = cells(k).junctions.vertices(j,2);
            
            whichJunction = cells(cellID).junctions.cells(vertexID,:) == k;
            
            % update the junction pairs
            cells(cellID).junctions.vertices(vertexID,whichJunction) = cells(cellID).junctions.vertices(vertexID,whichJunction) + 1;
            
            if whichJunction == 1
                tempIdx2 = cells(cellID).junctions.linkedIdx1 == vertexID;
                cells(cellID).junctions.pairVertices1(tempIdx2) = cells(cellID).junctions.pairVertices1(tempIdx2) + 1;
            else
                tempIdx2 = cells(cellID).junctions.linkedIdx2 == vertexID;
                cells(cellID).junctions.pairVertices2(tempIdx2) = cells(cellID).junctions.pairVertices2(tempIdx2) + 1;
            end
        end
    end
    
    newIdx = newIdx + 1;
end
