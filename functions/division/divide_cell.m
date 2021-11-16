function d = divide_cell(d, time)
% DIVIDE_CELL Divides a cells into two daughter cell
%   The function goes through each cell to check if they are in a
%   cytokinesis state (division state = 2) and if the distance between the
%   division vertices is below a predefined division distance or if the
%   cytokinesis time has been passed. When on of these conditions is
%   fulfilled, the new vertices are placed on next to division vertices
%   that are then used to divide the cell into two by dividing the vertex
%   properties between the cells.
%   INPUTS:
%       d: main simulation data structure
%       time: current simulation time
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% goes through the cells
for k = 1:length(d.cells)
    
    % check if the cell is in the cytokinesis state (2)
    if d.cells(k).division.state == 2
        
        % check if the cytokinesis time has been passed or if the distance
        % between the division vertices is below divisionDistance
        if d.cells(k).division.time < time || (d.cells(k).verticesX(d.cells(k).division.vertices(1)) - d.cells(k).verticesX(d.cells(k).division.vertices(2)))^2 + (d.cells(k).verticesY(d.cells(k).division.vertices(1)) - d.cells(k).verticesY(d.cells(k).division.vertices(2)))^2 < d.cells(k).division.distanceSq
            
            % modify junctions following the division
            d.simset.junctionModification = true;
            
            % go through the two division vertices
            for i = 1:2
                
                % Find the indices of the neighboring the division vertex
                if d.cells(k).division.vertices(i) == 1
                    divisionVertexRight = d.cells(k).nVertices;
                    divisionVertexLeft = 2;
                elseif d.cells(k).division.vertices(i) == d.cells(k).nVertices
                    divisionVertexRight = d.cells(k).nVertices-1;
                    divisionVertexLeft = 1;
                else
                    divisionVertexRight = d.cells(k).division.vertices(i) - 1;
                    divisionVertexLeft = d.cells(k).division.vertices(i) + 1;
                end
                
                % calculate the distance between the neighboring vertices
                distance = sqrt((d.cells(k).verticesX(divisionVertexRight) - d.cells(k).verticesX(divisionVertexLeft)).^2 + (d.cells(k).verticesY(divisionVertexRight) - d.cells(k).verticesY(divisionVertexLeft)).^2);
                
                % if the distance is above the normal junction length, add
                % new vertices on each side separated by the normal
                % junction length
                if distance > d.spar.junctionLength*1.5
                                        
                    % add the new vertices on each side of the first division
                    % vertex
                    d = add_division_vertices(d, k, d.cells(k).division.vertices(i), divisionVertexRight,divisionVertexLeft);
                end
            end
            
            % get the neighboring points
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
            
            % get vertex coordinate vectors for the new cell
            d.cells(end+1).verticesX = d.cells(k).verticesX(divisionVertex1Left:divisionVertex2Right);
            d.cells(end).verticesY = d.cells(k).verticesY(divisionVertex1Left:divisionVertex2Right);
            
            % get vertex velocities for the new cell
            d.cells(end).velocitiesX = d.cells(k).velocitiesX(divisionVertex1Left:divisionVertex2Right);
            d.cells(end).velocitiesY = d.cells(k).velocitiesY(divisionVertex1Left:divisionVertex2Right);
            
            % get vertexStates vector for the new cell
            d.cells(end).vertexStates = d.cells(k).vertexStates(divisionVertex1Left:divisionVertex2Right);
            
            % get the junctions matrices for the new cell
            d.cells(end).junctions.cells = d.cells(k).junctions.cells(divisionVertex1Left:divisionVertex2Right,:);
            d.cells(end).junctions.vertices = d.cells(k).junctions.vertices(divisionVertex1Left:divisionVertex2Right,:);

            % get the indices of the vertex that have one or two junctions
            d.cells(end).junctions.linkedIdx1 = find(d.cells(end).vertexStates > 0);
            d.cells(end).junctions.linkedIdx2 = find(d.cells(end).vertexStates == 2);
            
            % get the cortical multipliers for the new cell
            d.cells(end).cortex.vertexMultipliers = d.cells(k).cortex.vertexMultipliers(divisionVertex1Left:divisionVertex2Right);
            
            % edit forces
            d.cells(end).forces.dampingX = d.cells(k).forces.dampingX(divisionVertex1Left:divisionVertex2Right);
            d.cells(end).forces.dampingY = d.cells(k).forces.dampingY(divisionVertex1Left:divisionVertex2Right);
            d.cells(end).forces.divisionX = zeros(size(d.cells(end).verticesX));
            d.cells(end).forces.divisionY = zeros(size(d.cells(end).verticesX));
            d.cells(end).forces.junctionX = d.cells(k).forces.junctionX(divisionVertex1Left:divisionVertex2Right);
            d.cells(end).forces.junctionY = d.cells(k).forces.junctionY(divisionVertex1Left:divisionVertex2Right);
                    
            
            % modify the vertex coordinate vectors, the vertexState 
            % vectors, junction matrices, and the cortical multipliers of
            % the old cell
            
            % if first division vertex has the index of 1
            if divisionVertex1Right ==  d.cells(k).nVertices
                idx = divisionVertex2Left:divisionVertex1Right;
                d.cells(k).verticesX = d.cells(k).verticesX(idx);
                d.cells(k).verticesY = d.cells(k).verticesY(idx);
                d.cells(k).velocitiesX = d.cells(k).velocitiesX(idx);
                d.cells(k).velocitiesY = d.cells(k).velocitiesY(idx);
                d.cells(k).vertexStates = d.cells(k).vertexStates(idx);
                d.cells(k).junctions.cells = d.cells(k).junctions.cells(idx,:);
                d.cells(k).junctions.vertices = d.cells(k).junctions.vertices(idx,:);
                d.cells(k).cortex.vertexMultipliers = d.cells(k).cortex.vertexMultipliers(idx);
                d.cells(k).forces.dampingX = d.cells(k).forces.dampingX(idx);
                d.cells(k).forces.dampingY = d.cells(k).forces.dampingY(idx);
                d.cells(k).forces.junctionX = d.cells(k).forces.junctionX(idx);
                d.cells(k).forces.junctionY = d.cells(k).forces.junctionY(idx);
                
            % if the second division vertex has the index of nVertices
            elseif divisionVertex2Left == 1
                idx = 1:divisionVertex1Right;
                d.cells(k).verticesX = d.cells(k).verticesX(idx);
                d.cells(k).verticesY = d.cells(k).verticesY(idx);
                d.cells(k).velocitiesX = d.cells(k).velocitiesX(idx);
                d.cells(k).velocitiesY = d.cells(k).velocitiesY(idx);
                d.cells(k).vertexStates = d.cells(k).vertexStates(idx);
                d.cells(k).junctions.cells = d.cells(k).junctions.cells(idx,:);
                d.cells(k).junctions.vertices = d.cells(k).junctions.vertices(idx,:);
                d.cells(k).cortex.vertexMultipliers = d.cells(k).cortex.vertexMultipliers(idx);
                d.cells(k).forces.dampingX = d.cells(k).forces.dampingX(idx);
                d.cells(k).forces.dampingY = d.cells(k).forces.dampingY(idx);
                d.cells(k).forces.junctionX = d.cells(k).forces.junctionX(idx);
                d.cells(k).forces.junctionY = d.cells(k).forces.junctionY(idx);
                
            % otherwise
            else
                idx1 = 1:divisionVertex1Right;
                idx2 = divisionVertex2Left:length(d.cells(k).verticesX);
                d.cells(k).verticesX = [d.cells(k).verticesX(idx1) ; d.cells(k).verticesX(idx2)];
                d.cells(k).verticesY = [d.cells(k).verticesY(idx1) ; d.cells(k).verticesY(idx2)];
                d.cells(k).velocitiesX = [d.cells(k).velocitiesX(idx1) ; d.cells(k).velocitiesX(idx2)];
                d.cells(k).velocitiesY = [d.cells(k).velocitiesY(idx1) ; d.cells(k).velocitiesY(idx2)];
                d.cells(k).vertexStates = [d.cells(k).vertexStates(idx1) ; d.cells(k).vertexStates(idx2)];
                d.cells(k).junctions.cells = [d.cells(k).junctions.cells(idx1,:) ; d.cells(k).junctions.cells(idx2,:)];
                d.cells(k).junctions.vertices = [d.cells(k).junctions.vertices(idx1,:) ; d.cells(k).junctions.vertices(idx2,:)];  
                d.cells(k).cortex.vertexMultipliers = [d.cells(k).cortex.vertexMultipliers(idx1);d.cells(k).cortex.vertexMultipliers(idx2)];
                d.cells(k).forces.dampingX = [d.cells(k).forces.dampingX(idx1);d.cells(k).forces.dampingX(idx2)]; 
                d.cells(k).forces.dampingY = [d.cells(k).forces.dampingY(idx1);d.cells(k).forces.dampingY(idx2)];
                d.cells(k).forces.junctionX = [d.cells(k).forces.junctionX(idx1);d.cells(k).forces.junctionX(idx2)]; 
                d.cells(k).forces.junctionY = [d.cells(k).forces.junctionY(idx1);d.cells(k).forces.junctionY(idx2)]; 
            end

            
            d.cells(k).forces.divisionX = zeros(size(d.cells(k).verticesX));
            d.cells(k).forces.divisionY = zeros(size(d.cells(k).verticesX));
            
            % get the indices of the vertex that have one or two junctions
            d.cells(k).junctions.linkedIdx1 = find(d.cells(k).vertexStates > 0);
            d.cells(k).junctions.linkedIdx2 = find(d.cells(k).vertexStates == 2);
            
            % update junction pairs' data for both the new and old cells
            for k2 = [length(d.cells) k]
                
                % find the linear indices of the junctions whose pairs have
                % to be modified for the cell
                junctions2Update = find(d.cells(k2).junctions.cells);
                
                % if they exist
                if numel(junctions2Update) > 0
                    
                    % go through the junctions to update for the new cell
                    for i = junctions2Update'
                        
                        % temporary indices
                        cellID = d.cells(k2).junctions.cells(i);
                        vertexID = d.cells(k2).junctions.vertices(i);
                        
                        % which junction this is for the pair
                        whichJunction = d.cells(cellID).junctions.cells(vertexID,:) == k;
                        
                        % modify the junction data of the junction pairs of the new cell
                        if k ~= k2
                            d.cells(cellID).junctions.cells(vertexID,whichJunction) = length(d.cells);
                        end
                        
                        % check if this is the first of the second junction for
                        % the curren point (i.e., if the linear index is higher
                        % than the number of rows in the junction.cells matrix)
                        if i <= size(d.cells(k2).junctions.cells,1)
                            d.cells(cellID).junctions.vertices(vertexID,whichJunction) = i;
                        else
                            d.cells(cellID).junctions.vertices(vertexID,whichJunction) = i - size(d.cells(k2).junctions.cells,1);
                        end
                    end
                end
            end

            % new cell
            
            % set and initialize various properties for the new cell
            d.cells(end).division.state = 0;
            d.cells(end).cellState = d.cells(k).cellState;
            d.cells(end).division.vertices = [0;0];
            d.cells(end).division.targetArea = 0;
            d.cells(end).division.newAreas = zeros(2,1);
            d.cells(end).division.distanceSq = 0;
            d.cells(end).nVertices = size(d.cells(end).verticesX,1);
            d.cells(end).lineage = [d.cells(k).lineage length(d.cells)];
            d.cells(end).cortex.fCortex = d.cells(k).cortex.fCortex;
            d.cells(end).cortex.perimeterConstant = d.cells(k).cortex.perimeterConstant;
            d.cells(end).area = calculate_area(d.cells(end).verticesX,d.cells(end).verticesY);
            d.cells(end) = get_boundary_vectors(d.cells(end));
            d.cells(end) = get_boundary_lengths(d.cells(end));
            d.cells(end) = get_cell_perimeters(d.cells(end));
            d.cells(end) = get_boundary_vectors(d.cells(end));
            d.cells(end) = get_vertex_angles(d.cells(end));
            d.cells(end).normPerimeter = d.cells(end).perimeter;
%             d.cells(end) = set_empty_cell_properties(d.cells(end));
            
            % get the division time for the new cell (either based on the
            % predefined values or random values)
            if d.simset.division.uniform
                d.cells(end).division.time = time + d.spar.divisionTimeMean + d.simset.division.randomNumbers(d.simset.division.counter)*d.spar.divisionTimeSD;
                d.simset.division.counter = d.simset.division.counter + 1;
            else
                d.cells(end).division.time = time + d.spar.divisionTimeMean + randn*d.spar.divisionTimeSD;
            end
            
            % old cell

            % set various properties for the new cell
            d.cells(k).division.state = 0;
            d.cells(k).cellState = d.cells(k).cellState;
            d.cells(k).division.vertices = [0;0];
            d.cells(k).division.targetArea = 0;
            d.cells(k).nVertices = size(d.cells(k).verticesX,1);
            d.cells(k).area = calculate_area(d.cells(k).verticesX,d.cells(k).verticesY);
            d.cells(k) = get_boundary_vectors(d.cells(k));
            d.cells(k) = get_boundary_lengths(d.cells(k));
            d.cells(k) = get_cell_perimeters(d.cells(k));
            d.cells(k) = get_vertex_angles(d.cells(k));
            d.cells(k).normPerimeter = d.cells(k).perimeter;
%             d.cells(k) = set_empty_cell_properties(d.cells(k));
            
            % get the division time for the old cell (either based on the
            % predefined values or random values)
            if d.simset.division.uniform
                d.cells(k).division.time = time + d.spar.divisionTimeMean + d.simset.division.randomNumbers(d.simset.division.counter)*d.spar.divisionTimeSD;
                d.simset.division.counter = d.simset.division.counter + 1;
            else
                d.cells(k).division.time = time + d.spar.divisionTimeMean + randn*d.spar.divisionTimeSD;
            end
            
            % check if the the old or the new cell is smaller
            [~,smallerCell] = min([d.cells(k).area d.cells(end).area]);
            
            % if the old cell is smaller
            if smallerCell == 1
                
                % assign the smaller new daugter cell areas as the normal
                % area for the old cell and the larger for the new cell
                d.cells(k).normArea = min(d.cells(k).division.newAreas);
                d.cells(end).normArea = max(d.cells(k).division.newAreas);
                
            % otherwise
            else
                
                % assign the smaller new daugter cell areas as the normal
                % area for the new cell and the larger for the old cell
                d.cells(k).normArea = max(d.cells(k).division.newAreas);
                d.cells(end).normArea = min(d.cells(k).division.newAreas);
            end

            % reset the new areas for the old cell
            d.cells(k).division.newAreas = zeros(2,1);
            
            d.simset.calculateForces.area = [d.simset.calculateForces.area; true];
            d.simset.calculateForces.cortical = [d.simset.calculateForces.cortical; true];
            d.simset.calculateForces.all = [d.simset.calculateForces.area; false];
            d.simset.calculateForces.junction = [d.simset.calculateForces.area; false];
            d.simset.calculateForces.membrane = [d.simset.calculateForces.membrane; true];
            d.simset.calculateForces.division = [d.simset.calculateForces.division; true];
            
            d.simset.calculateForces.all(k) = true;
            d.simset.calculateForces.area(k) = true;
            d.simset.calculateForces.cortical(k) = true;
            d.simset.calculateForces.all(k) = false;
            d.simset.calculateForces.junction(k) = false;
            d.simset.calculateForces.membrane(k) = true;
            d.simset.calculateForces.division(k) = true;
        end
    end
end

end