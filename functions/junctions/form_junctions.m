function d = form_junctions(d)
% FORM_JUNCTIONS Defines new junctions between cells
%   The functions goes through the cells and find suitable junctions
%   between vertices based on the possible pair data found in the
%   find_closest_vertices function. Possible junctions are checked based on
%   their distance, angle, and intersection between other junctions before
%   they are created.
%   INPUTS:
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

%  check that there are more than one cell
if length(d.cells) > 1
    
    % go through the cells
    for k = 1:size(d.cells,2)
        
        % if there are possible junction vertices
        if ~isempty(d.cells(k).junctions.possible.vertices)
            
            % get the indices of the vertices with possible junctions
            possibleJunctionVertices = d.cells(k).junctions.possible.vertices;
            
            % get the data related to the new possible junctions
            suitablePairCellsAll = d.cells(k).junctions.possible.pairCellIDs;
            suitablePairVerticesAll = d.cells(k).junctions.possible.pairVertexIDs;
            suitablePairVerticesXAll = d.cells(k).junctions.possible.pairVerticesX;
            suitablePairVerticesYAll = d.cells(k).junctions.possible.pairVerticesY;
            
            % maximum number of possible pairs for each possible junction 
            [~, numberOfPossibles] = max(cumsum(~isnan(suitablePairCellsAll), 1));
            
            % go through the vertices that have possible pairs
            for i = 1:length(possibleJunctionVertices)
                
                % temporary index
                tempIdx = possibleJunctionVertices(i);
                
                % suitable pair data for this vertex
                suitablePairCells = suitablePairCellsAll(:,i);
                suitablePairVertices = suitablePairVerticesAll(:,i);
                
                % variable used to check if there is at least one possible
                % junction
                atLeastOne = false;
                
                % variable used to check if the current vertex has already
                % a junction with a cell
                sameCell = zeros(numberOfPossibles(i),1);
                
                % Go through the possible pairs
                for i2 = 1:numberOfPossibles(i)
                    
                    % if the suitable pair is not a NaN
                    if ~isnan(suitablePairCells(i2))
                        
                        % find the index of the pair vertex in the
                        % possible junction data of the pair cell
                        pairIdx = find(d.cells(suitablePairCells(i2)).junctions.possible.vertices ==  suitablePairVertices(i2));
                        
                        % find the cell index of the closest nonNaN
                        % possible junction pair for the pair
                        firstNonNan = find(~isnan(d.cells(suitablePairCells(i2)).junctions.possible.pairCellIDs(:,pairIdx)),1);
                        
                        % Check that (1) the pair vertex is in the vector
                        % of possible junction vertices for the other cell,
                        % (2) the pair does not exist in a cell that
                        % the vertex already has a junction with, (3)
                        % the vertex state of the possible pair is 0 or 1
                        % (it can have at least on more junction) and if
                        % the vertex state is 1, that the current junction
                        % of the pair is not with cell k, (4) the
                        % current vertex is the closest nonNaN vertex for
                        % the pair, and (5) the closest nonNaN vertex
                        % is the in the current cell
                        if ~isempty(pairIdx) && ~sameCell(i2) ...
                                && (d.cells(suitablePairCells(i2)).vertexStates(suitablePairVertices(i2)) == 0 ...
                                || (d.cells(suitablePairCells(i2)).vertexStates(suitablePairVertices(i2)) == 1 && d.cells(suitablePairCells(i2)).junctions.cells(suitablePairVertices(i2),1) ~= k)) ...
                                && d.cells(suitablePairCells(i2)).junctions.possible.pairVertexIDs(firstNonNan,pairIdx) == tempIdx...
                                && d.cells(suitablePairCells(i2)).junctions.possible.pairCellIDs(firstNonNan,pairIdx) == k
                            
                            % if there is at least one possible junction
                            % (to pass the first set of tests)
                            if ~atLeastOne

                                % get the pair vertex coordinate data
                                % (otherwise this would be in vain, since
                                % it is not needed in the first check)
                                suitablePairVerticesX = suitablePairVerticesXAll(:,i);
                                suitablePairVerticesY = suitablePairVerticesYAll(:,i);
                                
                                % this is only done once, so set atLeastOne
                                % to true
                                atLeastOne = true;
                            end
                            
                            % get the outside angels and right vector data
                            % for the possible pair
                            suitablePairOutsideAngles = d.cells(suitablePairCells(i2)).outsideAngles(suitablePairVertices(i2));
                            suitablePairRigthVectorsX = d.cells(suitablePairCells(i2)).rightVectorsX(suitablePairVertices(i2));
                            suitablePairRigthVectorsY = d.cells(suitablePairCells(i2)).rightVectorsY(suitablePairVertices(i2));
                        
                            % if the current vertex already has a junction,
                            % check if the existing pair has two junctions
                            pairsPairCrosslinkCheck = d.cells(k).vertexStates(tempIdx) == 1 && d.cells(d.cells(k).junctions.cells(tempIdx,1)).vertexStates(d.cells(k).junctions.vertices(tempIdx,1)) == 2;
                            
                            % if the existing pair has two junctions
                            if pairsPairCrosslinkCheck
                                
                                % the index data for the possible pair
                                newPairCellID = suitablePairCells(i2);
                                newPairVertexID = suitablePairVertices(i2);
                                
                                % the index data for the existing pair
                                existingPairCellID = d.cells(k).junctions.cells(tempIdx,1);
                                existingPairVertexID = d.cells(k).junctions.vertices(tempIdx,1);
                                
                                % the index data for the other pair of the
                                % existing pair
                                pairOtherJunction = ~(d.cells(existingPairCellID).junctions.cells(existingPairVertexID,:) == k);
                                pairsPairCellID = d.cells(existingPairCellID).junctions.cells(existingPairVertexID,pairOtherJunction);
                                pairsPairVertexID = d.cells(existingPairCellID).junctions.vertices(existingPairVertexID,pairOtherJunction);
                            end

                            % check that (1) new junction is within the
                            % angle limits for both cells, (2) the new
                            % junction does not cross the neighboring
                            % junction in the current cell, (3) the new
                            % junction does not cross the neighboring
                            % junctions in the pair cell, and (4) if there
                            % are is a second junction for the existing 
                            % pair of the current vertex, that this
                            % existing pair does not cross the possible
                            % junction
                            if check_junction_angle_add(d.spar,d.cells(k),tempIdx,suitablePairVerticesX(i2),suitablePairVerticesY(i2),suitablePairRigthVectorsX,suitablePairRigthVectorsY,suitablePairOutsideAngles)...
                                    && check_junction_crossing(d.cells,k,tempIdx,suitablePairCells(i2),suitablePairVertices(i2))...
                                    && check_junction_crossing(d.cells,suitablePairCells(i2),suitablePairVertices(i2),k,tempIdx)...
                                    && ~(pairsPairCrosslinkCheck && ~check_line_intersection(d.cells(k).verticesX(tempIdx),d.cells(k).verticesY(tempIdx),d.cells(existingPairCellID).verticesX(existingPairVertexID),d.cells(existingPairCellID).verticesY(existingPairVertexID),d.cells(newPairCellID).verticesX(newPairVertexID),d.cells(newPairCellID).verticesY(newPairVertexID),d.cells(pairsPairCellID).verticesX(pairsPairVertexID),d.cells(pairsPairCellID).verticesY(pairsPairVertexID)))
                                
                                % if the current vertex has no junctions
                                if d.cells(k).vertexStates(tempIdx) == 0
                                    
                                    % set the vertexState to 1
                                    d.cells(k).vertexStates(tempIdx) = 1;
                                    
                                    % set the junction information
                                    d.cells(k).junctions.cells(tempIdx,1) = suitablePairCells(i2);
                                    d.cells(k).junctions.vertices(tempIdx,1) = suitablePairVertices(i2);
                                    
                                    % set all the possible junction pairs
                                    % that have the same cell as true to
                                    % prevent having another junction in
                                    % this cell for this vertex
                                    sameCell(suitablePairCells(1:numberOfPossibles(i)) == suitablePairCells(i2)) = true;
                                    
                                % if the current vertex has a junction
                                elseif d.cells(k).vertexStates(tempIdx) == 1
                                    
                                    % set the vertexState to 2
                                    d.cells(k).vertexStates(tempIdx) = 2;
                                    
                                    % set the junction information
                                    d.cells(k).junctions.cells(tempIdx,2) = suitablePairCells(i2);
                                    d.cells(k).junctions.vertices(tempIdx,2) = suitablePairVertices(i2);
                                end
                                
                                % if the pair vertex has no junctions
                                if d.cells(suitablePairCells(i2)).vertexStates(suitablePairVertices(i2)) == 0
                                    
                                    % set the vertexState of the pair to 1
                                    d.cells(suitablePairCells(i2)).vertexStates(suitablePairVertices(i2)) = 1;
                                    
                                    % set the junction information for pair
                                    % vertex
                                    d.cells(suitablePairCells(i2)).junctions.cells(suitablePairVertices(i2),1) = k;
                                    d.cells(suitablePairCells(i2)).junctions.vertices(suitablePairVertices(i2),1) = tempIdx;
                                    
                                    % find the index of the pair vertex in
                                    % the respective cells suitable
                                    % vertices vector
                                    tempInd = d.cells(suitablePairCells(i2)).junctions.possible.vertices == suitablePairVertices(i2);
                                    
                                    % set the possible pair cells that
                                    % equal the current cell to NaNs for 
                                    % the pair vertex to prevent it forming
                                    % an another junction with the current
                                    % cell
                                    d.cells(suitablePairCells(i2)).junctions.possible.pairCellIDs(d.cells(suitablePairCells(i2)).junctions.possible.pairCellIDs(:,tempInd) == k,tempInd) = NaN;
                                    
                                    % if there are no other possible
                                    % junctions for the pair, remove it and
                                    % its data from the possible junction
                                    % for the other cell
                                    if all(isnan(d.cells(suitablePairCells(i2)).junctions.possible.pairCellIDs(:,tempInd)))
                                        d.cells(suitablePairCells(i2)).junctions.possible.vertices(tempInd) = [];
                                        d.cells(suitablePairCells(i2)).junctions.possible.pairCellIDs(:,tempInd) = [];
                                        d.cells(suitablePairCells(i2)).junctions.possible.pairVertexIDs(:,tempInd) = [];
                                        d.cells(suitablePairCells(i2)).junctions.possible.distances(:,tempInd) = [];
                                        d.cells(suitablePairCells(i2)).junctions.possible.pairVerticesX(:,tempInd) = [];
                                        d.cells(suitablePairCells(i2)).junctions.possible.pairVerticesY(:,tempInd) = [];
                                    end
                                
                                % if the pair vertex has a junction
                                elseif d.cells(suitablePairCells(i2)).vertexStates(suitablePairVertices(i2)) == 1
                                    
                                    % set the vertexState of the pair to 2
                                    d.cells(suitablePairCells(i2)).vertexStates(suitablePairVertices(i2)) = 2;
                                    
                                    % set the junction information for pair
                                    % vertex
                                    d.cells(suitablePairCells(i2)).junctions.cells(suitablePairVertices(i2),2) = k;
                                    d.cells(suitablePairCells(i2)).junctions.vertices(suitablePairVertices(i2),2) = tempIdx;
                                    
                                    % find the index of the pair vertex in
                                    % the respective cells suitable
                                    % vertices vector
                                    tempInd = d.cells(suitablePairCells(i2)).junctions.possible.vertices == suitablePairVertices(i2);
                                    
                                    % remove it and its data from the 
                                    % possible junction for the other cell
                                    d.cells(suitablePairCells(i2)).junctions.possible.vertices(tempInd) = [];
                                    d.cells(suitablePairCells(i2)).junctions.possible.pairCellIDs(:,tempInd) = [];
                                    d.cells(suitablePairCells(i2)).junctions.possible.pairVertexIDs(:,tempInd) = [];
                                    d.cells(suitablePairCells(i2)).junctions.possible.distances(:,tempInd) = [];
                                    d.cells(suitablePairCells(i2)).junctions.possible.pairVerticesX(:,tempInd) = [];
                                    d.cells(suitablePairCells(i2)).junctions.possible.pairVerticesY(:,tempInd) = [];
                                end
                                
                                % if the current vertex has already two
                                % junctions or if all the possible
                                % junctions are in the same cell
                                if all(sameCell) || d.cells(k).vertexStates(tempIdx) == 2
                                    break;
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    % go throught the cells
    for k = 1:size(d.cells,2)
        
        % get the derived junction data (so that it includes the data only
        % on the vertices that have junctions)
        d.cells(k).junctions.linkedIdx1 = find(d.cells(k).vertexStates > 0);
        d.cells(k).junctions.linkedIdx2 = find(d.cells(k).vertexStates == 2);
        d.cells(k).junctions.pairCells1 = d.cells(k).junctions.cells(d.cells(k).junctions.linkedIdx1,1);
        d.cells(k).junctions.pairCells2 = d.cells(k).junctions.cells(d.cells(k).junctions.linkedIdx2,2);
        d.cells(k).junctions.pairVertices1 = d.cells(k).junctions.vertices(d.cells(k).junctions.linkedIdx1,1);
        d.cells(k).junctions.pairVertices2 = d.cells(k).junctions.vertices(d.cells(k).junctions.linkedIdx2,2);
        
        % get the unique neighbor cells for the first junction
        if numel(d.cells(k).junctions.linkedIdx1) > 0
            d.cells(k).junctions.linked2CellNumbers1 = find(accumarray(d.cells(k).junctions.pairCells1,1))';%get_uniques(d.cells(k).junctions.pairCells1,cellNumbers,zeroVec);
        else
            d.cells(k).junctions.linked2CellNumbers1 = [];
        end
        
        % get the unique neighbor cells for the first junction
        if numel(d.cells(k).junctions.linkedIdx2) > 0
            d.cells(k).junctions.linked2CellNumbers2 = find(accumarray(d.cells(k).junctions.pairCells2,1))';%get_uniques(d.cells(k).junctions.pairCells2,cellNumbers,zeroVec);
        else
            d.cells(k).junctions.linked2CellNumbers2 = [];
        end
        
        d.simset.calculateForces.junction(k) = true;
        
    end 
end

end