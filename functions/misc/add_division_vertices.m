function d = add_division_vertices(d, k, divisionVertex, divisionVertexRight, divisionVertexLeft)
% ADD_DIVISION_VERTICES Adds new vertices on both sides of a division
% vertex
%   The function adds new vertices one both sides of a division vertex if
%   the current neighbors are too far apart.
%   INPUTS:
%       d: main simulation data structure
%       k: current cell index
%       divisionVertex: one of the division vertices
%       divisionVertexRight: index of the vertex on the right side of the
%           division vertex
%       divisionVertexLeft: index of the vertex on the left side of the
%           division vertex
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% distance between the division vertex and the left and
% right neighbors
distanceLeft = sqrt((d.cells(k).verticesX(divisionVertexLeft) - d.cells(k).verticesX(divisionVertex))^2 + (d.cells(k).verticesY(divisionVertexLeft) - d.cells(k).verticesY(divisionVertex))^2);
distanceRight = sqrt((d.cells(k).verticesX(divisionVertexRight) - d.cells(k).verticesX(divisionVertex))^2 + (d.cells(k).verticesY(divisionVertexRight) - d.cells(k).verticesY(divisionVertex))^2);

% unit vectors from the division vertex towards the two
% neighbors
leftUnitX = (d.cells(k).verticesX(divisionVertexLeft) - d.cells(k).verticesX(divisionVertex))/distanceLeft;
leftUnitY = (d.cells(k).verticesY(divisionVertexLeft) - d.cells(k).verticesY(divisionVertex))/distanceLeft;
rightUnitX = (d.cells(k).verticesX(divisionVertexRight) - d.cells(k).verticesX(divisionVertex))/distanceRight;
rightUnitY = (d.cells(k).verticesY(divisionVertexRight) - d.cells(k).verticesY(divisionVertex))/distanceRight;

% find the distance that has to be travelled from the
% division vertex 1 towards both neighbors that will
% produce the distance of normal junction length between
% these two locations
distanceFromDivVertex = sqrt(d.spar.junctionLength^2/((leftUnitX - rightUnitX)^2 + (leftUnitY - rightUnitY)^2));

% find the coordinates of the new vertices separted by the
% normal junction length
newCoords.LeftX = d.cells(k).verticesX(divisionVertex) + distanceFromDivVertex*leftUnitX;
newCoords.LeftY = d.cells(k).verticesY(divisionVertex) + distanceFromDivVertex*leftUnitY;
newCoords.RightX = d.cells(k).verticesX(divisionVertex) + distanceFromDivVertex*rightUnitX;
newCoords.RightY = d.cells(k).verticesY(divisionVertex) + distanceFromDivVertex*rightUnitY;

% check if the original right neighbor is the last vertex
% in the cell, if yes, put the left neighbor first, since
% it has a smaller index
if divisionVertexRight == d.cells(k).nVertices
    vertexIdx = [divisionVertexLeft divisionVertexRight];
    leftIndexSmaller = 1;
else
    vertexIdx = [divisionVertexRight divisionVertexLeft];
    leftIndexSmaller = 0;
end

% goes through the neighboring vertices
for i = 1:2
    
    % if left neighbor has smaller index
    if leftIndexSmaller
        
        % left neighbor
        if i == 1
            
            % if the left neighbor index is 1
            if vertexIdx(i) == 1
                
                % set the newIndex to the last index (since the new point
                % is added following a vertex, not before it)
                vertexIdx(i) = d.cells(k).nVertices;
            else
                
                % otherwise, get the previous index
                vertexIdx(i) = vertexIdx(i) - 1;
            end
            
            % the new vertex coordinates
            newVertexX = newCoords.LeftX;
            newVertexY = newCoords.LeftY;
            
        % right neighbor
        elseif i == 2
            
            % the new vertex coordinates
            newVertexX = newCoords.RightX;
            newVertexY = newCoords.RightY;
        end
     
    % if right neighbor has smaller index
    else
        
        % right neighbor
        if i == 1
            
            % the new vertex coordinates
            newVertexX = newCoords.RightX;
            newVertexY = newCoords.RightY;
            
        % left neighbor
        elseif i == 2
            
            % reduce the index by one and get the new vertex coordinates
            vertexIdx(i) = vertexIdx(i) - 1;
            newVertexX = newCoords.LeftX;
            newVertexY = newCoords.LeftY;
        end
    end
    
    % the case when too long section is the last one is dealt separately
    if vertexIdx(i) < d.cells(k).nVertices
        
        % add the new vertex into the boundaryVertices matrix
        d.cells(k).verticesX = [d.cells(k).verticesX(1:vertexIdx(i)) ; newVertexX ; d.cells(k).verticesX(vertexIdx(i)+1:end)];
        d.cells(k).verticesY = [d.cells(k).verticesY(1:vertexIdx(i)) ; newVertexY ; d.cells(k).verticesY(vertexIdx(i)+1:end)];
        
        % add the new vertex into the vertexStates vector
        d.cells(k).vertexStates = [d.cells(k).vertexStates(1:vertexIdx(i)) ; 0 ; d.cells(k).vertexStates(vertexIdx(i)+1:end)];
        
        % update the divisionVertices vector
        d.cells(k).division.vertices = d.cells(k).division.vertices + 1.*(d.cells(k).division.vertices > vertexIdx(i));
        
        % add the new vertex into the junctions matrix
        d.cells(k).junctions.cells = [d.cells(k).junctions.cells(1:vertexIdx(i),:) ; [0 0] ; d.cells(k).junctions.cells(vertexIdx(i)+1:end,:)];
        d.cells(k).junctions.vertices = [d.cells(k).junctions.vertices(1:vertexIdx(i),:) ; [0 0] ; d.cells(k).junctions.vertices(vertexIdx(i)+1:end,:)];

        % modify the vertex cortical multipliers
        originals = d.cells(k).cortex.vertexMultipliers;
        
        % if first index
        if vertexIdx(i) == 1
            
            % modify the cortical multipliers of the vertices on both sides
            % of the new vertex
            d.cells(k).cortex.vertexMultipliers = [(originals(end) + originals(1))./2 ; (originals(end) + originals(1))./2 ; d.cells(k).cortex.vertexMultipliers(2:end)];
        
        % otherwise
        else
            
            % modify the cortical multipliers of the vertices on both sides
            % of the new vertex
            d.cells(k).cortex.vertexMultipliers = [d.cells(k).cortex.vertexMultipliers(1:vertexIdx(i)-1) ; (originals(vertexIdx(i)-1) + originals(vertexIdx(i)))./2 ; (originals(vertexIdx(i)-1) + originals(vertexIdx(i)))./2 ; d.cells(k).cortex.vertexMultipliers(vertexIdx(i)+1:end)];
        end
    
    % last vertex in the cell
    else
        
        % add the new vertex into the boundaryVertices matrix
        d.cells(k).verticesX = [d.cells(k).verticesX ; newVertexX];
        d.cells(k).verticesY = [d.cells(k).verticesY ; newVertexY];
        
        % add the new vertex into the vertexStates vector
        d.cells(k).vertexStates = [d.cells(k).vertexStates ; 0];
        
        % add the new vertex into the junctions matrix
        d.cells(k).junctions.cells = [d.cells(k).junctions.cells ; [0 0]];
        d.cells(k).junctions.vertices = [d.cells(k).junctions.vertices ; [0 0]];

        % modify the cortical multipliers on both sides of the new vertex
        % by setting them to the average of the two cortical links that
        % span over the new vertex
        originals = d.cells(k).cortex.vertexMultipliers;
        d.cells(k).cortex.vertexMultipliers(end) = (originals(end-1) + originals(end))./2;
        d.cells(k).cortex.vertexMultipliers = [d.cells(k).cortex.vertexMultipliers ; (originals(end-1) + originals(end))./2;];
        
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
        junctions2UpdateIdx(junctions2UpdateIdx <= vertexIdx(i)) = [];
        
        % if these vertices exist
        if numel(junctions2UpdateIdx) > 0
            
            % go through the junctions
            for j2 = junctions2UpdateIdx'
                
                % temporary indices
                cellID = d.cells(k).junctions.cells(j2,j);
                vertexID = d.cells(k).junctions.vertices(j2,j);
                
                % find if this is the first or decond junction for the pair
                whichJunction = d.cells(cellID).junctions.cells(vertexID,:) == k;
                
                % update the junction pairs
                d.cells(cellID).junctions.vertices(vertexID,whichJunction) = d.cells(cellID).junctions.vertices(vertexID,whichJunction) + 1;
                
%                 % update the pairVertices vectors for the pair
%                 if whichJunction == 1
%                     tempIdx = d.cells(cellID).junctions.linkedIdx1 == vertexID;
%                     d.cells(cellID).junctions.pairVertices1(tempIdx) = d.cells(cellID).junctions.pairVertices1(tempIdx) + 1;
%                 else
%                     tempIdx = d.cells(cellID).junctions.linkedIdx2 == vertexID;
%                     d.cells(cellID).junctions.pairVertices2(tempIdx) = d.cells(cellID).junctions.pairVertices2(tempIdx) + 1;
%                 end
            end
        end
    end
    
    % add one to the new indices
    vertexIdx = vertexIdx + 1;
end
