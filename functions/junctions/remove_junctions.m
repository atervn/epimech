function cells = remove_junctions(cells, spar)

if length(cells) > 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK CURRENT LINKS AND REMOVE IF NEEDED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cellNumberVector = 1:size(cells,2);

% go through the cells
for k = 1:length(cells)

    atLeastOneRemoved = 0;
    
    linkedIdx = find(cells(k).vertexStates == 1);
    
    if numel(linkedIdx) ~= 0
        
        cellids = cells(k).junctions.cells(linkedIdx,1);
        vertexids = cells(k).junctions.vertices(linkedIdx,1);
        
        % Finds the cells that cell k has links with (replaces unique)
        P = zeros(1, max(max(cellids),max(cellNumberVector))) ;
        P(cellids) = 1;
        linked2CellNumbers = cellNumberVector(logical(P(cellNumberVector)));
        
        pairVerticesX = zeros(length(cellids),1);
        pairVerticesY = pairVerticesX;

        for i = linked2CellNumbers
            vertexIdx = cellids == i;
            pairVerticesX(vertexIdx,:) = cells(i).verticesX(vertexids(vertexIdx));
            pairVerticesY(vertexIdx,:) = cells(i).verticesY(vertexids(vertexIdx));
        end

        junctionDistancesSq = (cells(k).verticesX(linkedIdx) - pairVerticesX).^2 + (cells(k).verticesY(linkedIdx) - pairVerticesY).^2;
        
        longs = junctionDistancesSq > (spar.junctionLength.*2)^2;
        
        junctions2Remove = linkedIdx(longs);
        
        for i = junctions2Remove'
            atLeastOneRemoved = 1;
            
            cellids = cells(k).junctions.cells(i,1);
            vertexids = cells(k).junctions.vertices(i,1);
            whichJunction = find(cells(cellids).junctions.cells(vertexids,:) == k);
            cells(cellids).junctions.cells(vertexids,whichJunction) = 0;
            cells(cellids).junctions.vertices(vertexids,whichJunction) = 0;
            if cells(cellids).vertexStates(vertexids) == 2
                cells(cellids).vertexStates(vertexids) = 1;
                if whichJunction == 1
                    cells(cellids).junctions.cells(vertexids,1) = cells(cellids).junctions.cells(vertexids,2);
                    cells(cellids).junctions.vertices(vertexids,1) = cells(cellids).junctions.vertices(vertexids,2);
                    cells(cellids).junctions.cells(vertexids,2) = 0;
                    cells(cellids).junctions.vertices(vertexids,2) = 0;
                end
            else
                cells(cellids).vertexStates(vertexids) = 0;
            end
            cells(k).junctions.cells(i,1) = 0;
            cells(k).junctions.vertices(i,1) = 0;
        end

        if numel(junctions2Remove) > 0
            removed = logical(sum(linkedIdx == junctions2Remove',2));
        else
            removed = false(size(linkedIdx));
        end
        
        linkedIdx(removed) = [];
        
        if numel(linkedIdx) > 0
            
            pairVerticesX(longs) = [];
            pairVerticesY(longs) = [];
            
                        
            junctions2Remove = check_junction_angle(spar,cells(k),linkedIdx,pairVerticesX,pairVerticesY,1);            
            if numel(junctions2Remove) ~= 0
                for i = junctions2Remove'
                    atLeastOneRemoved = 1;
                    cellids = cells(k).junctions.cells(i,1);
                    vertexids = cells(k).junctions.vertices(i,1);
                    whichJunction = find(cells(cellids).junctions.cells(vertexids,:) == k);
                    cells(cellids).junctions.cells(vertexids,whichJunction) = 0;
                    cells(cellids).junctions.vertices(vertexids,whichJunction) = 0;
                    if cells(cellids).vertexStates(vertexids) == 2
                        cells(cellids).vertexStates(vertexids) = 1;
                        if whichJunction == 1
                            cells(cellids).junctions.cells(vertexids,1) = cells(cellids).junctions.cells(vertexids,2);
                            cells(cellids).junctions.vertices(vertexids,1) = cells(cellids).junctions.vertices(vertexids,2);
                            cells(cellids).junctions.cells(vertexids,2) = 0;
                            cells(cellids).junctions.vertices(vertexids,2) = 0;
                        end
                    else
                        cells(cellids).vertexStates(vertexids) = 0;
                    end
                    cells(k).junctions.cells(i,1) = 0;
                    cells(k).junctions.vertices(i,1) = 0;

                end
            end
        end
    end
    
    
    
    linkedIdx = find(cells(k).vertexStates == 2);
    
    if numel(linkedIdx) ~= 0
        
        cellids = cells(k).junctions.cells(linkedIdx,2);
        vertexids = cells(k).junctions.vertices(linkedIdx,2);
        
        % Finds the cells that cell k has links with (replaces unique)
        P = zeros(1, max(max(cellids),max(cellNumberVector))) ;
        P(cellids) = 1;
        linked2CellNumbers = cellNumberVector(logical(P(cellNumberVector)));
        
        pairVerticesX = zeros(length(cellids),1);
        pairVerticesY = pairVerticesX;

        for i = linked2CellNumbers
            vertexIdx = cellids == i;
            pairVerticesX(vertexIdx,:) = cells(i).verticesX(vertexids(vertexIdx));
            pairVerticesY(vertexIdx,:) = cells(i).verticesY(vertexids(vertexIdx));
        end

        junctionDistancesSq = (cells(k).verticesX(linkedIdx) - pairVerticesX).^2 + (cells(k).verticesY(linkedIdx) - pairVerticesY).^2;
        
        longs = junctionDistancesSq > (spar.junctionLength.*2)^2;
        
        junctions2Remove = linkedIdx(longs);
        
        for i = junctions2Remove'
            atLeastOneRemoved = 1;
            cellids = cells(k).junctions.cells(i,2);
            vertexids = cells(k).junctions.vertices(i,2);
            whichJunction = find(cells(cellids).junctions.cells(vertexids,:) == k);
            cells(cellids).junctions.cells(vertexids,whichJunction) = 0;
            cells(cellids).junctions.vertices(vertexids,whichJunction) = 0;
            if cells(cellids).vertexStates(vertexids) == 2
                cells(cellids).vertexStates(vertexids) = 1;
                if whichJunction == 1
                    cells(cellids).junctions.cells(vertexids,1) = cells(cellids).junctions.cells(vertexids,2);
                    cells(cellids).junctions.vertices(vertexids,1) = cells(cellids).junctions.vertices(vertexids,2);
                    cells(cellids).junctions.cells(vertexids,2) = 0;
                    cells(cellids).junctions.vertices(vertexids,2) = 0;
                end
            else
                cells(cellids).vertexStates(vertexids) = 0;
            end
            cells(k).junctions.cells(i,2) = 0;
            cells(k).junctions.vertices(i,2) = 0;
        end

        if numel(junctions2Remove) > 0
            removed = logical(sum(linkedIdx == junctions2Remove',2));
        else
            removed = false(size(linkedIdx));
        end
        
        linkedIdx(removed) = [];
        
        if numel(linkedIdx) > 0
    
            pairVerticesX(longs) = [];
            pairVerticesY(longs) = [];
  
            junctions2Remove = check_junction_angle(spar,cells(k),linkedIdx,pairVerticesX,pairVerticesY,1);            
            if numel(junctions2Remove) ~= 0
                for i = junctions2Remove'
                    atLeastOneRemoved = 1;
                    cellids = cells(k).junctions.cells(i,2);
                    vertexids = cells(k).junctions.vertices(i,2);
                    whichJunction = find(cells(cellids).junctions.cells(vertexids,:) == k);
                    cells(cellids).junctions.cells(vertexids,whichJunction) = 0;
                    cells(cellids).junctions.vertices(vertexids,whichJunction) = 0;
                    if cells(cellids).vertexStates(vertexids) == 2
                        cells(cellids).vertexStates(vertexids) = 1;
                        if whichJunction == 1
                            cells(cellids).junctions.cells(vertexids,1) = cells(cellids).junctions.cells(vertexids,2);
                            cells(cellids).junctions.vertices(vertexids,1) = cells(cellids).junctions.vertices(vertexids,2);
                            cells(cellids).junctions.cells(vertexids,2) = 0;
                            cells(cellids).junctions.vertices(vertexids,2) = 0;
                        end
                    else
                        cells(cellids).vertexStates(vertexids) = 0;
                    end
                    cells(k).junctions.cells(i,2) = 0;
                    cells(k).junctions.vertices(i,2) = 0;

                end
            end
        end
    end
    if atLeastOneRemoved
        toBeSwitched = cells(k).vertexStates == 2.*(cells(k).junctions.cells(:,1) == 0);
        if any(toBeSwitched)
           cells(k).junctions.cells(toBeSwitched,1) = cells(k).junctions.cells(toBeSwitched,2);
           cells(k).junctions.cells(toBeSwitched,2) = 0;
           cells(k).junctions.vertices(toBeSwitched,1) = cells(k).junctions.vertices(toBeSwitched,2);
           cells(k).junctions.vertices(toBeSwitched,2) = 0;
           
        end
        cells(k).vertexStates = sum(cells(k).junctions.cells > 0,2);
        if cells(k).division.state == 2
            cells(k).vertexStates(cells(k).division.vertices(1)) = -1;
            cells(k).vertexStates(cells(k).division.vertices(2)) = -1; 
        end
    end
end
end

end
