function d = change_activation(d, time)

switchOff = 0;
if d.simset.opto.times(d.simset.opto.currentTime+1) <= time
    d.simset.opto.currentTime = d.simset.opto.currentTime + 1;
    if d.simset.opto.currentTime > 1 && d.simset.opto.levels(d.simset.opto.currentTime) == 0 && d.simset.opto.levels(d.simset.opto.currentTime-1) > 0
        switchOff = 1;
    end
end



if d.simset.opto.levels(d.simset.opto.currentTime) > 0
    
    oldOpto = d.simset.opto;
    
    nCells = length(d.cells);
    cellNumbers = 1:nCells;
    zeroVec = zeros(nCells,1);
    if isempty(d.simset.opto.cells)
        for i = 1:length(d.simset.opto.shapes)
            for k = 1:nCells
                isInside = check_if_inside(d.simset.opto.shapes{i}(:,1),d.simset.opto.shapes{i}(:,2),d.cells(k).verticesX,d.cells(k).verticesY);
                if any(isInside ~= 0)
                    isInside = find(isInside ~= 0);
                    if any(d.simset.opto.cells == k)
                        idx = find(d.simset.opto.cells == k);
                        
                        d.simset.opto.vertices{idx} = get_uniques([d.simset.opto.vertices{idx}; isInside],1:d.cells(k).nVertices,zeros(d.cells(k).nVertices,1));
                    else
                        d.simset.opto.cells(end+1) = k;
                        d.simset.opto.vertices{end+1} = isInside;
                    end
                end
            end
        end
        
        
    else
        cell2Check = d.simset.opto.cells;
        
        cellNumbers = 1:nCells;
        zeroVec = zeros(nCells,1);
        
        for k = cell2Check
            cell2Check = get_uniques([cell2Check d.cells(k).junctions.linked2CellNumbers1 d.cells(k).junctions.linked2CellNumbers2],cellNumbers,zeroVec);
        end
        
        oldOpto = d.simset.opto;
        d.simset.opto.cells = [];
        d.simset.opto.vertices = {};
        
        for i = 1:length(d.simset.opto.shapes)
            for k = cell2Check
                isInside = check_if_inside(d.simset.opto.shapes{i}(:,1),d.simset.opto.shapes{i}(:,2),d.cells(k).verticesX,d.cells(k).verticesY);
                if any(isInside ~= 0)
                    isInside = find(isInside ~= 0);
                    if any(d.simset.opto.cells == k)
                        idx = find(d.simset.opto.cells == k);
                        
                        d.simset.opto.vertices{idx} = get_uniques([d.simset.opto.vertices{idx}; isInside],1:d.cells(k).nVertices,zeros(d.cells(k).nVertices,1));
                    else
                        d.simset.opto.cells(end+1) = k;
                        d.simset.opto.vertices{end+1} = isInside;
                    end
                end
            end
        end
        
    end
    
    notActivatedCells = setdiff(oldOpto.cells,d.simset.opto.cells);
    if ~isempty(notActivatedCells)
        for k = notActivatedCells
            d.cells(k).vertexCorticalTensions = ones(d.cells(k).nVertices,1);
        end
    end
    
    
    for k = 1:length(d.simset.opto.cells)
        
        cellID = d.simset.opto.cells(k);
        d.cells(cellID).vertexCorticalTensions = ones(d.cells(cellID).nVertices,1);
        
        verticesTemp = zeros(d.cells(cellID).nVertices,1);
        verticesTemp(d.simset.opto.vertices{k}) = 1;
        
        activationChanges = diff(verticesTemp([1:end 1]));
        
        downs = find(activationChanges == -1);
        ups  = find(activationChanges == 1);
        if ~isempty(downs)
            if downs(1) < ups(1)
                pairs = [ups([end 1:end-1]) downs];
                firstSwapped = 1;
            else
                firstSwapped = 0;
                pairs = [ups downs];
            end
            
            halfActivated = [];
            fullyActivated = [];
            quarterActivated = [];
            
            for i = 1:size(pairs,1)
                if firstSwapped && i == 1
                    numberActivated = pairs(1,2) + d.cells(cellID).nVertices - pairs(1,1);
                else
                    numberActivated = pairs(i,2) - pairs(i,1);
                end
                if numberActivated == 1
                    if firstSwapped && i == 1
                        quarterActivated = [quarterActivated 1 d.cells(cellID).nVertices-1];
                        halfActivated = [halfActivated d.cells(cellID).nVertices];
                    else
                        if pairs(i,1) == 1
                            quarterActivated = [quarterActivated d.cells(cellID).nVertices 2];
                            halfActivated = [halfActivated 1];
                        else
                            quarterActivated = [quarterActivated pairs(i,1)-1 pairs(i,1)+1];
                            halfActivated = [halfActivated pairs(i,1)];
                        end
                    end
                elseif numberActivated == 2
                    if firstSwapped && i == 1
                        if pairs(1,1) == d.cells(cellID).nVertices
                            quarterActivated = [quarterActivated d.cells(cellID).nVertices-1 2];
                            halfActivated = [fullyActivated 1 d.cells(cellID).nVertices];
                        else
                            quarterActivated = [quarterActivated d.cells(cellID).nVertices-2 1];
                            halfActivated = [fullyActivated d.cells(cellID).nVertices-1 d.cells(cellID).nVertices];
                        end
                    else
                        if pairs(i,1) == 1
                            quarterActivated = [quarterActivated d.cells(cellID).nVertices 3];
                            halfActivated = [halfActivated 1 2];
                        else
                            quarterActivated = [quarterActivated pairs(i,1)-1 pairs(i,1)+2];
                            halfActivated = [halfActivated pairs(i,1) pairs(i,1)+1];
                        end
                    end
                elseif numberActivated == 3
                    if firstSwapped && i == 1
                        if pairs(1,1) == d.cells(cellID).nVertices
                            quarterActivated = [quarterActivated d.cells(cellID).nVertices-1 3];
                            halfActivated = [halfActivated 2 d.cells(cellID).nVertices];
                            fullyActivated = [fullyActivated 1];
                        elseif pairs(1,2) == 1
                            quarterActivated = [quarterActivated d.cells(cellID).nVertices-3 1];
                            halfActivated = [halfActivated d.cells(cellID).nVertices-2 d.cells(cellID).nVertices];
                            fullyActivated = [fullyActivated d.cells(cellID).nVertices-1];
                        else
                            quarterActivated = [quarterActivated d.cells(cellID).nVertices-2 2];
                            halfActivated = [halfActivated d.cells(cellID).nVertices-1 1];
                            fullyActivated = [fullyActivated d.cells(cellID).nVertices];
                        end
                    else
                        if pairs(i,1) == 1
                            quarterActivated = [quarterActivated d.cells(cellID).nVertices 4];
                            halfActivated = [halfActivated 1 3];
                            fullyActivated = [fullyActivated 2];
                        else
                            quarterActivated = [quarterActivated pairs(i,1)-1 pairs(i,2)];
                            halfActivated = [halfActivated pairs(i,1) pairs(i,2)-1];
                            fullyActivated = [fullyActivated pairs(i,1)+1];
                        end
                    end
                else
                    if firstSwapped && i == 1
                        if pairs(1,1) == d.cells(cellID).nVertices
                            quarterActivated = [quarterActivated d.cells(cellID).nVertices-1 pairs(1,2)];
                            halfActivated = [halfActivated d.cells(cellID).nVertices pairs(1,2)-1];
                            fullyActivated = [fullyActivated 1:(pairs(1,2)-2)];
                        elseif pairs(1,1) == d.cells(cellID).nVertices-1
                            quarterActivated = [quarterActivated d.cells(cellID).nVertices-2 pairs(1,2)];
                            halfActivated = [halfActivated d.cells(cellID).nVertices-1 pairs(1,2)-1];
                            fullyActivated = [fullyActivated d.cells(cellID).nVertices 1:(pairs(1,2)-2)];
                        elseif pairs(1,2) == 1
                            quarterActivated = [quarterActivated pairs(1,1)-1 1];
                            halfActivated = [halfActivated pairs(1,1) d.cells(cellID).nVertices];
                            fullyActivated = [fullyActivated (pairs(1,1)+1):d.cells(cellID).nVertices-1];
                        elseif pairs(1,2) == 2
                            quarterActivated = [quarterActivated pairs(1,1)-1 2];
                            halfActivated = [halfActivated pairs(1,1) 1];
                            fullyActivated = [fullyActivated (pairs(1,1)+1):d.cells(cellID).nVertices];
                        else
                            quarterActivated = [quarterActivated pairs(1,1)-1 pairs(1,2)];
                            halfActivated = [halfActivated pairs(1,1) pairs(1,2)-1];
                            fullyActivated = [fullyActivated (pairs(1,1)+1):d.cells(cellID).nVertices 1:(pairs(1,2)-2)];
                        end
                    else
                        if pairs(i,1) == 1
                            quarterActivated = [quarterActivated d.cells(cellID).nVertices pairs(i,2)];
                            halfActivated = [halfActivated 1 pairs(i,2)-1];
                            fullyActivated = [fullyActivated 2:pairs(i,1)-2];
                        else
                            quarterActivated = [quarterActivated pairs(i,1)-1 pairs(i,2)];
                            halfActivated = [halfActivated pairs(i,1) pairs(i,2)-1];
                            fullyActivated = [fullyActivated (pairs(i,1)+1):pairs(i,2)-2];
                        end
                    end
                end
                
                
            end
        else
            quarterActivated = [];
            halfActivated = [];
            fullyActivated = 1:d.cells(k).nVertices;
        end
        
        d.cells(cellID).vertexCorticalTensions(quarterActivated) = 1 + 0.25.*d.simset.opto.levels(d.simset.opto.currentTime);
        d.cells(cellID).vertexCorticalTensions(halfActivated) = 1 + 0.5.*d.simset.opto.levels(d.simset.opto.currentTime);
        d.cells(cellID).vertexCorticalTensions(fullyActivated) = 1 + d.simset.opto.levels(d.simset.opto.currentTime);
    end
    
elseif switchOff
    for k = d.simset.opto.cells
        d.cells(k).vertexCorticalTensions = ones(d.cells(k).nVertices,1);
        d.simset.opto.cells = [];
        d.simset.opto.vertices = {};
    end
end

%% COMMENT ADD_VERTICES OPTO SECTION, OR TAKE OUT IF UNNECESSARY

end