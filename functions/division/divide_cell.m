function d = divide_cell(d, time)

% goes through the cells
for k = 1:length(d.cells)
    
    % check if the cell is in the dividing state (2) and the distance
    % between the division vertices is below divisionDistance
    if d.cells(k).division.state == 2

        if d.cells(k).division.time < time || (d.cells(k).verticesX(d.cells(k).division.vertices(1)) - d.cells(k).verticesX(d.cells(k).division.vertices(2)))^2 + (d.cells(k).verticesY(d.cells(k).division.vertices(1)) - d.cells(k).verticesY(d.cells(k).division.vertices(2)))^2 < d.cells(k).division.distanceSq
            
            d.simset.junctionModification = true;
            
            % Find the indices of the neighboring vertices to the division vertices
            if d.cells(k).division.vertices(1) == 1
                divisionVertex1Right = d.cells(k).nVertices;
                divisionVertex1Left = 2;
            else
                divisionVertex1Right = d.cells(k).division.vertices(1) - 1;
                divisionVertex1Left = d.cells(k).division.vertices(1) + 1;
            end
            
            distance = sqrt((d.cells(k).verticesX(divisionVertex1Right) - d.cells(k).verticesX(divisionVertex1Left)).^2 + (d.cells(k).verticesY(divisionVertex1Right) - d.cells(k).verticesY(divisionVertex1Left)).^2);
            
            if distance > 1.5*d.spar.junctionLength
                
                d1 = sqrt((d.cells(k).verticesX(divisionVertex1Left) - d.cells(k).verticesX(d.cells(k).division.vertices(1)))^2 + (d.cells(k).verticesY(divisionVertex1Left) - d.cells(k).verticesY(d.cells(k).division.vertices(1)))^2);
                d2 = sqrt((d.cells(k).verticesX(divisionVertex1Right) - d.cells(k).verticesX(d.cells(k).division.vertices(1)))^2 + (d.cells(k).verticesY(divisionVertex1Right) - d.cells(k).verticesY(d.cells(k).division.vertices(1)))^2);
                
                u1x = (d.cells(k).verticesX(divisionVertex1Left) - d.cells(k).verticesX(d.cells(k).division.vertices(1)))/d1;
                u1y = (d.cells(k).verticesY(divisionVertex1Left) - d.cells(k).verticesY(d.cells(k).division.vertices(1)))/d1;
                u2x = (d.cells(k).verticesX(divisionVertex1Right) - d.cells(k).verticesX(d.cells(k).division.vertices(1)))/d2;
                u2y = (d.cells(k).verticesY(divisionVertex1Right) - d.cells(k).verticesY(d.cells(k).division.vertices(1)))/d2;
                
                distanceFromDivVertex = sqrt(d.spar.junctionLength^2/((u1x - u2x)^2 + (u1y - u2y)^2));
                
                newLeftX = d.cells(k).verticesX(d.cells(k).division.vertices(1)) + distanceFromDivVertex*u1x;
                newLeftY = d.cells(k).verticesY(d.cells(k).division.vertices(1)) + distanceFromDivVertex*u1y;
                newRightX = d.cells(k).verticesX(d.cells(k).division.vertices(1)) + distanceFromDivVertex*u2x;
                newRightY = d.cells(k).verticesY(d.cells(k).division.vertices(1)) + distanceFromDivVertex*u2y;
                
                if divisionVertex1Right == d.cells(k).nVertices
                    vertexIdx = [divisionVertex1Left divisionVertex1Right];
                    switched = 1;
                else
                    vertexIdx = [divisionVertex1Right divisionVertex1Left];
                    switched = 0;
                end
                
                d.cells = add_division_vertices(d.cells, k, switched, vertexIdx, newRightX, newRightY, newLeftX, newLeftY);
                
            end
            
            
            
            if d.cells(k).division.vertices(2) == d.cells(k).nVertices
                divisionVertex2Right = d.cells(k).nVertices-1;
                divisionVertex2Left = 1;
            else
                divisionVertex2Right = d.cells(k).division.vertices(2) - 1;
                divisionVertex2Left = d.cells(k).division.vertices(2) + 1;
            end
        
            distance = sqrt((d.cells(k).verticesX(divisionVertex2Right) - d.cells(k).verticesX(divisionVertex2Left)).^2 + (d.cells(k).verticesY(divisionVertex2Right) - d.cells(k).verticesY(divisionVertex2Left)).^2);
            
            if distance > 1.5*d.spar.junctionLength
                
                d1 = sqrt((d.cells(k).verticesX(divisionVertex2Left) - d.cells(k).verticesX(d.cells(k).division.vertices(2)))^2 + (d.cells(k).verticesY(divisionVertex2Left) - d.cells(k).verticesY(d.cells(k).division.vertices(2)))^2);
                d2 = sqrt((d.cells(k).verticesX(divisionVertex2Right) - d.cells(k).verticesX(d.cells(k).division.vertices(2)))^2 + (d.cells(k).verticesY(divisionVertex2Right) - d.cells(k).verticesY(d.cells(k).division.vertices(2)))^2);
                
                u1x = (d.cells(k).verticesX(divisionVertex2Left) - d.cells(k).verticesX(d.cells(k).division.vertices(2)))/d1;
                u1y = (d.cells(k).verticesY(divisionVertex2Left) - d.cells(k).verticesY(d.cells(k).division.vertices(2)))/d1;
                u2x = (d.cells(k).verticesX(divisionVertex2Right) - d.cells(k).verticesX(d.cells(k).division.vertices(2)))/d2;
                u2y = (d.cells(k).verticesY(divisionVertex2Right) - d.cells(k).verticesY(d.cells(k).division.vertices(2)))/d2;
                
                distanceFromDivVertex = sqrt(d.spar.junctionLength^2/((u1x - u2x)^2 + (u1y - u2y)^2));
                
                newLeftX = d.cells(k).verticesX(d.cells(k).division.vertices(2)) + distanceFromDivVertex*u1x;
                newLeftY = d.cells(k).verticesY(d.cells(k).division.vertices(2)) + distanceFromDivVertex*u1y;
                newRightX = d.cells(k).verticesX(d.cells(k).division.vertices(2)) + distanceFromDivVertex*u2x;
                newRightY = d.cells(k).verticesY(d.cells(k).division.vertices(2)) + distanceFromDivVertex*u2y;
                
                if divisionVertex2Left == 1
                    vertexIdx = [divisionVertex2Left divisionVertex2Right];
                    switched = 1;
                else
                    vertexIdx = [divisionVertex2Right divisionVertex2Left];
                    switched = 0;
                end
                
                d.cells = add_division_vertices(d.cells, k, switched,vertexIdx, newRightX, newRightY, newLeftX, newLeftY);
                
                
            end
            
            if d.cells(k).division.vertices(1) == 1
                divisionVertex1Right = d.cells(k).nVertices;
                divisionVertex1Left = 2;
            else
                divisionVertex1Right = d.cells(k).division.vertices(1) - 1;
                divisionVertex1Left = d.cells(k).division.vertices(1) + 1;
            end
            if d.cells(k).division.vertices(2) == 1
                divisionVertex2Right = d.cells(k).nVertices;
                divisionVertex2Left = 2;
            else
                divisionVertex2Right = d.cells(k).division.vertices(2) - 1;
                divisionVertex2Left = d.cells(k).division.vertices(2) + 1;
            end
            
            % create vertex vectors for the new cell
            d.cells(end+1).verticesX = d.cells(k).verticesX(divisionVertex1Left:divisionVertex2Right);
            d.cells(end).verticesY = d.cells(k).verticesY(divisionVertex1Left:divisionVertex2Right);
            
            % create vertexStates vector for the new cell
            d.cells(end).vertexStates = d.cells(k).vertexStates(divisionVertex1Left:divisionVertex2Right);
            
            % create the junctions vector for the new cell
            d.cells(end).junctions.cells = d.cells(k).junctions.cells(divisionVertex1Left:divisionVertex2Right,:);
            d.cells(end).junctions.vertices = d.cells(k).junctions.vertices(divisionVertex1Left:divisionVertex2Right,:);
            
            % modify the vertex vectors of the old cell
            if divisionVertex1Right ==  d.cells(k).nVertices
                idx = divisionVertex2Left:divisionVertex1Right;
                d.cells(k).verticesX = d.cells(k).verticesX(idx);
                d.cells(k).verticesY = d.cells(k).verticesY(idx);
                d.cells(k).vertexStates = d.cells(k).vertexStates(idx);
                d.cells(k).junctions.cells = d.cells(k).junctions.cells(idx,:);
                d.cells(k).junctions.vertices = d.cells(k).junctions.vertices(idx,:);
            elseif divisionVertex2Left == 1
                idx = 1:divisionVertex1Right;
                d.cells(k).verticesX = d.cells(k).verticesX(idx);
                d.cells(k).verticesY = d.cells(k).verticesY(idx);
                d.cells(k).vertexStates = d.cells(k).vertexStates(idx);
                d.cells(k).junctions.cells = d.cells(k).junctions.cells(idx,:);
                d.cells(k).junctions.vertices = d.cells(k).junctions.vertices(idx,:);
            else
                idx1 = 1:divisionVertex1Right;
                idx2 = divisionVertex2Left:length(d.cells(k).verticesX);
                d.cells(k).verticesX = [d.cells(k).verticesX(idx1) ; d.cells(k).verticesX(idx2)];
                d.cells(k).verticesY = [d.cells(k).verticesY(idx1) ; d.cells(k).verticesY(idx2)];
                d.cells(k).vertexStates = [d.cells(k).vertexStates(idx1) ; d.cells(k).vertexStates(idx2)];
                d.cells(k).junctions.cells = [d.cells(k).junctions.cells(idx1,:) ; d.cells(k).junctions.cells(idx2,:)];
                d.cells(k).junctions.vertices = [d.cells(k).junctions.vertices(idx1,:) ; d.cells(k).junctions.vertices(idx2,:)];            
            end
            
            % find the junctions whose pairs have to be modified for the new cell
            newJunctions2Update = find(d.cells(end).junctions.cells);
            
            if numel(newJunctions2Update) > 0
                % go through the updatable junctions of the new cell
                for i = newJunctions2Update'
                    
                    cellID = d.cells(end).junctions.cells(i);
                    vertexID = d.cells(end).junctions.vertices(i);
                    
                    whichJunction = d.cells(cellID).junctions.cells(vertexID,:) == k;
                    
                    % modify the junction data of the junction pairs of the new cell
                    d.cells(cellID).junctions.cells(vertexID,whichJunction) = length(d.cells);
                    if i <= size(d.cells(end).junctions.cells,1)
                        d.cells(cellID).junctions.vertices(vertexID,whichJunction) = i;
                    else
                         d.cells(cellID).junctions.vertices(vertexID,whichJunction) = i - size(d.cells(end).junctions.cells,1);
                    end
                end
            end
            
            % find the junctions whose pairs have to be modified for the old cell
            oldJunctions2Update = find(d.cells(k).junctions.cells);
            
            if numel(oldJunctions2Update) > 0
                % go through the updatable junctions of the old cell
                for i = oldJunctions2Update'
                    
                    cellID = d.cells(k).junctions.cells(i);
                    vertexID = d.cells(k).junctions.vertices(i);
                    
                    whichJunction = d.cells(cellID).junctions.cells(vertexID,:) == k;
                    
                    % modify the junction data of the junction pairs of the old cell
                    d.cells(cellID).junctions.cells(vertexID,whichJunction) = k;
                    if i <= size(d.cells(k).junctions.cells,1)
                        d.cells(cellID).junctions.vertices(vertexID,whichJunction) = i;
                    else
                         d.cells(cellID).junctions.vertices(vertexID,whichJunction) = i - size(d.cells(k).junctions.cells,1);
                    end
                end
            end

            
            d.cells(end).division.state = 0;
            d.cells(end).cellState = d.cells(k).cellState;
            d.cells(end).division.vertices = [0;0];
            d.cells(end).nVertices = size(d.cells(end).verticesX,1);
            if d.simset.uniformDivision
                d.cells(end).division.time = time + d.spar.divisionTimeMean + d.simset.divisionRandomNumbers(d.simset.divisionNumberCounter)*d.spar.divisionTimeSD;
                d.simset.divisionNumberCounter = d.simset.divisionNumberCounter + 1;
            else
                d.cells(end).division.time = time + d.spar.divisionTimeMean + randn*d.spar.divisionTimeSD;
            end
            d.cells(end).area = calculate_area(d.cells(end).verticesX,d.cells(end).verticesY);
            d.cells(end) = get_boundary_vectors(d.cells(end));
            d.cells(end) = get_boundary_lengths(d.cells(end));
            d.cells(end) = get_cell_perimeters(d.cells(end));
            d.cells(end) = get_boundary_vectors(d.cells(end));
            d.cells(end) = get_vertex_angles(d.cells(end));
            
            d.cells(end).normPerimeter = d.cells(end).perimeter;
             
            d.cells(end).division.targetArea = 0;
            
            cellNumberVector = (1:length(d.cells))';
            d.cells(end).junctions.linkedIdx1 = find(d.cells(end).vertexStates == 1);
            d.cells(end).junctions.linkedIdx2 = find(d.cells(end).vertexStates == 2);
            
            d.cells(end).junctions.pairCells1 = d.cells(end).junctions.cells(d.cells(end).junctions.linkedIdx1,1);
            d.cells(end).junctions.pairCells2 = d.cells(end).junctions.cells(d.cells(end).junctions.linkedIdx2,2);
            d.cells(end).junctions.pairVertices1 = d.cells(end).junctions.vertices(d.cells(end).junctions.linkedIdx1,1);
            d.cells(end).junctions.pairVertices2 = d.cells(end).junctions.vertices(d.cells(end).junctions.linkedIdx2,2);
            if numel(d.cells(end).junctions.linkedIdx1) > 0
                P = zeros(1, max(max(d.cells(end).junctions.pairCells1),max(cellNumberVector)) ) ;
                P(d.cells(end).junctions.pairCells1) = 1;
                d.cells(end).junctions.linked2CellNumbers1 = cellNumberVector(logical(P(cellNumberVector)));
            else
                d.cells(end).junctions.linked2CellNumbers1 = 0;
            end
            if numel(d.cells(end).junctions.linkedIdx2) > 0
                P = zeros(1, max(max(d.cells(end).junctions.pairCells2),max(cellNumberVector)) ) ;
                P(d.cells(end).junctions.pairCells2) = 1;
                d.cells(end).junctions.linked2CellNumbers2 = cellNumberVector(logical(P(cellNumberVector)));
            else
                d.cells(end).junctions.linked2CellNumbers2 = 0;
            end

            d.cells(end) = set_empty_cell_properties(d.cells(end));
            
            d.cells(end).division.newAreas = zeros(2,1);
            d.cells(end).lineage = [d.cells(k).lineage length(d.cells)];

            d.cells(end).vertexCorticalTensions = d.cells(k).vertexCorticalTensions(divisionVertex1Left:divisionVertex2Right);
            
            if divisionVertex1Right ==  d.cells(k).nVertices
                idx = divisionVertex2Left:divisionVertex1Right;
                d.cells(k).vertexCorticalTensions = d.cells(k).vertexCorticalTensions(idx);
            elseif divisionVertex2Left == 1
                idx = 1:divisionVertex1Right;
                d.cells(k).vertexCorticalTensions = d.cells(k).vertexCorticalTensions(idx);
            else
                idx1 = 1:divisionVertex1Right;
                idx2 = divisionVertex2Left:d.cells(k).nVertices;
                d.cells(k).vertexCorticalTensions = [d.cells(k).vertexCorticalTensions(idx1);d.cells(k).vertexCorticalTensions(idx2)];
            end
            d.cells(end).corticalTension = d.cells(k).corticalTension;
            d.cells(end).perimeterConstant = d.cells(k).perimeterConstant;
            
            d.cells(k).division.state = 0;
            d.cells(k).cellState = d.cells(k).cellState;
            d.cells(k).division.vertices = [0;0];
            d.cells(k).nVertices = size(d.cells(k).verticesX,1);
            if d.simset.uniformDivision
                d.cells(k).division.time = time + d.spar.divisionTimeMean + d.simset.divisionRandomNumbers(d.simset.divisionNumberCounter)*d.spar.divisionTimeSD;
                d.simset.divisionNumberCounter = d.simset.divisionNumberCounter + 1;
            else
                d.cells(k).division.time = time + d.spar.divisionTimeMean + randn*d.spar.divisionTimeSD;
            end
            d.cells(k).area = calculate_area(d.cells(k).verticesX,d.cells(k).verticesY);
            d.cells(k) = get_boundary_vectors(d.cells(k));
            d.cells(k) = get_boundary_lengths(d.cells(k));
            d.cells(k) = get_cell_perimeters(d.cells(k));
            d.cells(k) = get_vertex_angles(d.cells(k));
            
            d.cells(k).normPerimeter = d.cells(k).perimeter;
            d.cells(k).division.targetArea = 0;
            
            d.cells(k).junctions.linkedIdx1 = find(d.cells(k).vertexStates == 1);
            d.cells(k).junctions.linkedIdx2 = find(d.cells(k).vertexStates == 2);
            d.cells(k).junctions.pairCells1 = d.cells(k).junctions.cells(d.cells(k).junctions.linkedIdx1,1);
            d.cells(k).junctions.pairCells2 = d.cells(k).junctions.cells(d.cells(k).junctions.linkedIdx2,2);
            d.cells(k).junctions.pairVertices1 = d.cells(k).junctions.vertices(d.cells(k).junctions.linkedIdx1,1);
            d.cells(k).junctions.pairVertices2 = d.cells(k).junctions.vertices(d.cells(k).junctions.linkedIdx2,2);
            if numel(d.cells(k).junctions.linkedIdx1) > 0
                P = zeros(1, max(max(d.cells(k).junctions.pairCells1),max(cellNumberVector)) ) ;
                P(d.cells(k).junctions.pairCells1) = 1;
                d.cells(k).junctions.linked2CellNumbers1 = cellNumberVector(logical(P(cellNumberVector)));
            else
                d.cells(k).junctions.linked2CellNumbers1 = 0;
            end
            if numel(d.cells(k).junctions.linkedIdx2) > 0
                P = zeros(1, max(max(d.cells(k).junctions.pairCells2),max(cellNumberVector)) ) ;
                P(d.cells(k).junctions.pairCells2) = 1;
                d.cells(k).junctions.linked2CellNumbers2 = cellNumberVector(logical(P(cellNumberVector)));
            else
                d.cells(k).junctions.linked2CellNumbers2 = 0;
            end          
            
            d.cells(k) = set_empty_cell_properties(d.cells(k));
            
            
            [~,smallerCell] = min([d.cells(k).area d.cells(end).area]);
            if smallerCell == 1
                d.cells(k).normArea = min(d.cells(k).division.newAreas);
                d.cells(end).normArea = max(d.cells(k).division.newAreas);
            else
                d.cells(k).normArea = max(d.cells(k).division.newAreas);
                d.cells(end).normArea = min(d.cells(k).division.newAreas);
            end

            d.cells(k).division.newAreas = zeros(2,1);
            
        end
    end
end

end