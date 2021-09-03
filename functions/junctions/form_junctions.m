function d = form_junctions(d)

% for k = 1:length(d.cells)
% d.cells(k).vertexStates2 = d.cells(k).vertexStates;
% end

%  check that there are more than one cell
if length(d.cells) > 1
       
    zeroVec = zeros(1,length(d.cells));
    cellNumbers = (1:size(d.cells,2));
    
    % go through the cells
    for k = 1:size(d.cells,2)
        
        
        
        if ~isempty(d.cells(k).junctions.possible.vertices)
            
            possibleJunctionVertices = d.cells(k).junctions.possible.vertices;
            
            suitablePairCellsAll = d.cells(k).junctions.possible.pairCellIDs;
            suitablePairVerticesAll = d.cells(k).junctions.possible.pairVertexIDs;
            suitableDistancesAll = d.cells(k).junctions.possible.distances;
            suitablePairVerticesXAll = d.cells(k).junctions.possible.pairVerticesX;
            suitablePairVerticesYAll = d.cells(k).junctions.possible.pairVerticesY;
            [~, numberOfPossibles] = max(cumsum(~isnan(suitablePairCellsAll), 1));
            
            
            % go through the vertices that have possible pairs
            for i = 1:length(possibleJunctionVertices)
                
                idx = possibleJunctionVertices(i);
                
                suitablePairCells = suitablePairCellsAll(:,i);
                suitablePairVertices = suitablePairVerticesAll(:,i);
                
                atLeastOne = false;
                
                sameCell = zeros(numberOfPossibles(i),1);
                
                % Go through the possible pairs
                for i2 = 1:numberOfPossibles(i)
                    
                    if ~isnan(suitablePairCells(i2))
                        idxPair = find(d.cells(suitablePairCells(i2)).junctions.possible.vertices ==  suitablePairVertices(i2));
                        
                        firstNonNan = find(~isnan(d.cells(suitablePairCells(i2)).junctions.possible.pairCellIDs(:,idxPair)),1);
                        
                        % Remove vertices that are already bound
                        if ~isempty(idxPair) && ~sameCell(i2) ...
                                && (d.cells(suitablePairCells(i2)).vertexStates(suitablePairVertices(i2)) == 0 ...
                                || (d.cells(suitablePairCells(i2)).vertexStates(suitablePairVertices(i2)) == 1 && d.cells(suitablePairCells(i2)).junctions.cells(suitablePairVertices(i2),1) ~= k)) ...
                                && d.cells(suitablePairCells(i2)).junctions.possible.pairVertexIDs(firstNonNan,idxPair) == idx...
                                && d.cells(suitablePairCells(i2)).junctions.possible.pairCellIDs(firstNonNan,idxPair) == k
                            
                            if ~atLeastOne
                                
                                suitablePairDistances = suitableDistancesAll(:,i);
                                suitablePairVerticesX = suitablePairVerticesXAll(:,i);
                                suitablePairVerticesY = suitablePairVerticesYAll(:,i);
                                
                                atLeastOne = true;
                            end
                            
                            suitablePairOutsideAngles = d.cells(suitablePairCells(i2)).outsideAngles(suitablePairVertices(i2));
                            suitablePairRigthVectorsX = d.cells(suitablePairCells(i2)).rightVectorsX(suitablePairVertices(i2));
                            suitablePairRigthVectorsY = d.cells(suitablePairCells(i2)).rightVectorsY(suitablePairVertices(i2));
                            suitablePairRigthLengths = d.cells(suitablePairCells(i2)).rightLengths(suitablePairVertices(i2));
                            
                            pairsPairCrosslinkCheck = d.cells(k).vertexStates(idx) == 1 && d.cells(d.cells(k).junctions.cells(idx,1)).vertexStates(d.cells(k).junctions.vertices(idx,1)) == 2;
                            
                            if pairsPairCrosslinkCheck
                                newPairC = suitablePairCells(i2);
                                newPairV = suitablePairVertices(i2);
                                ownPairC = d.cells(k).junctions.cells(idx,1);
                                ownPairV = d.cells(k).junctions.vertices(idx,1);
                                pairOtherJunction = ~(d.cells(ownPairC).junctions.cells(ownPairV,:) == k);
                                pairsPairC = d.cells(ownPairC).junctions.cells(ownPairV,pairOtherJunction);
                                pairsPairV = d.cells(ownPairC).junctions.vertices(ownPairV,pairOtherJunction);
                            end
                            
                            if check_junction_angle_adding(d.spar,d.cells(k),idx,suitablePairVerticesX(i2),suitablePairVerticesY(i2),suitablePairRigthVectorsX,suitablePairRigthVectorsY,suitablePairOutsideAngles,suitablePairRigthLengths,suitablePairDistances(i2))...
                                    && check_junction_crossing(d.cells,k,idx,suitablePairCells(i2),suitablePairVertices(i2))...
                                    && check_junction_crossing(d.cells,suitablePairCells(i2),suitablePairVertices(i2),k,idx)...
                                    && ~(pairsPairCrosslinkCheck && ~check_line_intersection(d.cells(k).verticesX(idx),d.cells(k).verticesY(idx),d.cells(ownPairC).verticesX(ownPairV),d.cells(ownPairC).verticesY(ownPairV),d.cells(newPairC).verticesX(newPairV),d.cells(newPairC).verticesY(newPairV),d.cells(pairsPairC).verticesX(pairsPairV),d.cells(pairsPairC).verticesY(pairsPairV)))
                                
                                if d.cells(k).vertexStates(idx) == 0
                                    % sets the vertexState of vertex i to 1 (linked)
                                    d.cells(k).vertexStates(idx) = 1;
                                    
                                    % sets the junction information for vertex i
                                    d.cells(k).junctions.cells(idx,1) = suitablePairCells(i2);
                                    d.cells(k).junctions.vertices(idx,1) = suitablePairVertices(i2);
                                    
                                    sameCell(suitablePairCells(1:numberOfPossibles(i)) == suitablePairCells(i2)) = true;
                                    
                                elseif d.cells(k).vertexStates(idx) == 1
                                    % sets the vertexState of vertex i to 1 (linked)
                                    d.cells(k).vertexStates(idx) = 2;
                                    
                                    % sets the junction information for vertex i
                                    d.cells(k).junctions.cells(idx,2) = suitablePairCells(i2);
                                    d.cells(k).junctions.vertices(idx,2) = suitablePairVertices(i2);
                                end
                                
                                if d.cells(suitablePairCells(i2)).vertexStates(suitablePairVertices(i2)) == 0
                                    % sets the vertexState of vertex pairVertex to 1 (linked)
                                    d.cells(suitablePairCells(i2)).vertexStates(suitablePairVertices(i2)) = 1;
                                    
                                    % sets the junction information for vertex pairVertex
                                    d.cells(suitablePairCells(i2)).junctions.cells(suitablePairVertices(i2),1) = k;
                                    d.cells(suitablePairCells(i2)).junctions.vertices(suitablePairVertices(i2),1) = idx;
                                    
                                    tempInd = d.cells(suitablePairCells(i2)).junctions.possible.vertices == suitablePairVertices(i2);
                                    
                                    d.cells(suitablePairCells(i2)).junctions.possible.pairCellIDs(d.cells(suitablePairCells(i2)).junctions.possible.pairCellIDs(:,tempInd) == k,tempInd) = NaN;
                                    
                                    if all(isnan(d.cells(suitablePairCells(i2)).junctions.possible.pairCellIDs(:,tempInd)))
                                        d.cells(suitablePairCells(i2)).junctions.possible.vertices(tempInd) = [];
                                        d.cells(suitablePairCells(i2)).junctions.possible.pairCellIDs(:,tempInd) = [];
                                        d.cells(suitablePairCells(i2)).junctions.possible.pairVertexIDs(:,tempInd) = [];
                                        d.cells(suitablePairCells(i2)).junctions.possible.distances(:,tempInd) = [];
                                        d.cells(suitablePairCells(i2)).junctions.possible.pairVerticesX(:,tempInd) = [];
                                        d.cells(suitablePairCells(i2)).junctions.possible.pairVerticesY(:,tempInd) = [];
                                    end
                                    
                                elseif d.cells(suitablePairCells(i2)).vertexStates(suitablePairVertices(i2)) == 1
                                    % sets the vertexState of vertex pairVertex to 1 (linked)
                                    d.cells(suitablePairCells(i2)).vertexStates(suitablePairVertices(i2)) = 2;
                                    
                                    % sets the junction information for vertex pairVertex
                                    d.cells(suitablePairCells(i2)).junctions.cells(suitablePairVertices(i2),2) = k;
                                    d.cells(suitablePairCells(i2)).junctions.vertices(suitablePairVertices(i2),2) = idx;
                                    
                                    % removes pairVertex from pairCells possible linkable
                                    % vertices list
                                    
                                    tempInd = d.cells(suitablePairCells(i2)).junctions.possible.vertices == suitablePairVertices(i2);
                                    
                                    d.cells(suitablePairCells(i2)).junctions.possible.vertices(tempInd) = [];
                                    d.cells(suitablePairCells(i2)).junctions.possible.pairCellIDs(:,tempInd) = [];
                                    d.cells(suitablePairCells(i2)).junctions.possible.pairVertexIDs(:,tempInd) = [];
                                    d.cells(suitablePairCells(i2)).junctions.possible.distances(:,tempInd) = [];
                                    d.cells(suitablePairCells(i2)).junctions.possible.pairVerticesX(:,tempInd) = [];
                                    d.cells(suitablePairCells(i2)).junctions.possible.pairVerticesY(:,tempInd) = [];
                                    
                                end
                                
                                if all(sameCell) || d.cells(k).vertexStates(idx) == 2
                                    break;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
%     

%     
    for k = 1:size(d.cells,2)
        d.cells(k).junctions.linkedIdx1 = find(d.cells(k).vertexStates > 0);
        d.cells(k).junctions.linkedIdx2 = find(d.cells(k).vertexStates == 2);
        d.cells(k).junctions.pairCells1 = d.cells(k).junctions.cells(d.cells(k).junctions.linkedIdx1,1);
        d.cells(k).junctions.pairCells2 = d.cells(k).junctions.cells(d.cells(k).junctions.linkedIdx2,2);
        d.cells(k).junctions.pairVertices1 = d.cells(k).junctions.vertices(d.cells(k).junctions.linkedIdx1,1);
        d.cells(k).junctions.pairVertices2 = d.cells(k).junctions.vertices(d.cells(k).junctions.linkedIdx2,2);
        
        if numel(d.cells(k).junctions.linkedIdx1) > 0
            d.cells(k).junctions.linked2CellNumbers1 = get_uniques(d.cells(k).junctions.pairCells1,cellNumbers,zeroVec);
        else
            d.cells(k).junctions.linked2CellNumbers1 = [];
        end
        if numel(d.cells(k).junctions.linkedIdx2) > 0
            d.cells(k).junctions.linked2CellNumbers2 = get_uniques(d.cells(k).junctions.pairCells2,cellNumbers,zeroVec);
        else
            d.cells(k).junctions.linked2CellNumbers2 = [];
        end
    end 
end

end