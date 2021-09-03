function d = remove_substrate_points(d,app,expansionMultiplier)

if isobject(app)
    progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Contructing the substrate - Removing extra points...',...
        'Cancelable','on');
end

polyCells = polyshape;

warning('off','MATLAB:polyshape:repairedBySimplify')

for k = 1:length(d.cells)
    
    tempX = d.cells(k).leftVectorsX + d.cells(k).rightVectorsX;
    tempY = d.cells(k).leftVectorsY + d.cells(k).rightVectorsY;
    normalsX = tempY;
    normalsY = -tempX;
    normalLengths = sqrt(normalsX.^2 + normalsY.^2);
    normalsX = normalsX./normalLengths;
    normalsY = normalsY./normalLengths;
    if d.simset.simulationType == 3
        expandedX = d.cells(k).verticesX + normalsX.*d.spar.substratePointDistance.*d.simset.stretch.values(1).*expansionMultiplier;
        expandedY = d.cells(k).verticesY + normalsY.*d.spar.substratePointDistance.*d.simset.stretch.values(1).*expansionMultiplier;
    else
        expandedX = d.cells(k).verticesX + normalsX.*d.spar.substratePointDistance.*expansionMultiplier;
        expandedY = d.cells(k).verticesY + normalsY.*d.spar.substratePointDistance.*expansionMultiplier;
    end
    tempPolyCell = polyshape(expandedX,expandedY);
    tempPolyCell = simplify(tempPolyCell);
    
    if any(isnan(tempPolyCell.Vertices(:,1)))
        nanInd = find(isnan(tempPolyCell.Vertices(:,1)));
        tempPolyCell = polyshape(tempPolyCell.Vertices(1:nanInd,1),tempPolyCell.Vertices(1:nanInd,2));
    end

    polyCells = union(polyCells,tempPolyCell);
end

warning('on','MATLAB:polyshape:repairedBySimplify')

polyCells = rmholes(polyCells);

cellsX = polyCells.Vertices(:,1);
cellsY = polyCells.Vertices(:,2);

distances = sqrt((cellsX - cellsX').^2 + (cellsY - cellsY').^2);

closeBy = triu(distances < 0.1);

closeBy = closeBy - diag(diag(closeBy)) - diag(diag(closeBy,1),1) - diag(diag(closeBy,2),2) - diag(diag(closeBy,3),3)...
    - diag(diag(closeBy,size(closeBy,1)-1),size(closeBy,1)-1) - diag(diag(closeBy,size(closeBy,1)-2),size(closeBy,1)-2) - diag(diag(closeBy,size(closeBy,1)-3),size(closeBy,1)-3);

removeBetween = [];
skipUntil = 0;
for i = 1:length(cellsX)
    if i > skipUntil
        closePoints = find(closeBy(i,:));
        if numel(closePoints) > 0
            otherPoint = max(closePoints);
            removeBetween = [removeBetween ; i otherPoint]; %#ok<AGROW>
            skipUntil = i + 5;
        end
    end
end

for i = 1:size(removeBetween,1)
    if abs(removeBetween(i,1) - removeBetween(i,2)) > 20
        cellsX(max(removeBetween(i,:)):end) = [];
        cellsX(1:min(removeBetween(i,:))) = [];
        cellsY(max(removeBetween(i,:)):end) = [];
        cellsY(1:min(removeBetween(i,:))) = [];
        removeBetween = removeBetween - min(removeBetween(i,:));
    else
        cellsX(removeBetween(i,1):removeBetween(i,2)) = [];
        cellsY(removeBetween(i,1):removeBetween(i,2)) = [];
        removeBetween = removeBetween - (removeBetween(i,2) - removeBetween(i,1) + 1);
    end
end

windingNumbers = check_if_inside(cellsX,cellsY,d.sub.pointsX, d.sub.pointsY);

outside = windingNumbers == 0;

% substrate points that are outside the cells polygon
points2Remove = find(outside);

if any(d.simset.simulationType == [2,5])
    
    % find all the interactions that are removed
    removedInteractionSelves = [];
    removedInteractionPairs = [];
    
    for i = 1:length(points2Remove)
        removedInteractionSelvesTemp = find(d.sub.interactionSelvesIdx == points2Remove(i));
        removedInteractionPairsTemp = find(d.sub.interactionPairsIdx == points2Remove(i));
        
        removedInteractionSelves = [removedInteractionSelves; removedInteractionSelvesTemp]; %#ok<AGROW>
        removedInteractionPairs = [removedInteractionPairs; removedInteractionPairsTemp]; %#ok<AGROW>
    end
    
    removedInteractions = union(removedInteractionSelves, removedInteractionPairs);
    
    [interactionRows,interactionCols] = ind2sub([6,d.sub.nPoints], d.sub.interactionLinIdx);
    [counterInteractionRows,counterInteractionCols] = ind2sub([6,d.sub.nPoints], d.sub.counterInteractionLinIdx);
    
    if isobject(app)
        iterations = length(removedInteractions)*5 + length(points2Remove)*3;
        current = 0;
        frac = 0;
    end
    
    
    for i = length(removedInteractions):-1:1
        interactionRows(removedInteractions(i)) = [];
        interactionCols(removedInteractions(i)) = [];
        
        counterInteractionRows(removedInteractions(i)) = [];
        counterInteractionCols(removedInteractions(i)) = [];
        
        if isobject(app)
            current = current + 1;
            fracTemp = current/iterations;
            if fracTemp >= frac
                if progressdlg.CancelRequested
                    d = 1;
                    return
                end
                frac = frac + 0.01;
                progressdlg.Value = fracTemp;
            end
        end
        
    end
    
    interactionMatrix = sparse(interactionRows,interactionCols,1:length(interactionRows),6,d.sub.nPoints);
    counterInteractionMatrix = sparse(counterInteractionRows,counterInteractionCols,1:length(counterInteractionRows),6,d.sub.nPoints);
    
    for i = length(points2Remove):-1:1
        interactionMatrix(:,points2Remove(i)) = []; %#ok<SPRIX>
        counterInteractionMatrix(:,points2Remove(i)) = []; %#ok<SPRIX>
        if isobject(app)
            current = current + 1;
            fracTemp = current/iterations;
            if fracTemp >= frac
                if progressdlg.CancelRequested
                    d = 1;
                    return
                end
                frac = frac + 0.01;
                progressdlg.Value = fracTemp;
            end
        end
    end
    
    [rows,cols,~] = find(interactionMatrix);
    
    d.sub.interactionLinIdx = uint32(sub2ind([6,size(interactionMatrix,2)], rows, cols));
    
    [rows,cols,values] = find(counterInteractionMatrix);
    [~,idx] = sort(values);
    
    d.sub.counterInteractionLinIdx = uint32(sub2ind([6,size(counterInteractionMatrix,2)], rows(idx), cols(idx)));
    
    removedBRVectors = [];
    removedBRVectors2 = [];
    
    for i = 1:length(removedInteractions)
        removedBRVectors1Temp = find(d.sub.boundaryRepulsionVectorsIdx == removedInteractions(i));
        removedBRVectors2Temp = find(d.sub.boundaryRepulsionVectors2Idx == removedInteractions(i));
        
        removedBRVectors = [removedBRVectors; removedBRVectors1Temp]; %#ok<AGROW>
        removedBRVectors2 = [removedBRVectors2; removedBRVectors2Temp]; %#ok<AGROW>
        if isobject(app)
            current = current + 1;
            fracTemp = current/iterations;
            if fracTemp >= frac
                if progressdlg.CancelRequested
                    d = 1;
                    return
                end
                frac = frac + 0.01;
                progressdlg.Value = fracTemp;
            end
        end
    end
    
    removedBR = union(removedBRVectors, removedBRVectors2);
    
    [repulsionRows,repulsionCols] = ind2sub([6,d.sub.nPoints], d.sub.boundaryRepulsionLinIdx);
    
    for i = length(removedBR):-1:1
        repulsionCols(removedBR(i)) = [];
        repulsionRows(removedBR(i)) = [];
        d.sub.boundaryRepulsionVectorsIdx(removedBR(i)) = [];
        d.sub.boundaryRepulsionVectors2Idx(removedBR(i)) = [];
        d.sub.boundaryRepulsionChangeSigns(removedBR(i)) = [];
        if isobject(app)
            current = current + 1;
            fracTemp = current/iterations;
            if fracTemp >= frac
                if progressdlg.CancelRequested
                    d = 1;
                    return
                end
                frac = frac + 0.01;
                progressdlg.Value = fracTemp;
            end
        end
    end
    
    repulsionSparse = sparse(repulsionRows,repulsionCols,1:length(repulsionRows),6,d.sub.nPoints);
    
    for i = length(points2Remove):-1:1
        repulsionSparse(:,points2Remove(i)) = []; %#ok<SPRIX>
        if isobject(app)
            current = current + 1;
            fracTemp = current/iterations;
            if fracTemp >= frac
                if progressdlg.CancelRequested
                    d = 1;
                    return
                end
                frac = frac + 0.01;
                progressdlg.Value = fracTemp;
            end
        end
    end
    
    [rows,cols,~] = find(repulsionSparse);
    
    d.sub.boundaryRepulsionLinIdx = uint32(sub2ind([6,size(repulsionSparse,2)], rows, cols));
    
    for i = length(removedInteractions):-1:1
        d.sub.boundaryRepulsionVectorsIdx(d.sub.boundaryRepulsionVectorsIdx > removedInteractions(i)) = d.sub.boundaryRepulsionVectorsIdx(d.sub.boundaryRepulsionVectorsIdx > removedInteractions(i)) - 1;
        d.sub.boundaryRepulsionVectors2Idx(d.sub.boundaryRepulsionVectors2Idx > removedInteractions(i)) = d.sub.boundaryRepulsionVectors2Idx(d.sub.boundaryRepulsionVectors2Idx > removedInteractions(i)) - 1;
        if isobject(app)
            current = current + 1;
            fracTemp = current/iterations;
            if fracTemp >= frac
                if progressdlg.CancelRequested
                    d = 1;
                    return
                end
                frac = frac + 0.01;
                if fracTemp > 1
                    fracTemp = 1;
                end
                progressdlg.Value = fracTemp;
            end
        end
    end
    
end

if isobject(app) && d.simset.simulationType == 3
    iterations = length(points2Remove);
    current = 0;
    frac = 0;
end

for i = length(points2Remove):-1:1
    
    
    if any(d.simset.simulationType == [2,5])
        d.sub.interactionSelvesIdx(d.sub.interactionSelvesIdx > points2Remove(i)) = d.sub.interactionSelvesIdx(d.sub.interactionSelvesIdx > points2Remove(i)) - 1;
        d.sub.interactionPairsIdx(d.sub.interactionPairsIdx > points2Remove(i)) = d.sub.interactionPairsIdx(d.sub.interactionPairsIdx > points2Remove(i)) - 1;
    end
    
    d.sub.pointsX(points2Remove(i)) = [];
    d.sub.pointsY(points2Remove(i)) = [];
    d.sub.pointsOriginalX(points2Remove(i)) = [];
    d.sub.pointsOriginalY(points2Remove(i)) = [];
    
    
    
    if isobject(app)
        current = current + 1;
        fracTemp = current/iterations;
        if fracTemp >= frac
            if progressdlg.CancelRequested
                d = 1;
                return
            end
            frac = frac + 0.01;
            if fracTemp > 1
                fracTemp = 1;
            end
            progressdlg.Value = fracTemp;
        end
    end
end

d.sub.nPoints = length(d.sub.pointsX);

if any(d.simset.simulationType == [2,5])
    
    d.sub.interactionSelvesIdx(removedInteractions) = [];
    d.sub.interactionPairsIdx(removedInteractions) = [];
    d.sub.springMultipliers(removedInteractions) = [];

    d.sub.emptyMatrix = zeros(6,d.sub.nPoints);
    
    tempMat = d.sub.emptyMatrix;
    
    tempMat(d.sub.interactionLinIdx) = 1;
    tempMat(d.sub.counterInteractionLinIdx) = 1;
    
    d.sub.edgePoints = sum(tempMat,1) < 6;
    
end

end