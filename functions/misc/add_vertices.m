function d = add_vertices(d)
% ADD_VERTICES Add new vertices if there are two long boundary sections
%   The function checks if there are too long distance beteen two
%   neighboring vertices and adds new vertices to divide the long sections.
%   INPUTS:
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% variable to keep track if there are long boundaries left in the cells
longLengths = 1;

% vector to keep track to which cells new vertices have been added
verticesAdded = zeros(size(d.cells));

% loop until all long boundary sections are gone
while longLengths ~= 0
    
    % after each cell loop, reset the counter
    longLengths = size(d.cells,2);
    
    % go through the cells
    for k = 1:length(d.cells)
        
        % finds the indices of the sections that have more tha two times the
        % normal section length
        longIdx = find(d.cells(k).leftLengths >= 2*d.spar.membraneLength);
        
        % if there are none, reduce the longLengths by one
        if isempty(longIdx)
            longLengths = longLengths - 1;
            
            % otherwise
        else
            % new versices have been added to cell k
            verticesAdded(k) = 1;
            
            % go through the long sections
            for i = 1:size(longIdx,1)
                
                % the case when too long section is the last one is dealt
                % separately
                if longIdx(i) < d.cells(k).nVertices
                    
                    % creates a new vertex to the midway between the two
                    % vertices
                    newVertexX = (d.cells(k).verticesX(longIdx(i)) + d.cells(k).verticesX(longIdx(i)+1))/2;
                    newVertexY = (d.cells(k).verticesY(longIdx(i)) + d.cells(k).verticesY(longIdx(i)+1))/2;
                    
                    % add the new vertex into the coordinate vectors
                    d.cells(k).verticesX = [d.cells(k).verticesX(1:longIdx(i)) ; newVertexX ; d.cells(k).verticesX(longIdx(i)+1:end)];
                    d.cells(k).verticesY = [d.cells(k).verticesY(1:longIdx(i)) ; newVertexY ; d.cells(k).verticesY(longIdx(i)+1:end)];
                    
                    % add the new vertex into the vertexStates vector
                    d.cells(k).vertexStates = [d.cells(k).vertexStates(1:longIdx(i)) ; 0 ; d.cells(k).vertexStates(longIdx(i)+1:end)];
                    
                    % update the divisionVertices vector
                    d.cells(k).division.vertices = d.cells(k).division.vertices + 1.*(d.cells(k).division.vertices > longIdx(i));
                    
                    % add the new vertex into the junctions matrices
                    d.cells(k).junctions.cells = [d.cells(k).junctions.cells(1:longIdx(i),:) ; [0 0] ; d.cells(k).junctions.cells(longIdx(i)+1:end,:)];
                    d.cells(k).junctions.vertices = [d.cells(k).junctions.vertices(1:longIdx(i),:) ; [0 0] ; d.cells(k).junctions.vertices(longIdx(i)+1:end,:)];
                    
                    % modify the vertex cortical multipliers
                    originals = d.cells(k).cortex.vertexMultipliers;
                    
                    % if first index
                    if longIdx(i) == 1
                        
                        % modify the cortical multipliers of the vertices
                        % on both sides of the new vertex
                        d.cells(k).cortex.vertexMultipliers = [(originals(end) + originals(1))./2 ; (originals(end) + originals(1))./2 ; d.cells(k).cortex.vertexMultipliers(2:end)];
                        
                        % otherwise
                    else
                        
                        % modify the cortical multipliers of the vertices 
                        % on both sides of the new vertex
                        d.cells(k).cortex.vertexMultipliers = [d.cells(k).cortex.vertexMultipliers(1:longIdx(i)-1) ; (originals(longIdx(i)-1) + originals(longIdx(i)))./2 ; (originals(longIdx(i)-1) + originals(longIdx(i)))./2 ; d.cells(k).cortex.vertexMultipliers(longIdx(i)+1:end)];
                    end
                    
                    % with optogenetic or stretching simulation, update the
                    % focal adhesions and edge vertices
                    if any(d.simset.simulationType == [3,5])
                        d = add_focal_adhesions(d, k, longIdx(i), 1);
                        d = add_new_edge_vertices(d, k, longIdx(i), 1);
                    end
                    
                    % last vertex of the cell
                else
                    
                    % creates a new vertex to the midway between the two
                    % vertices with long section
                    newVertexX = (d.cells(k).verticesX(end) + d.cells(k).verticesX(1))/2;
                    newVertexY = (d.cells(k).verticesY(end) + d.cells(k).verticesY(1))/2;
                    
                    % add the new vertex into the coordinate vectors
                    d.cells(k).verticesX = [d.cells(k).verticesX ; newVertexX];
                    d.cells(k).verticesY = [d.cells(k).verticesY ; newVertexY];
                    
                    % add the new vertex into the vertexStates vector
                    d.cells(k).vertexStates = [d.cells(k).vertexStates ; 0];
                    
                    % add the new vertex into the junctions matrices
                    d.cells(k).junctions.cells = [d.cells(k).junctions.cells ; [0 0]];
                    d.cells(k).junctions.vertices = [d.cells(k).junctions.vertices ; [0 0]];
                    
                    % comment later
                    originals = d.cells(k).cortex.vertexMultipliers;
                    d.cells(k).cortex.vertexMultipliers(end) = (originals(end-1) + originals(end))./2;
                    d.cells(k).cortex.vertexMultipliers = [d.cells(k).cortex.vertexMultipliers ; (originals(end-1) + originals(end))./2;];
                    
                    % with optogenetic or stretching simulation, update the
                    % focal adhesions and edge vertices
                    if any(d.simset.simulationType == [3,5])
                        d = add_focal_adhesions(d, k, longIdx(i),2);
                        d = add_new_edge_vertices(d, k, longIdx(i),2);
                    end
                end
                
                
                % update the number of vertices
                d.cells(k).nVertices = d.cells(k).nVertices + 1;
                
                % find the vertices that have at least one junction and those that have
                % two junctions
                d.cells(k).junctions.linkedIdx1 = find(d.cells(k).vertexStates > 0);
                d.cells(k).junctions.linkedIdx2 = find(d.cells(k).vertexStates == 2);
                
                % go through the first and second junctions
                for j = 1:2
                    
                    % temporary variable
                    if j == 1
                        junctions2UpdateIdx = d.cells(k).junctions.linkedIdx1;
                    else
                        junctions2UpdateIdx = d.cells(k).junctions.linkedIdx2;
                    end
                    
                    % remove indices for vertices that were not affected by the new vertex
                    junctions2UpdateIdx(junctions2UpdateIdx <= longIdx(i)) = [];
                    
                    % if these vertices exist
                    if numel(junctions2UpdateIdx) > 0
                        
                        % go through the junctions
                        for j2 = junctions2UpdateIdx'
                            
                            % temporary indices
                            cellID = d.cells(k).junctions.cells(j2,j);
                            vertexID = d.cells(k).junctions.vertices(j2,j);
                            
                            % find if this is the first or decond junction for the pair
                            whichJunction = find(d.cells(cellID).junctions.cells(vertexID,:) == k);
                            
                            % update the junction pairs
                            d.cells(cellID).junctions.vertices(vertexID,whichJunction) = d.cells(cellID).junctions.vertices(vertexID,whichJunction) + 1;
                            
                            % update the pairVertices vectors for the pair
                            if ~d.simset.junctionModification
                                if whichJunction == 1
                                    tempIdx = d.cells(cellID).junctions.linkedIdx1 == vertexID;
                                    d.cells(cellID).junctions.pairVertices1(tempIdx) = d.cells(cellID).junctions.pairVertices1(tempIdx) + 1;
                                else
                                    tempIdx = d.cells(cellID).junctions.linkedIdx2 == vertexID;
                                    d.cells(cellID).junctions.pairVertices2(tempIdx) = d.cells(cellID).junctions.pairVertices2(tempIdx) + 1;
                                end
                            end 
                        end
                    end
                end
                
                % increase the indices of the following too long sections as a
                % vertex was added into the cell
                longIdx = longIdx + 1;
            end
            
            % calculate the boundary vectors and lengths
            d.cells(k) = get_boundary_vectors(d.cells(k));
            d.cells(k) = get_boundary_lengths(d.cells(k));
        end
    end
end

% go through the cells to which vertices have been added
for k = find(verticesAdded)
    
    % get the vertex angles
    d.cells(k) = get_vertex_angles(d.cells(k));
end

end