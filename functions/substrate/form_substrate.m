function d = form_substrate(d,app)

if isobject(app)
    progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Contructing the substrate',...
        'Indeterminate','on');
end

% number of points in x and y directions
xRows = round(d.spar.substrateSize/d.spar.substratePointDistance);
yRows = round(d.spar.substrateSize/(d.spar.substratePointDistance*sqrt(3)/2));

% find the x coordinate (different for odd and even number of rows)
if mod(yRows,2) == 0
    pointsX = repmat([(0:xRows-1).*d.spar.substratePointDistance d.spar.substratePointDistance/2 + (0:xRows-1).*d.spar.substratePointDistance]',yRows/2,1);
else
    pointsX = repmat([(0:xRows-1).*d.spar.substratePointDistance d.spar.substratePointDistance/2 + (0:xRows-1).*d.spar.substratePointDistance]',(yRows-1)/2,1);
    pointsX = [pointsX; (0:xRows-1)'.*d.spar.substratePointDistance];
end

% find the y coordinates
pointsY = repmat(((0:yRows-1).*d.spar.substratePointDistance*sqrt(3)/2),xRows,1);
pointsY = pointsY(:);

% center and save the coordinates
d.sub.pointsX = pointsX - d.spar.substrateSize/2;
d.sub.pointsY = pointsY - d.spar.substrateSize/2;

% number of the substrate points
d.sub.nPoints = length(d.sub.pointsX);

% save the original coordinates
d.sub.pointsOriginalX = d.sub.pointsX;
d.sub.pointsOriginalY = d.sub.pointsY;

if any(d.simset.simulationType == [2,5])
    % indices for special locations
    bottomRow = 2:xRows-1;
    topRow = d.sub.nPoints-xRows+2:d.sub.nPoints-1;
    leftColumnEven = xRows+1:2*xRows:d.sub.nPoints-xRows;
    leftColumnOdd = 2*xRows+1:2*xRows:d.sub.nPoints-xRows;
    rightColumnEven = 2*xRows:2*xRows:d.sub.nPoints-xRows;
    rightColumnOdd = 3*xRows:2*xRows:d.sub.nPoints-xRows;
    bottomLeftCorner = 1;
    bottomRightCorner = xRows;
    topLeftCorner = d.sub.nPoints-xRows+1;
    topRightCorner = d.sub.nPoints;
    
    % an empty matrix for the interactions
    interactionMatrix = sparse(d.sub.nPoints,d.sub.nPoints);
    
    springMultiplierMatrix = sparse(d.sub.nPoints,d.sub.nPoints);
    
    % an empty matrix for the direct interaction pairs
    directInteractionPairsIdx = zeros(6,d.sub.nPoints);
    
    % empty matrices to store the one of the neighbors for boundary repulsion force
    % and the vector between the two neighbors
    boundaryRepulsionPairsIdx = zeros(6,d.sub.nPoints);
    boundaryRepulsionVectors1Idx = zeros(6,d.sub.nPoints);
    boundaryRepulsionVectors2Idx = zeros(6,d.sub.nPoints);
    boundaryRepulsionChangeSigns = zeros(6,d.sub.nPoints);
    
    % define the squared max pair separation
    maxDistance = (d.spar.substratePointDistance*1.1)^2;
    
    iRow = 1;
    iCol = 1;
    
    constants = app.substrateParameters.honeycombConstants;
    
    modulus = mod(constants, 100);
    alpha = round((constants - modulus)/100);
    constants = constants - alpha*100;
    modulus = mod(constants, 10);
    beta = round((constants - modulus)/10);
    gamma = constants - beta*10;
    
    xPoints = 1:xRows;
    firstIdx = xPoints(1:3:end);
    secondIdx = xPoints(2:3:end);
    thirdIdx = xPoints(3:3:end);
    
    if isobject(app)
        progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Constructing the substrate - Finding closest neighbors...','Cancelable', 'on');
        frac = 0;
    end
    
    % find the closest neighbors
    for i = 1:d.sub.nPoints
        
        % distances between point i and other points
        distances = (d.sub.pointsX(i) - d.sub.pointsX).^2 + (d.sub.pointsY(i) - d.sub.pointsY).^2;
        
        % get the suitable pairs and remove the point itself
        suitablePairs = find(distances < maxDistance);
        suitablePairs(suitablePairs == i) = [];
        
        % sort the pairs to counterclockwise order starting from the most
        % clockwise or the one on most right
        if any(i == bottomRow)
            suitablePairs = suitablePairs([2 4 3 1]);
            if any(iCol == secondIdx)
                sC = [gamma alpha gamma alpha];
            elseif any(iCol == thirdIdx)
                sC = [beta gamma beta gamma];
            elseif any(iCol == firstIdx)
                sC = [alpha beta alpha beta];
            end
        elseif any(i == topRow)
            suitablePairs = suitablePairs([3 1 2 4]);
            if mod(iRow,2) == 0
                if any(iCol == secondIdx)
                    sC = [alpha gamma alpha gamma];
                elseif any(iCol == thirdIdx)
                    sC = [gamma beta gamma beta];
                elseif any(iCol == firstIdx)
                    sC = [beta alpha beta alpha];
                end
            else
                if any(iCol == secondIdx)
                    sC = [alpha gamma alpha gamma];
                elseif any(iCol == thirdIdx)
                    sC = [gamma beta gamma beta];
                elseif any(iCol == firstIdx)
                    sC = [beta alpha beta alpha];
                end
            end
        elseif any(i == leftColumnEven)
            suitablePairs = suitablePairs([1 2 3 5 4]);
            sC = [beta gamma beta gamma beta];
        elseif any(i == leftColumnOdd)
            suitablePairs = suitablePairs([1 2 3]);
            sC = [beta alpha beta];
        elseif any(i == rightColumnEven)
            suitablePairs = suitablePairs([3 2 1]);
            if any(iCol == secondIdx)
                sC = [alpha beta alpha];
            elseif any(iCol == thirdIdx)
                sC = [gamma alpha gamma];
            elseif any(iCol == firstIdx)
                sC = [beta gamma beta];
            end
        elseif any(i == rightColumnOdd)
            suitablePairs = suitablePairs([5 4 3 1 2]);
            if any(iCol == secondIdx)
                sC = [alpha gamma alpha gamma alpha];
            elseif any(iCol == thirdIdx)
                sC = [gamma beta gamma beta gamma];
            elseif any(iCol == firstIdx)
                sC = [beta alpha beta alpha beta];
            end
        elseif i == bottomLeftCorner
            suitablePairs = suitablePairs([1 2]);
            sC = [alpha beta];
        elseif i == bottomRightCorner
            suitablePairs = suitablePairs([3 2 1]);
            if any(iCol == secondIdx)
                sC = [alpha beta alpha];
            elseif any(iCol == thirdIdx)
                sC = [gamma beta gamma];
            elseif any(iCol == firstIdx)
                sC = [beta alpha beta];
            end
        elseif i == topLeftCorner
            if mod(yRows,2) == 1
                suitablePairs = suitablePairs([1 2]);
                sC = [beta alpha];
            else
                suitablePairs = suitablePairs([1 2 3]);
                sC = [beta gamma beta];
            end
        elseif i == topRightCorner
            if mod(yRows,2) == 1
                suitablePairs = suitablePairs([3 1 2]);
                if any(iCol == secondIdx)
                    sC = [alpha gamma alpha];
                elseif any(iCol == thirdIdx)
                    sC = [gamma beta gamma];
                elseif any(iCol == firstIdx)
                    sC = [beta alpha beta];
                end
            else
                suitablePairs = suitablePairs([2 1]);
                if any(iCol == secondIdx)
                    sC = [beta alpha];
                elseif any(iCol == thirdIdx)
                    sC = [alpha gamma];
                elseif any(iCol == firstIdx)
                    sC = [gamma beta];
                end
            end
        else
            suitablePairs = suitablePairs([4 6 5 3 1 2]);
            if mod(iRow,2) == 0
                if any(iCol == secondIdx)
                    sC = [alpha beta alpha beta alpha beta];
                elseif any(iCol == thirdIdx)
                    sC = [gamma alpha gamma alpha gamma alpha];
                elseif any(iCol == firstIdx)
                    sC = [beta gamma beta gamma beta gamma];
                end
            else
                if any(iCol == secondIdx)
                    sC = [gamma alpha gamma alpha gamma alpha];
                elseif any(iCol == thirdIdx)
                    sC = [beta gamma beta gamma beta gamma];
                elseif any(iCol == firstIdx)
                    sC = [alpha beta alpha beta alpha beta];
                end
            end
        end
        
        % input into the interactionMatrix
        interactionMatrix(i,suitablePairs) = 1; %#ok<SPRIX>
        
        % input the sorted pairs to the repulsion pair matrix
        boundaryRepulsionPairsIdx(1:length(suitablePairs),i) = suitablePairs;
        
        for k = 1:length(suitablePairs)
            springMultiplierMatrix(i,suitablePairs(k)) = sC(k); %#ok<SPRIX>
        end
        
        if iCol == xRows
            iRow = iRow+1;
            iCol = 1;
        else
            iCol = iCol + 1;
        end
        
        if isobject(app)
            fracTemp = i/d.sub.nPoints;
            if fracTemp >= frac
                if progressdlg.CancelRequested
                    d = 1;
                    return
                end
                frac = frac + 0.01;
                progressdlg.Value = fracTemp;
            end
        end
        
        % find the closest neighbors
        
        
    end
    
    if isobject(app)
        progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Constructing the substrate - Defining interactions...','Cancelable', 'on');
        frac = 0;
    end
    
    % find unique interaction rows and columns from the matrix
    [interactionRows,interactionCols] = find(tril(interactionMatrix));
    
    
    idxTemp = sub2ind([d.sub.nPoints d.sub.nPoints],interactionRows,interactionCols);
    
    d.sub.springMultipliers = full(springMultiplierMatrix(idxTemp));
    
    % form a pair vector from the interaction pairs
    interactionPairs = [interactionCols,interactionRows];
    
    % save the self and pair indices for each unique interaction in the
    % interaction matrix
    d.sub.interactionSelvesIdx = uint32(interactionCols);
    d.sub.interactionPairsIdx = uint32(interactionRows);
    
    
    % form two matrices to give each interaction pair an unique index, which
    % can be used for the counter interaction
    interactionMatrixIdx = sparse(interactionCols,interactionRows,1:length(interactionCols),d.sub.nPoints,d.sub.nPoints);
    counterInteractionMatrixIdx = sparse(interactionRows,interactionCols,1:length(interactionCols),d.sub.nPoints,d.sub.nPoints);
    
    % go through the points
    for i = 1:d.sub.nPoints
        
        % input the direct interaction indices to the direct interaction matrix
        % (unique interactions on rows 1:3 and counter interactions on rows
        % 4:6)
        directInteractionPairsIdx(1:nnz(interactionMatrixIdx(i,:)),i) = nonzeros(interactionMatrixIdx(i,:))';
        directInteractionPairsIdx(4:3+nnz(counterInteractionMatrixIdx(i,:)),i) = nonzeros(counterInteractionMatrixIdx(i,:))';
        
        % get the boundary repulsion pairs for point i and their number
        boundaryRepulsionPairsIdxTemp = nonzeros(boundaryRepulsionPairsIdx(:,i))';
        nPairs = length(boundaryRepulsionPairsIdxTemp);
        
        % FIND THE INDICES OF THE UNIQUE INTERACTION VECTORS THAT CORRESPONDS
        % TO THE 2 VECTORS NEEDED IN THE boundary REPULSION FORCE CALCULATION (1:
        % BETWEEN PAIR 1 AND POINT i; 2: BETWEEN PAIR 1 AND PAIR 2
        
        % substrate boundarys or corners
        if nPairs < 6
            
            % go through the pairs (excluding the last one)
            for j = 1:nPairs-1
                
                % find the index of the matching interaction pair (checking
                % both ways) and save it to the vector 1 matrix
                match = interactionPairs(:,1) == i;
                match(match) = interactionPairs(match,2) == boundaryRepulsionPairsIdxTemp(j);
                idx = find(match);
                if ~isempty(idx)
                    boundaryRepulsionVectors1Idx(j,i) = idx;
                    boundaryRepulsionChangeSigns(j,i) = 1;
                else
                    match = interactionPairs(:,2) == i;
                    match(match) = interactionPairs(match,1) == boundaryRepulsionPairsIdxTemp(j);
                    boundaryRepulsionVectors1Idx(j,i) = find(match);
                end
                
                % indices of the vector 2 in the pairs of point i
                boundaryPair = j:j+1;
                
                % find the index of the matching interaction pair (checking
                % both ways) and save it to the vector 2 matrix
                match = interactionPairs(:,1) == boundaryRepulsionPairsIdxTemp(boundaryPair(1));
                match(match) = interactionPairs(match,2) == boundaryRepulsionPairsIdxTemp(boundaryPair(2));
                idx = find(match);
                if ~isempty(idx)
                    boundaryRepulsionVectors2Idx(j,i) = idx;
                else
                    match = interactionPairs(:,2) == boundaryRepulsionPairsIdxTemp(boundaryPair(1));
                    match(match) = interactionPairs(match,1) == boundaryRepulsionPairsIdxTemp(boundaryPair(2));
                    boundaryRepulsionVectors2Idx(j,i) = find(match);
                end
            end
            
            % remove the last pair, since this is the end of the boundary vector
            % and thus not needed)
            boundaryRepulsionPairsIdx(nPairs,i) = 0;
        else
            
            % go through the pairs
            for j = 1:nPairs
                
                % find the index of the matching interaction pair (checking
                % both ways) and save it to the vector 1 matrix
                match = interactionPairs(:,1) == i;
                match(match) = interactionPairs(match,2) == boundaryRepulsionPairsIdxTemp(j);
                idx = find(match);
                if ~isempty(idx)
                    boundaryRepulsionVectors1Idx(j,i) = idx;
                    boundaryRepulsionChangeSigns(j,i) = 1;
                else
                    match = interactionPairs(:,2) == i;
                    match(match) = interactionPairs(match,1) == boundaryRepulsionPairsIdxTemp(j);
                    boundaryRepulsionVectors1Idx(j,i) = find(match);
                end
                
                % indices of the boundary pairs in the pairs of point i (last is
                % different
                if j == nPairs
                    boundaryPair = [nPairs 1];
                else
                    boundaryPair = j:j+1;
                end
                
                % find the index of the matching interaction pair (checking
                % both ways) and save it to the index the vector2 matrix
                match = interactionPairs(:,1) == boundaryRepulsionPairsIdxTemp(boundaryPair(1));
                match(match) = interactionPairs(match,2) == boundaryRepulsionPairsIdxTemp(boundaryPair(2));
                idx = find(match);
                if ~isempty(idx)
                    boundaryRepulsionVectors2Idx(j,i) = idx;
                else
                    match = interactionPairs(:,2) == boundaryRepulsionPairsIdxTemp(boundaryPair(1));
                    match(match) = interactionPairs(match,1) == boundaryRepulsionPairsIdxTemp(boundaryPair(2));
                    boundaryRepulsionVectors2Idx(j,i) = find(match);
                end
            end
        end
        
        if isobject(app)
            fracTemp = i/d.sub.nPoints;
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
    
    if isobject(app)
        progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Contructing the substrate',...
            'Indeterminate','on');
    end
    
    % get the unique interactions in the 6-by-nPoints matrix
    uniqueInteractions = directInteractionPairsIdx(1:3,:);
    
    % find the unique interaction rows and cols
    [cols,rows] = find(uniqueInteractions);
    
    % linear indices of the unique interactions in the 6-by-nPoints matrix
    d.sub.interactionLinIdx = uint32(sub2ind([6,d.sub.nPoints],cols,rows));
    
    % get the counter interactions in the 6-by-nPoints matrix
    counterInteractions = directInteractionPairsIdx(4:6,:);
    
    % linear indices of the corresponding unique interactions in the
    % counterInteractions matrix
    [~,counterIdx] = ismember(nonzeros(uniqueInteractions(:)),counterInteractions(:));
    
    % get the rows and cols of the counterInteractions
    [rows,cols] = ind2sub([3,d.sub.nPoints],counterIdx(:));
    
    % add 3 to the rows (to occupy 4:6 half of the matrix)
    rows = rows + 3;
    
    % linear indices of the counter interactions in the 6-by-nPoints matrix
    d.sub.counterInteractionLinIdx = uint32(sub2ind([6,d.sub.nPoints],rows,cols));
    
    % linear indices of the boundary repulsion interactions in the 6-by-nPoints
    % matrix
    [row,col] = find(boundaryRepulsionPairsIdx > 0);
    d.sub.boundaryRepulsionLinIdx = uint32(sub2ind([6,d.sub.nPoints],row,col));
    
    % indices of the unique interaction vectors that each boundary repulsion vector
    % (1 and 2) corresponds to
    d.sub.boundaryRepulsionVectorsIdx = uint32(boundaryRepulsionVectors1Idx(d.sub.boundaryRepulsionLinIdx));
    d.sub.boundaryRepulsionVectors2Idx = uint32(boundaryRepulsionVectors2Idx(d.sub.boundaryRepulsionLinIdx));
    
    % vector used to flip the signs of vectors that are defined in the other
    % direction in the unique interactions
    d.sub.boundaryRepulsionChangeSigns = ones(size(boundaryRepulsionChangeSigns));
    boundaryRepulsionChangeSigns = ~logical(boundaryRepulsionChangeSigns);
    d.sub.boundaryRepulsionChangeSigns(boundaryRepulsionChangeSigns) = -1;
    d.sub.boundaryRepulsionChangeSigns = d.sub.boundaryRepulsionChangeSigns(d.sub.boundaryRepulsionLinIdx);
    
    % empty matrix for faster matrix initialization
    d.sub.emptyMatrix = zeros(6,d.sub.nPoints);
end

if d.simset.simulationType == 3

    if d.simset.stretch.axis == 1
        d.sub.pointsX = d.sub.pointsX.*d.simset.stretch.values(1);
    elseif d.simset.stretch.axis == 2
        d.sub.pointsX = d.sub.pointsX.*d.simset.stretch.values(1);
        d.sub.pointsY = d.sub.pointsY.*d.simset.stretch.values(1);
    end
    
end


