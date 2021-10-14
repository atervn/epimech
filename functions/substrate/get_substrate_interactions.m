function d = get_substrate_interactions(app, d, nX, nY)
%   INPUT:
%       app: main application structure
%       d: main simulation data structure
%       nX: number of points in a substrate row
%       nY: number of substrate row
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% get special substrate point indices
specialCase = get_special_substrate_points(nX,d.sub.nPoints);

% create an empty sparse matrix for the interactions
interactionMatrix = sparse(d.sub.nPoints,d.sub.nPoints);

% create an empty sparse matrix for the triple honeycomb multipliers for
% each interaction
multiplierMatrix = sparse(d.sub.nPoints,d.sub.nPoints);

% an empty matrix for the central interaction pairs
centralInteractionPairsIdx = zeros(6,d.sub.nPoints);

% empty matrices to store the information related to the repulsion
% interactions
repulsionPairsIdx = zeros(6,d.sub.nPoints);
repulsionInteractions1Idx = zeros(6,d.sub.nPoints);
repulsionInteractions2Idx = zeros(6,d.sub.nPoints);
repulsionChangeSigns = zeros(6,d.sub.nPoints);

% define the squared distance to find the neighboring points (all
% neighborins are at a distance of squarePointDistance)
maxDistanceSq = (d.spar.substratePointDistance*1.1)^2;

% if simulation is using the GUI, setup the progress dialog
if isobject(app)
    progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Constructing the substrate - Finding closest neighbors...','Cancelable', 'on');
    
    % variable to track when the progress is updated
    updateFrac = 0;
end

% get the honeycomb constants
constants = get_honeycomb_constants(app);

% create vectors of indices to get the every third index starting from the
% first, second and third point from the beginning of each row
tempIdx = 1:nX;
rowIdx.first = tempIdx(1:3:end);
rowIdx.second = tempIdx(2:3:end);
rowIdx.third = tempIdx(3:3:end);

% indices to indicate the point position within the substrate
iRow = 1;
iCol = 1;

% go through the points
for i = 1:d.sub.nPoints
    
    % get squared distances between point i and other points
    distancesSq = (d.sub.pointsX(i) - d.sub.pointsX).^2 + (d.sub.pointsY(i) - d.sub.pointsY).^2;
    
    % get the points within the pair distance and remove the point itself
    suitablePairs = find(distancesSq < maxDistanceSq);
    suitablePairs(suitablePairs == i) = [];
    
    % order pairs and get honeycomb constants
    [suitablePairs, constantsTemp] = order_pairs_get_constants(suitablePairs, i, iRow, iCol, specialCase, constants, rowIdx, nY);
    
    % input into the interactions into the interactionMatrix
    interactionMatrix(i,suitablePairs) = 1; %#ok<SPRIX>
    
    % input the sorted pairs to the repulsion pair matrix
    repulsionPairsIdx(1:length(suitablePairs),i) = suitablePairs;
    
    % for each interaction, assign the correct honeycomb constant in the
    % multiplier matrix
    for k = 1:length(suitablePairs)
        multiplierMatrix(i,suitablePairs(k)) = constantsTemp(k); %#ok<SPRIX>
    end
    
    % if the current point is the last point of the row
    if iCol == nX
        
        % go to the next row and to the first point
        iRow = iRow+1;
        iCol = 1;
    
    % otherwise
    else
        
        % go to the next point in the row
        iCol = iCol + 1;
    end
    
    % if simulation is using the GUI, update the progress dialog
    if isobject(app)
        
        % calculate the progress
        fracTemp = i/d.sub.nPoints;
        
        % if the progress has surpassed the value where the progress is
        % updated
        if fracTemp >= updateFrac
            
            % if user request to cancel the substrate creation, return
            if progressdlg.CancelRequested
                d = 1;
                return
            end
            
            % increase the value for the next update
            updateFrac = updateFrac + 0.01;
            
            % update the dialog
            progressdlg.Value = fracTemp;
        end
    end
end

% if the progress has surpassed the value where the progress is
% updated
if isobject(app)
    progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Constructing the substrate - Defining interactions...','Cancelable', 'on');
    
    % variable to track when the progress is updated
    updateFrac = 0;
end

% find unique interaction rows and columns from the interaction matrix
% (lower triangle)
[interactionRows,interactionCols] = find(tril(interactionMatrix));

% get the linear indices of the unique interactions
idxTemp = sub2ind([d.sub.nPoints d.sub.nPoints],interactionRows,interactionCols);

% get the honeycomb multipliers for each unique interaction
d.sub.springMultipliers = full(multiplierMatrix(idxTemp));

% form a pair matrix from the interaction pairs
interactionPairs = [interactionCols,interactionRows];

% save the "self" and pair indices for each unique interaction in the
% interaction matrix
d.sub.interactionSelvesIdx = uint32(interactionCols);
d.sub.interactionPairsIdx = uint32(interactionRows);

% form two matrices to give each interaction pair an unique index, which
% can be used for the counter interaction. The unique interactions are
% those that a point has with a other points that have higher index. The
% counter interactions are those that a point has with other points with a
% smaller index. Therefore, each unique interactions has a counter
% interaction. Each point has a maximum of 3 unique interactions and a
% maximum of 3 counter interactions.
interactionMatrixIdx = sparse(interactionCols,interactionRows,1:length(interactionCols),d.sub.nPoints,d.sub.nPoints);
counterInteractionMatrixIdx = sparse(interactionRows,interactionCols,1:length(interactionCols),d.sub.nPoints,d.sub.nPoints);

% go through the points
for i = 1:d.sub.nPoints
    
    % input the central interaction indices to the central interaction
    % matrix (unique interactions on rows 1:3 and counter interactions on
    % rows 4:6). There will be the same unique interaction index twice in
    % the matrix, once in the "unique section (1:3) and once in the
    % "counter" section (4:6)
    centralInteractionPairsIdx(1:nnz(interactionMatrixIdx(i,:)),i) = nonzeros(interactionMatrixIdx(i,:))';
    centralInteractionPairsIdx(4:3+nnz(counterInteractionMatrixIdx(i,:)),i) = nonzeros(counterInteractionMatrixIdx(i,:))';
    
    % get the data for the repulsive interactions for point i
    [repulsionPairsIdx, repulsionInteractions1Idx, repulsionChangeSigns, repulsionInteractions2Idx] = get_repulsion_interaction_data(i, interactionPairs, repulsionPairsIdx, repulsionInteractions1Idx, repulsionChangeSigns, repulsionInteractions2Idx);
    
    % if simulation is using the GUI, update the progress dialog
    if isobject(app)
        
        % calculate the progress
        fracTemp = i/d.sub.nPoints;
        
        % if the progress has surpassed the value where the progress is
        % updated
        if fracTemp >= updateFrac
            
            % if user request to cancel the substrate creation, return
            if progressdlg.CancelRequested
                d = 1;
                return
            end
            
            % increase the value for the next update
            updateFrac = updateFrac + 0.01;
            
            % update the dialog
            progressdlg.Value = fracTemp;
        end
    end
end

% if simulation is using the GUI, update the progress dialog
if isobject(app)
    uiprogressdlg(app.EpiMechUIFigure,'Title','Creating the substrate',...
        'Indeterminate','on');
end

% get the unique interactions in the 6-by-nPoints matrix
uniqueInteractions = centralInteractionPairsIdx(1:3,:);

% find the unique interaction rows and cols
[cols,rows] = find(uniqueInteractions);

% get linear indices of the unique interactions in the 6-by-nPoints matrix
d.sub.interactionLinIdx = uint32(sub2ind([6,d.sub.nPoints],cols,rows));

% get the counter interactions in the 6-by-nPoints matrix
counterInteractions = centralInteractionPairsIdx(4:6,:);

% get linear indices of the unique interactions corresponding to each
% counter interactions in the counterInteractions matrix
[~,counterIdx] = ismember(nonzeros(uniqueInteractions(:)),counterInteractions(:));

% get the rows and cols of the counterInteractions
[rows,cols] = ind2sub([3,d.sub.nPoints],counterIdx(:));

% add 3 to the rows (to occupy 4:6 half of the matrix)
rows = rows + 3;

% get linear indices of the counter interactions in the 6-by-nPoints matrix
d.sub.counterInteractionLinIdx = uint32(sub2ind([6,d.sub.nPoints],rows,cols));

% get linear indices of the boundary repulsion interactions in the 
% 6-by-nPoints matrix
[row,col] = find(repulsionPairsIdx > 0);
d.sub.repulsionLinIdx = uint32(sub2ind([6,d.sub.nPoints],row,col));

% get indices of the unique interaction vectors that each repulsion
% interaction (1 and 2) corresponds to
d.sub.repulsionVectors1Idx = uint32(repulsionInteractions1Idx(d.sub.repulsionLinIdx));
d.sub.repulsionVectors2Idx = uint32(repulsionInteractions2Idx(d.sub.repulsionLinIdx));

% get the vector used to flip the signs of vectors that are defined in the
% other direction in the unique interactions
d.sub.repulsionChangeSigns = ones(size(repulsionChangeSigns));
repulsionChangeSigns = logical(repulsionChangeSigns);
d.sub.repulsionChangeSigns(repulsionChangeSigns) = -1;
d.sub.repulsionChangeSigns = d.sub.repulsionChangeSigns(d.sub.repulsionLinIdx);

% empty matrix for faster matrix initialization
d.sub.emptyMatrix = zeros(6,d.sub.nPoints);

end