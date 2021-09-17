function cells = remove_junctions(cells, spar)
% REMOVE_JUNCTIONS Removes junctions if required
%   The function checks the length and the angle of the junctions against
%   the predefined limits and removed the one that are over the limits.
%   INPUTS:
%       cells: cell data structure
%       spar: scaled parameters data structure
%   OUTPUT:
%       cells: cell data structure

% if there are more than one cell
if length(cells) > 1
    
    % create zeroVec and cell number vector needed to find unique pair cells
    zeroVec = zeros(1,length(cells));
    cellNumbers = 1:length(cells);
    
    % go through the cells
    for k = 1:length(cells)
        
        % variable to record that a junction has been removed
        atLeastOneRemoved = 0;
        
        % go through the first and the second junctions
        for i = 1:2
            
            % find the indices of the linked vertices
            linkedIdx = find(cells(k).vertexStates == i);
            
            % if there are junctions
            if numel(linkedIdx) ~= 0
                
                % get the pair data for all the first junctions for the cell
                cellIDs = cells(k).junctions.cells(linkedIdx,i);
                vertexIDs = cells(k).junctions.vertices(linkedIdx,i);
                
                % finds the cells that cell k has links with
                linked2CellNumbers = get_uniques(cellIDs,cellNumbers,zeroVec);
                
                % vectors for the pair coodinates
                pairVerticesX = zeros(length(cellIDs),1);
                pairVerticesY = pairVerticesX;
                
                % go through pair cells and get pair vertex coordinates
                for i2 = linked2CellNumbers
                    vertexIdx = cellIDs == i2;
                    pairVerticesX(vertexIdx,:) = cells(i2).verticesX(vertexIDs(vertexIdx));
                    pairVerticesY(vertexIdx,:) = cells(i2).verticesY(vertexIDs(vertexIdx));
                end
                
                % find the squared distances between the vertices and their pairs
                junctionDistancesSq = (cells(k).verticesX(linkedIdx) - pairVerticesX).^2 + (cells(k).verticesY(linkedIdx) - pairVerticesY).^2;
                
                % find the long junctions
                longs = junctionDistancesSq > (spar.junctionLength.*2)^2;
                
                % get their indices
                junctions2Remove = linkedIdx(longs);
                
                % go through the junctions to remove
                for i2 = junctions2Remove'
                    
                    % there is at least one junction to remove
                    atLeastOneRemoved = 1;
                    
                    % remove the junction (also from the pair)
                    cells = remove_single_junction(cells,k,i2,i);
                end
                
                % if junctions have been removed, remove them from the linkedIdx
                % vector
                if numel(junctions2Remove) > 0
                    removed = logical(sum(linkedIdx == junctions2Remove',2));
                else
                    removed = false(size(linkedIdx));
                end
                linkedIdx(removed) = [];
                
                % if there are still junctions left
                if numel(linkedIdx) > 0
                    
                    % remove the coordinates of the now removed long pairs
                    pairVerticesX(longs) = [];
                    pairVerticesY(longs) = [];
                    
                    % check if the junction angles are too large
                    junctions2Remove = check_junction_angle_remove(spar,cells(k),linkedIdx,pairVerticesX,pairVerticesY);
                    
                    % if there are junctions with too acute angles
                    if numel(junctions2Remove) ~= 0
                        
                        % go through the junctions to be removed
                        for i2 = junctions2Remove'
                            
                            % there is at least one junction to be removed
                            atLeastOneRemoved = 1;
                            
                            % remove the junction (also from the pair)
                            cells = remove_single_junction(cells,k,i2,i);
                        end
                    end
                end
            end
        end
        
        % if at least one junction was removed
        if atLeastOneRemoved
            
            % find junctions that only have a single junction at the second
            % junction spot
            toBeSwitched = cells(k).vertexStates == 2.*(cells(k).junctions.cells(:,1) == 0);
            
            % copy these junctions to the first spots
            if any(toBeSwitched)
                cells(k).junctions.cells(toBeSwitched,1) = cells(k).junctions.cells(toBeSwitched,2);
                cells(k).junctions.cells(toBeSwitched,2) = 0;
                cells(k).junctions.vertices(toBeSwitched,1) = cells(k).junctions.vertices(toBeSwitched,2);
                cells(k).junctions.vertices(toBeSwitched,2) = 0;
            end
            
            % reset the vertex states
            cells(k).vertexStates = sum(cells(k).junctions.cells > 0,2);
            
            % if the cell is in cytokinesis (division state 2), edit the
            % vertex states' of the division points
            if cells(k).division.state == 2
                cells(k).vertexStates(cells(k).division.vertices(1)) = -1;
                cells(k).vertexStates(cells(k).division.vertices(2)) = -1;
            end
        end
    end
end

end
