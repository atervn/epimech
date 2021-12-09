function d = remove_substrate_points(app,d,expansionMultiplier)
% REMOVA_SUBSTRATE_POINTS Remove extra substrate points
%   The function removes extra points from the substrate when using the
%   fitted substrate type. It forms a polyshape from the cells and uses it
%   to defined which points are not near the cells. Then it proceeds to
%   remove the point interaction data and the point coordinates.
%   INPUT:
%       app: main application object
%       d: main simulation data structure
%       expansionMultiplier: multiplier used to determine how much the
%           cells are expended when creating the polyshape, in practice
%           describes how far from the cells the substrate points are
%           removed
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if the simulation is run from the GUI, update the progress dialog
if isobject(app)
    progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Contructing the substrate - Removing extra points...',...
        'Cancelable','on');
end

% create a polyshape object
polyCells = polyshape;

% turn off polyshape repairing warning
warning('off','MATLAB:polyshape:repairedBySimplify')

%% Expand the cells and add them to the polyCells polyshape

% go through the cells
for k = 1:length(d.cells)
    
    % get the vectors from the right neighbors to the left neighbors
    tempX = d.cells(k).leftVectorsX + d.cells(k).rightVectorsX;
    tempY = d.cells(k).leftVectorsY + d.cells(k).rightVectorsY;
    
    % get the surface normals at the vertices
    normalsX = tempY;
    normalsY = -tempX;
    
    % get the normal lengths and calculate the unit normal vectors
    normalLengths = sqrt(normalsX.^2 + normalsY.^2);
    normalsX = normalsX./normalLengths;
    normalsY = normalsY./normalLengths;
    
    % stretch simulation
    if d.simset.simulationType == 3
        
        % move the vertices along along the surface normal direction with
        % the distance of substrate point distance multiplied by the
        % substrate stretch value and the expansion multiplier
        expandedX = d.cells(k).verticesX + normalsX.*d.spar.substratePointDistance.*d.simset.stretch.values(1).*expansionMultiplier;
        expandedY = d.cells(k).verticesY + normalsY.*d.spar.substratePointDistance.*d.simset.stretch.values(1).*expansionMultiplier;
        
    % otherwise
    else
        
        % move the vertices along along the surface normal direction with
        % the distance of substrate point distance multiplied by the
        % expansion multiplier
        expandedX = d.cells(k).verticesX + normalsX.*d.spar.substratePointDistance.*expansionMultiplier;
        expandedY = d.cells(k).verticesY + normalsY.*d.spar.substratePointDistance.*expansionMultiplier;
    end
    
    % create a polyshape out of the expanded cell and run the polyshape
    % simplification (rmove dublicate vertices and boundary intersections,
    % etc.)
    tempPolyCell = polyshape(expandedX,expandedY);
    tempPolyCell = simplify(tempPolyCell);
    
    % find possible NaNs in the coordinates (may result from the
    % simplification)
    if any(isnan(tempPolyCell.Vertices(:,1)))
        
        % if there are NaNs (they separate different shapes produced by the
        % simplify, i.e. due to intersection), get the index
        nanInd = find(isnan(tempPolyCell.Vertices(:,1)));
        
        % get only the first shape in the polyshape (before NaN)
        tempPolyCell = polyshape(tempPolyCell.Vertices(1:nanInd-1,1),tempPolyCell.Vertices(1:nanInd-1,2));
    end

    % create a union with the main polyCells shape
    polyCells = union(polyCells,tempPolyCell);
end

% turn on polyshape repairing warning
warning('on','MATLAB:polyshape:repairedBySimplify')

% remove possible holes from the polyCells polyshape
polyCells = rmholes(polyCells);

% get the coordinates of the polyshape vertices
cellsX = polyCells.Vertices(:,1);
cellsY = polyCells.Vertices(:,2);

%% Remove narrow crevises in the shape

% to remove small crevices in the combined polyshape, calcula the distance
% between all polyshape vertices
distances = sqrt((cellsX - cellsX').^2 + (cellsY - cellsY').^2);

% find the vertices that are two close by in the upper triangle of the
% distance matrix
closeBy = triu(distances < d.spar.rCell/5);

% to remove the the immediate neighbors as well as the second, and third
% neighbors on each direction, set them to false in the matrix (in
% practice, remove the diagonal (the distance of the point from itself, as
% well as the first, second, and third diagonal upwards. Also, the close
% interactions around the index 1 and end, located at the matrix upper righ
% corner have to be taken into account, this is done on the second line) 
closeBy = closeBy - diag(diag(closeBy)) - diag(diag(closeBy,1),1) - diag(diag(closeBy,2),2) - diag(diag(closeBy,3),3)...
    - diag(diag(closeBy,size(closeBy,1)-1),size(closeBy,1)-1) - diag(diag(closeBy,size(closeBy,1)-2),size(closeBy,1)-2) - diag(diag(closeBy,size(closeBy,1)-3),size(closeBy,1)-3);

% initialize a matrix to collect the section of polyshape that have to be
% removed (that include crevices)
removeBetween = [];

% variable used to skip the section that are removed
skipUntil = 0;

% go through the polyshape vertices
for i = 1:length(cellsX)
    
    % check if the vertex is in a section that is removed (skip if yes)
    if i > skipUntil
        
        % find the close vertices for this vertex
        closeVertices = find(closeBy(i,:));
        
        % if there are any
        if numel(closeVertices) > 0
            
            % check if the close by vertex with the highest distance is on
            % the other side of i == 1 (this is relevant for the vertices
            % close the end of the indices)
            if max(closeVertices) - i > i + size(closeBy,1) - max(closeVertices)
                
                % add these vertices to the sections to be removed
                removeBetween = [removeBetween ; max(closeVertices) i]; %#ok<AGROW>
                
                % skip until the end of the shape indices, since the rest
                % of the shape is to be removed
                skipUntil = i;
                
            % otherwise
            else
                
                % select the close by vertex with the highest index as the
                % other vertex
                otherPoint = max(closeVertices);
                
                % skip until the end of the section to be removed
                skipUntil = otherPoint;
            
                % add these vertices to the sections to be removed
                removeBetween = [removeBetween ; i otherPoint]; %#ok<AGROW>
            end
        end
    end
end

% go through the sections to be removed
for i = 1:size(removeBetween,1)
    
    % if the section to be removed goes over the cut point of the closed
    % polygon
    if removeBetween(i,1) > removeBetween(i,2)
        
        % removed the vertices at the end
        cellsX(max(removeBetween(i,:)):end) = [];
        cellsY(max(removeBetween(i,:)):end) = [];
        
        % remove the vertices at the beginning
        cellsX(1:min(removeBetween(i,:))) = [];
        cellsY(1:min(removeBetween(i,:))) = [];
        
        % reduce the indices of the rest of the removed section indices
        % based on the number of vertices removed from the beginning
        removeBetween = removeBetween - min(removeBetween(i,:));
    
    % otherwise
    else
        
        % removed the vertices between the close by vertices
        cellsX(removeBetween(i,1):removeBetween(i,2)) = [];
        cellsY(removeBetween(i,1):removeBetween(i,2)) = [];
        
        % reduce the indices of the rest of the removed section indices
        % based on the number of vertices removed
        removeBetween = removeBetween - (removeBetween(i,2) - removeBetween(i,1) + 1);
    end
end

%% Remove the substrate points outside the shape

% check which substrate vertices are outside the shape
outside = check_if_inside(cellsX,cellsY,d.sub.pointsX, d.sub.pointsY) == 0;

% find the indices of the substrate points outside the shape
points2Remove = find(outside);

% if substrate is solved
if d.simset.substrateSolved
    
    % initialize vectors to indicate the interactions that have to be
    % removed
    removedInteractionSelves = [];
    removedInteractionPairs = [];
    
    % go through the points that are removed
    for i = 1:length(points2Remove)
        
        % find all the interactions where the current point is either the
        % "self" or the pair and add them to the list of the interactions
        % to be removed
        removedInteractionSelves = [removedInteractionSelves; find(d.sub.interactionSelvesIdx == points2Remove(i))]; %#ok<AGROW>
        removedInteractionPairs = [removedInteractionPairs; find(d.sub.interactionPairsIdx == points2Remove(i))]; %#ok<AGROW>
    end
    
    % get the union of the interactions to be removed
    removedInteractions = union(removedInteractionSelves, removedInteractionPairs);
    
    % get the rows and cols of the unique and counter interactions in the
    % substrate matrix
    [interactionRows,interactionCols] = ind2sub([6,d.sub.nPoints], d.sub.interactionLinIdx);
    [counterInteractionRows,counterInteractionCols] = ind2sub([6,d.sub.nPoints], d.sub.counterInteractionLinIdx);
    
    % if the simulation is run from the GUI, initialize variable to
    % calculate the progress
    if isobject(app)
        
        % get the number of steps that will be done during the interaction
        % and point removal
        iterations = length(removedInteractions)*5 + length(points2Remove)*3;
        
        % variable for the current step and progress update fraction
        current = 0;
        updateFrac = 0;
    end
    
    % go through the interactions to remove (in reverse)
    for i = length(removedInteractions):-1:1
        
        % Remove the interactions from the unique and counter interaction
        % rows and cols
        interactionRows(removedInteractions(i)) = [];
        interactionCols(removedInteractions(i)) = [];
        counterInteractionRows(removedInteractions(i)) = [];
        counterInteractionCols(removedInteractions(i)) = [];
        
        % if the simulation is run from the GUI, update progress
        if isobject(app)
            [current, updateFrac] = update_point_removal_progress_dialog(progressdlg, current, updateFrac, iterations);
            if current == -1; d = 1; return; end
        end
    end
    
    % create sparse matrices with the size of the main substrate
    % interaction matrix of the remaining unique and counter interactions
    % and number to interactions with a runnnig number
    interactionMatrix = sparse(interactionRows,interactionCols,1:length(interactionRows),6,d.sub.nPoints);
    counterInteractionMatrix = sparse(counterInteractionRows,counterInteractionCols,1:length(counterInteractionRows),6,d.sub.nPoints);
    
    % go through the points that are removed (in reverse)
    for i = length(points2Remove):-1:1
        
        % remove the columns for the removed points in the unique and
        % counter interaction matrices
        interactionMatrix(:,points2Remove(i)) = []; %#ok<SPRIX>
        counterInteractionMatrix(:,points2Remove(i)) = []; %#ok<SPRIX>
        
        % if the simulation is run from the GUI, update progress
        if isobject(app)
            [current, updateFrac] = update_point_removal_progress_dialog(progressdlg, current, updateFrac, iterations);
            if current == -1; d = 1; return; end
        end
    end
    
    % find the rows and the cols of the remaining unique interactions in
    % the matrix
    [rows,cols,~] = find(interactionMatrix);
    
    % get linear indices from the interactions
    d.sub.interactionLinIdx = uint32(sub2ind([6,size(interactionMatrix,2)], rows, cols));
    
    % get the rows, cols, and values of the remaining counter interactions
    % in the matrix
    [rows,cols,values] = find(counterInteractionMatrix);
    
    % get indices by sorting based on the running index values defined
    % earlier (each running index correspond to the same index in the
    % unique interactions matrix, which is ordered correctly without
    % sorting, and thus ordering the counter interactions in essence based
    % on the same numbers, the unique and counter interaction with the same
    % index correspond to each other)
    [~,idx] = sort(values);
    
    % get the linear indices for the counter interactions so that the index
    % at positions 1 corresponds to the interaction in the linear indices
    % for the unique interactions at position 1 (and so on)
    d.sub.counterInteractionLinIdx = uint32(sub2ind([6,size(counterInteractionMatrix,2)], rows(idx), cols(idx)));
    
    % initialize vectors to collect the repulsion vectors to be removed
    removedRepulsionVectors1 = [];
    removedRepulsionVectors2 = [];
    
    % go through the removed interactions
    for i = 1:length(removedInteractions)

        % find all the repulsion vectors (either 1 or 2) that are defined
        % by the same interaction that are being removed
        removedRepulsionVectors1 = [removedRepulsionVectors1; find(d.sub.repulsionVectors1Idx == removedInteractions(i))]; %#ok<AGROW>
        removedRepulsionVectors2 = [removedRepulsionVectors2; find(d.sub.repulsionVectors2Idx == removedInteractions(i))]; %#ok<AGROW>
        
        % if the simulation is run from the GUI, update progress
        if isobject(app)
            [current, updateFrac] = update_point_removal_progress_dialog(progressdlg, current, updateFrac, iterations);
            if current == -1; d = 1; return; end
        end
    end
    
    % get union of the removed repulsion vectors
    removedRepulsionVectors = union(removedRepulsionVectors1, removedRepulsionVectors2);
    
    % get the rows and cols of the repulsion pair linear indices
    [repulsionRows,repulsionCols] = ind2sub([6,d.sub.nPoints], d.sub.repulsionLinIdx);
    
    % fo through the removed vectors (in reserve)
    for i = length(removedRepulsionVectors):-1:1
        
        % remove the vectors from the rows and cols
        repulsionCols(removedRepulsionVectors(i)) = [];
        repulsionRows(removedRepulsionVectors(i)) = [];
        
        % remove the vectors from the repulsion vector 1 and 2 and change
        % signs vectors
        d.sub.repulsionVectors1Idx(removedRepulsionVectors(i)) = [];
        d.sub.repulsionVectors2Idx(removedRepulsionVectors(i)) = [];
        d.sub.repulsionChangeSigns(removedRepulsionVectors(i)) = [];
        
        % if the simulation is run from the GUI, update progress
        if isobject(app)
            [current, updateFrac] = update_point_removal_progress_dialog(progressdlg, current, updateFrac, iterations);
            if current == -1; d = 1; return; end
        end
    end
    
    % create sparse matrices filled with ones with the size of the main
    % substrate interaction matrix of the remaining repulsion vector rows
    % and cols
    repulsionSparse = sparse(repulsionRows,repulsionCols,ones(1,length(repulsionRows)),6,d.sub.nPoints);
    
    % go through the removed points (in reverse)
    for i = length(points2Remove):-1:1
        
        % remove the columns corresponding to each point
        repulsionSparse(:,points2Remove(i)) = []; %#ok<SPRIX>
        
        % if the simulation is run from the GUI, update progress
        if isobject(app)
            [current, updateFrac] = update_point_removal_progress_dialog(progressdlg, current, updateFrac, iterations);
            if current == -1; d = 1; return; end
        end
    end
    
    % find the new rows and cols of the vectors
    [rows,cols,~] = find(repulsionSparse);
    
    % get the updated linear indices for the repulsion forces in
    % interaction matrix
    d.sub.repulsionLinIdx = uint32(sub2ind([6,size(repulsionSparse,2)], rows, cols));
    
    % go through the removed interactions (in reverse) and modify the
    % interaction numbering in the repulsion vectors
    for i = length(removedInteractions):-1:1
        
        % for each repulsion vector, reduce the interaction index by one if
        % it they are higher than the removed interaction
        d.sub.repulsionVectors1Idx(d.sub.repulsionVectors1Idx > removedInteractions(i)) = d.sub.repulsionVectors1Idx(d.sub.repulsionVectors1Idx > removedInteractions(i)) - 1;
        d.sub.repulsionVectors2Idx(d.sub.repulsionVectors2Idx > removedInteractions(i)) = d.sub.repulsionVectors2Idx(d.sub.repulsionVectors2Idx > removedInteractions(i)) - 1;
        
        % if the simulation is run from the GUI, update progress
        if isobject(app)
            [current, updateFrac] = update_point_removal_progress_dialog(progressdlg, current, updateFrac, iterations);
            if current == -1; d = 1; return; end
        end
    end
    
end

% if the simulation is run from the GUI and the type is stretch
if isobject(app) && d.simset.simulationType == 3
    
    % initialize the number iteration, current step and the progress update
    % fraction
    iterations = length(points2Remove);
    current = 0;
    updateFrac = 0;
end

% go throught the removed points (in reverse)
for i = length(points2Remove):-1:1
    
    % if substrate is solved
    if d.simset.substrateSolved
        
        % reduce the indices of the interaction "selves" and pairs by one
        % if they have higher index than the removed point
        d.sub.interactionSelvesIdx(d.sub.interactionSelvesIdx > points2Remove(i)) = d.sub.interactionSelvesIdx(d.sub.interactionSelvesIdx > points2Remove(i)) - 1;
        d.sub.interactionPairsIdx(d.sub.interactionPairsIdx > points2Remove(i)) = d.sub.interactionPairsIdx(d.sub.interactionPairsIdx > points2Remove(i)) - 1;
    end
    
    % remove the points from the coordinates and original coordinates
    d.sub.pointsX(points2Remove(i)) = [];
    d.sub.pointsY(points2Remove(i)) = [];
    d.sub.pointsOriginalX(points2Remove(i)) = [];
    d.sub.pointsOriginalY(points2Remove(i)) = [];
    
    % if the simulation is run from the GUI, update progress
    if isobject(app)
        [current, updateFrac] = update_point_removal_progress_dialog(progressdlg, current, updateFrac, iterations);
        if current == -1; d = 1; return; end
    end
end

% update the number of points
d.sub.nPoints = length(d.sub.pointsX);

% if substrate is solved
if d.simset.substrateSolved
    
    % remove the remove interactions from the both index vectors and the
    % spring multiplier vectors
    d.sub.interactionSelvesIdx(removedInteractions) = [];
    d.sub.interactionPairsIdx(removedInteractions) = [];
    d.sub.springMultipliers(removedInteractions) = [];

    % recreate the empty substrate matrix
    d.sub.emptyMatrix = zeros(6,d.sub.nPoints);
end

end

function [current, updateFrac] = update_point_removal_progress_dialog(progressdlg, current, updateFrac, iterations)
% UPDATE_POINT_REMOVAL_RPOGRESS_DIALOG Update progress during point removal
%   The function updates the GUI progress dialog during the removal of the
%   substrate points
%   INPUT:
%       progressdlg: progress dialog handle used with the GUI
%       current: current progress step
%       updateFrac: fraction where progress is updated
%       iterations: the total number of iterations/steps
%   OUTPUT:
%       current: current progress step
%       updateFrac: fraction where progress is updated
%   by Aapo Tervonen, 2021

% increase the current step and get fraction
current = current + 1;
fracTemp = current/iterations;

% check if the fraction is enough for update
if fracTemp >= updateFrac
    
    % check if the user has canceled, if yes, return
    if progressdlg.CancelRequested; current = -1; return; end
    
    % increase the updateFrac
    updateFrac = updateFrac + 0.01;
    
    % set the new dialog progress value
    progressdlg.Value = fracTemp;
end
end