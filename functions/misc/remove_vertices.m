function d = remove_vertices(d)

d.simset.junctionModification = false;

lengthLimit = d.spar.membraneLength*0.5;

% go through the cells
for k = length(d.cells):-1:1
    
    cellRemoved = 0;
    
    % find the vertices with too large angles
    vertices2Remove = find(d.cells(k).outsideAngles < d.spar.maxMembraneAngle + d.cells(k).outsideAngles > 2*pi-d.spar.maxMembraneAngle);
    
    % if cell is in cytokinesis, remove the division vertices from the
    % vertices to be removed if they are included
    if d.cells(k).division.state == 2
        for i = 1:2
            vertices2Remove(vertices2Remove == d.cells(k).division.vertices(i)) = [];
        end
    end
    
    % if there still are vertices to remove
    if numel(vertices2Remove) ~= 0
        
        % go through the vertices to remove
        for i = length(vertices2Remove):-1:1
            % remove the coordinates for the vertex
            d.cells(k).verticesX(vertices2Remove(i)) = [];
            d.cells(k).verticesY(vertices2Remove(i)) = [];
            
            % if the vertex has a junction
            if any(d.cells(k).vertexStates(vertices2Remove(i)) == [1 2])
                for i2 = 1:d.cells(k).vertexStates(vertices2Remove(i))
                    % get the pair ID data for the junction
                    cellid = d.cells(k).junctions.cells(vertices2Remove(i),i2);
                    vertexid = d.cells(k).junctions.vertices(vertices2Remove(i),i2);
                    
                    whichJunction = find(d.cells(cellid).junctions.cells(vertexid,:) == k);
                    
                    % set the junction and vertex state data to empty for the
                    % pair vertex
                    d.cells(cellid).junctions.cells(vertexid,whichJunction) = 0;
                    d.cells(cellid).junctions.vertices(vertexid,whichJunction) = 0;
                    
                    if d.cells(cellid).vertexStates(vertexid) == 2
                        d.cells(cellid).vertexStates(vertexid) = 1;
                        if whichJunction == 1
                            d.cells(cellid).junctions.cells(vertexid,1) = d.cells(cellid).junctions.cells(vertexid,2);
                            d.cells(cellid).junctions.vertices(vertexid,1) = d.cells(cellid).junctions.vertices(vertexid,2);
                            d.cells(cellid).junctions.cells(vertexid,2) = 0;
                            d.cells(cellid).junctions.vertices(vertexid,2) = 0;
                        end
                    else
                        d.cells(cellid).vertexStates(vertexid) = 0;
                    end
                end
            end
            
            junctions2UpdateIdx = find(d.cells(k).vertexStates > 0);
            
            junctions2UpdateIdx(junctions2UpdateIdx <= vertices2Remove(i)) = [];
            
            % go through the junction pairs of the vertices whose indices
            % have changed
            
            for j = junctions2UpdateIdx'
                for i2 = 1:d.cells(k).vertexStates(j)
                    % temporary index
                    cellid = d.cells(k).junctions.cells(j,i2);
                    vertexid = d.cells(k).junctions.vertices(j,i2);
                    
                    whichJunction = d.cells(cellid).junctions.cells(vertexid,:) == k;
                    
                    d.cells(cellid).junctions.vertices(vertexid,whichJunction) = d.cells(cellid).junctions.vertices(vertexid,whichJunction) - 1;

                end
            end
            
            % remove vertex from vertexStates
            d.cells(k).vertexStates(vertices2Remove(i)) = [];
            
            % remove the junction data
            d.cells(k).junctions.cells(vertices2Remove(i),:) = [];
            d.cells(k).junctions.vertices(vertices2Remove(i),:) = [];
            
            % update the divisionVertices (minus one from the division
            % vertice that have larger index than the vertex to be removed
            d.cells(k).division.vertices = d.cells(k).division.vertices - 1.*double((d.cells(k).division.vertices) >= vertices2Remove(i));
            
            if d.simset.simulationType == 5
                if any(d.simset.opto.cells == k)
                    removedVertex = vertices2Remove(i);
                    cellIdx = d.simset.opto.cells == k;
                    d.simset.opto.vertices{cellIdx}(d.simset.opto.vertices{cellIdx} > removedVertex) = d.simset.opto.vertices{cellIdx}(d.simset.opto.vertices{cellIdx} > removedVertex) - 1;
                    
                    if any(d.simset.opto.vertices{cellIdx} == removedVertex)
                        d.simset.opto.vertices{cellIdx}(d.simset.opto.vertices{cellIdx} == removedVertex) = [];
                    end
                    
                    if isempty(d.simset.opto.vertices{cellIdx})
                        d.simset.opto.cells(cellIdx) = [];
                        d.simset.opto.vertices(cellIdx) = [];
                    end
                    
                end
            end
            
            
            % if substrate is included
            
            if any(d.simset.simulationType == [3,5])
                if d.cells(k).substrate.connected(vertices2Remove(i))
                    
                    idxTemp = find(find(d.cells(k).substrate.connected) == vertices2Remove(i));
                    
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
                    
                    d.sub.adhesionNumbers(d.cells(k).substrate.points(idxTemp,:)) = d.sub.adhesionNumbers(d.cells(k).substrate.points(idxTemp,:)) - 1;
                    d.cells(k).substrate.points(idxTemp,:) = [];
                    d.cells(k).substrate.weights(idxTemp,:) = [];
                    d.cells(k).substrate.linkCols(idxTemp,:) = [];
                    d.cells(k).substrate.matrixIdx = sub2ind([d.sub.nPoints 200],d.cells(k).substrate.points(:),d.cells(k).substrate.linkCols(:));
                end
                d.cells(k).substrate.connected(vertices2Remove(i)) = [];
                
                if d.cells(k).cellState == 0
                    d.cells(k).edgeVertices(d.cells(k).edgeVertices > vertices2Remove(i)) = d.cells(k).edgeVertices(d.cells(k).edgeVertices > vertices2Remove(i)) - 1;
                    
                    if any(d.cells(k).edgeVertices == vertices2Remove(i))
                        
                        tempIdx = d.cells(k).edgeVertices == vertices2Remove(i);
                        
                        d.cells(k).edgeVertices(tempIdx) = [];
                        
                        d.cells(k).edgeInitialX(tempIdx) = [];
                        d.cells(k).edgeInitialY(tempIdx) = [];
                        
                    end
                end
                
                
            end
            
            % modify cortex tension multipliers
            originals = d.cells(k).vertexCorticalTensions;
            if vertices2Remove(i) == 1
                d.cells(k).vertexCorticalTensions(end-1) = (originals(end-1) + originals(end))/2;
                d.cells(k).vertexCorticalTensions(end) = (originals(end) + originals(1))/2;
            elseif vertices2Remove(i) == 2
                d.cells(k).vertexCorticalTensions(end) = (originals(end) + originals(1))/2;
                d.cells(k).vertexCorticalTensions(1) = (originals(1) + originals(2))/2;
            else
                idx = vertices2Remove(i);
                d.cells(k).vertexCorticalTensions(idx-2) = (originals(idx-2) + originals(idx-1))/2;
                d.cells(k).vertexCorticalTensions(idx-1) = (originals(idx-1) + originals(idx))/2;
            end
            d.cells(k).vertexCorticalTensions(vertices2Remove(i)) = [];
            
            if d.simset.simulationType == 2 && k == d.simset.pointlike.cell
                
                % add the new vertex into the boundaryVertices matrix
                d.simset.pointlike.vertexX(vertices2Remove(i)) = [];
                d.simset.pointlike.vertexY(vertices2Remove(i)) = [];
                
                d.simset.pointlike.vertexOriginalX(vertices2Remove(i)) = [];
                d.simset.pointlike.vertexOriginalY(vertices2Remove(i)) = [];
                
            end
            
            d.simset.junctionModification = true;
            
            if d.cells(k).nVertices < 5
                d.cells = remove_cell_and_links(d.cells,k);
                
                cellRemoved = 1;
                break
            end
        end
        
        if ~cellRemoved
            % recalculate the indeces of the substrate stuff
            if any(d.simset.simulationType == [2,3,5])
                d.cells(k).substrate.pointsLin = d.cells(k).substrate.points(:);
                d.cells(k).substrate.weightsLin = d.cells(k).substrate.weights(:);
            end
            
            % calculate lengths, vectors, areas and update the number of
            % vertices
            d.cells(k) = get_boundary_vectors(d.cells(k));
            d.cells(k) = get_boundary_lengths(d.cells(k));
            d.cells(k).nVertices = size(d.cells(k).verticesX,1);
        end
    end
    
    
    %%
    
    if ~cellRemoved
    
    vertices2Remove = find(d.cells(k).leftLengths < lengthLimit);
    
    if d.cells(k).division.state == 2
        for i = 1:2
            vertices2Remove(vertices2Remove == d.cells(k).division.vertices(i)) = [];
        end
    end
    
    % if there still are vertices to remove
    if numel(vertices2Remove) ~= 0
        
        firstHasBeenRemoved = false;
        
        % go through the vertices to remove
        for i = length(vertices2Remove):-1:1
            
            if vertices2Remove(i) == 0 && firstHasBeenRemoved
               break; 
            end
            
            
            if vertices2Remove(i) == length(d.cells(k).verticesX)
                if d.cells(k).rightLengths(vertices2Remove(i)) < d.cells(k).leftLengths(1)
                    vertex2Remove = vertices2Remove(i);
                else
                    if any(1 == d.cells(k).division.vertices)
                        vertex2Remove = vertices2Remove(i);
                    else
                        vertex2Remove = 1;
                        firstHasBeenRemoved = true;
                        vertices2Remove = vertices2Remove - 1;
                    end
                end
            else
                if d.cells(k).rightLengths(vertices2Remove(i)) < d.cells(k).leftLengths(vertices2Remove(i)+1)
                    vertex2Remove = vertices2Remove(i);
                else
                    if any(vertices2Remove(i)+1 == d.cells(k).division.vertices)
                        vertex2Remove = vertices2Remove(i);
                    else
                        vertex2Remove = vertices2Remove(i)+1;
                    end
                end
            end

            
            % remove the coordinates for the vertex
            d.cells(k).verticesX(vertex2Remove) = [];
            d.cells(k).verticesY(vertex2Remove) = [];
            
            % if the vertex has a junction
            if any(d.cells(k).vertexStates(vertex2Remove) == [1 2])
                for i2 = 1:d.cells(k).vertexStates(vertex2Remove)
                    % get the pair ID data for the junction
                    cellid = d.cells(k).junctions.cells(vertex2Remove,i2);
                    vertexid = d.cells(k).junctions.vertices(vertex2Remove,i2);
                    
                    whichJunction = find(d.cells(cellid).junctions.cells(vertexid,:) == k);
                    
                    % set the junction and vertex state data to empty for the
                    % pair vertex
                    d.cells(cellid).junctions.cells(vertexid,whichJunction) = 0;
                    d.cells(cellid).junctions.vertices(vertexid,whichJunction) = 0;
                    
                    if d.cells(cellid).vertexStates(vertexid) == 2
                        d.cells(cellid).vertexStates(vertexid) = 1;
                        if whichJunction == 1
                            d.cells(cellid).junctions.cells(vertexid,1) = d.cells(cellid).junctions.cells(vertexid,2);
                            d.cells(cellid).junctions.vertices(vertexid,1) = d.cells(cellid).junctions.vertices(vertexid,2);
                            d.cells(cellid).junctions.cells(vertexid,2) = 0;
                            d.cells(cellid).junctions.vertices(vertexid,2) = 0;
                        end
                    else
                        d.cells(cellid).vertexStates(vertexid) = 0;
                    end
                end
            end
            
            junctions2UpdateIdx = find(d.cells(k).vertexStates > 0);
            
            junctions2UpdateIdx(junctions2UpdateIdx <= vertex2Remove) = [];
            
            % go through the junction pairs of the vertices whose indices
            % have changed
            
            for j = junctions2UpdateIdx'
                for i2 = 1:d.cells(k).vertexStates(j)
                    % temporary index
                    cellid = d.cells(k).junctions.cells(j,i2);
                    vertexid = d.cells(k).junctions.vertices(j,i2);
                    
                    whichJunction = d.cells(cellid).junctions.cells(vertexid,:) == k;
                    
                    d.cells(cellid).junctions.vertices(vertexid,whichJunction) = d.cells(cellid).junctions.vertices(vertexid,whichJunction) - 1;

                end
            end
            
            % remove vertex from vertexStates
            d.cells(k).vertexStates(vertex2Remove) = [];
            
            % remove the junction data
            d.cells(k).junctions.cells(vertex2Remove,:) = [];
            d.cells(k).junctions.vertices(vertex2Remove,:) = [];
            
            % update the divisionVertices (minus one from the division
            % vertice that have larger index than the vertex to be removed
            d.cells(k).division.vertices = d.cells(k).division.vertices - 1.*double((d.cells(k).division.vertices) >= vertex2Remove);
            
            if d.simset.simulationType == 5
                if any(d.simset.opto.cells == k)
                    removedVertex = vertex2Remove;
                    cellIdx = d.simset.opto.cells == k;
                    d.simset.opto.vertices{cellIdx}(d.simset.opto.vertices{cellIdx} > removedVertex) = d.simset.opto.vertices{cellIdx}(d.simset.opto.vertices{cellIdx} > removedVertex) - 1;
                    
                    if any(d.simset.opto.vertices{cellIdx} == removedVertex)
                        d.simset.opto.vertices{cellIdx}(d.simset.opto.vertices{cellIdx} == removedVertex) = [];
                    end
                    
                    if isempty(d.simset.opto.vertices{cellIdx})
                        d.simset.opto.cells(cellIdx) = [];
                        d.simset.opto.vertices(cellIdx) = [];
                    end
                    
                end
            end
            
            
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
                    
                    d.sub.adhesionNumbers(d.cells(k).substrate.points(idxTemp,:)) = d.sub.adhesionNumbers(d.cells(k).substrate.points(idxTemp,:)) - 1;
                    d.cells(k).substrate.points(idxTemp,:) = [];
                    d.cells(k).substrate.weights(idxTemp,:) = [];
                    d.cells(k).substrate.linkCols(idxTemp,:) = [];
                    d.cells(k).substrate.matrixIdx = sub2ind([d.sub.nPoints 200],d.cells(k).substrate.points(:),d.cells(k).substrate.linkCols(:));
                end
                d.cells(k).substrate.connected(vertex2Remove) = [];
                
                if d.cells(k).cellState == 0
                    d.cells(k).edgeVertices(d.cells(k).edgeVertices > vertices2Remove(i)) = d.cells(k).edgeVertices(d.cells(k).edgeVertices > vertices2Remove(i)) - 1;
                    
                    if any(d.cells(k).edgeVertices == vertices2Remove(i))
                        
                        tempIdx = d.cells(k).edgeVertices == vertices2Remove(i);
                        
                        d.cells(k).edgeVertices(tempIdx) = [];
                        
                        d.cells(k).edgeInitialX(tempIdx) = [];
                        d.cells(k).edgeInitialY(tempIdx) = [];
                        
                    end
                end
            end
            
            % modify cortex tension multipliers
            originals = d.cells(k).vertexCorticalTensions;
            if vertex2Remove == 1
                d.cells(k).vertexCorticalTensions(end-1) = (originals(end-1) + originals(end))/2;
                d.cells(k).vertexCorticalTensions(end) = (originals(end) + originals(1))/2;
            elseif vertex2Remove == 2
                d.cells(k).vertexCorticalTensions(end) = (originals(end) + originals(1))/2;
                d.cells(k).vertexCorticalTensions(1) = (originals(1) + originals(2))/2;
            else
                idx = vertex2Remove;
                d.cells(k).vertexCorticalTensions(idx-2) = (originals(idx-2) + originals(idx-1))/2;
                d.cells(k).vertexCorticalTensions(idx-1) = (originals(idx-1) + originals(idx))/2;
            end
            d.cells(k).vertexCorticalTensions(vertex2Remove) = [];
            
            if d.simset.simulationType == 2 && k == d.simset.pointlike.cell
                
                % add the new vertex into the boundaryVertices matrix
                d.simset.pointlike.vertexX(vertex2Remove) = [];
                d.simset.pointlike.vertexY(vertex2Remove) = [];
                
                d.simset.pointlike.vertexOriginalX(vertex2Remove) = [];
                d.simset.pointlike.vertexOriginalY(vertex2Remove) = [];
                
            end
            
            d.simset.junctionModification = true;
            
            if d.cells(k).nVertices < 5
                d.cells = remove_cell_and_links(d.cells,k);
                
                cellRemoved = 1;
                break
            end
            if ~cellRemoved
                d.cells(k) = get_boundary_lengths(d.cells(k));
            end
        end
        
        % recalculate the indeces of the substrate stuff
        if any(d.simset.simulationType == [2,3,5])
            d.cells(k).substrate.pointsLin = d.cells(k).substrate.points(:);
            d.cells(k).substrate.weightsLin = d.cells(k).substrate.weights(:);
        end
        
        % calculate lengths, vectors, areas and update the number of
        % vertices
        d.cells(k) = get_boundary_vectors(d.cells(k));
        d.cells(k) = get_boundary_lengths(d.cells(k));
        d.cells(k).nVertices = size(d.cells(k).verticesX,1);
    end
    end
    if cellRemoved
       d.simset.junctionModification = true; 
    end
    
end

end