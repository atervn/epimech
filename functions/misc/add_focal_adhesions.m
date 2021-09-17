function d = add_focal_adhesions(d, k, longIdx, pos)
% ADD_FOCAL_ADHESIONS Adds new focal adhesions when new vertices are added
%   The function defines new focal adhesions when new vertices are added.
%   It defines the substrate position for the link as the average of the
%   neighboring focal adhesions. New adhesions are created only if both
%   neighboring vertices have focal adhesions. The function takes in the
%   main simulation data structure d, the cell index k, the index of
%   the long section, and the variable pos is 1 (other than the last vertex or
%   2 (last vertex) and outputs the data structure d.
%   by Aapo Tervonen, 2021

% neighboring point focal adhesions states
if pos == 1
    neighboringFAs = d.cells(k).substrate.connected(longIdx:longIdx+1);
else
    neighboringFAs = d.cells(k).substrate.connected([1 end]);
end

% if both of the vertices neighboring the long section have focal adhesions
if all(neighboringFAs)
    
    % find the indices of the these vertices in the connecter vector
    idxTemp = find(find(d.cells(k).substrate.connected) == longIdx);
    if pos == 1
        idxTemp = [idxTemp idxTemp+1];
    else
        idxTemp = [idxTemp 1];
    end
    % get the coordinates of these vertices connection position in the
    % substrate
    vertex1X = sum(d.sub.pointsX(d.cells(k).substrate.points(idxTemp(1),:)).*(d.cells(k).substrate.weights(idxTemp(1),:))');
    vertex1Y = sum(d.sub.pointsY(d.cells(k).substrate.points(idxTemp(1),:)).*(d.cells(k).substrate.weights(idxTemp(1),:))');
    vertex2X = sum(d.sub.pointsX(d.cells(k).substrate.points(idxTemp(2),:)).*(d.cells(k).substrate.weights(idxTemp(2),:))');
    vertex2Y = sum(d.sub.pointsY(d.cells(k).substrate.points(idxTemp(2),:)).*(d.cells(k).substrate.weights(idxTemp(2),:))');
    
    % get the position directly in between these two positions
    newX = 0.5*(vertex1X + vertex2X);
    newY = 0.5*(vertex1Y + vertex2Y);
    
    % find the three closest substrate points for this new position
    [~, focalAdhesionPoints] = mink((newX - d.sub.pointsX).^2 + (newY - d.sub.pointsY).^2,3);
    
    % get their coordinates
    pointXs = reshape(d.sub.pointsX(focalAdhesionPoints),[],3);
    pointYs = reshape(d.sub.pointsY(focalAdhesionPoints),[],3);
    
    % calculate the weights for the substrate points
    W1 = ((pointYs(2) - pointYs(3)).*(newX - pointXs(3)) + (pointXs(3) - pointXs(2)).*(newY - pointYs(3)))./...
        ((pointYs(2) - pointYs(3)).*(pointXs(1) - pointXs(3)) + (pointXs(3) - pointXs(2)).*(pointYs(1) - pointYs(3)));
    W2 = ((pointYs(3) - pointYs(1)).*(newX - pointXs(3)) + (pointXs(1) - pointXs(3)).*(newY - pointYs(3)))./...
        ((pointYs(2) - pointYs(3)).*(pointXs(1) - pointXs(3)) + (pointXs(3) - pointXs(2)).*(pointYs(1) - pointYs(3)));
    W3 = 1 - W1 - W2;
    
    % if all of there values are not NaNs (they new focal adhesion position
    % resides within the triangle defined by the substrate points)
    if all(~isnan([W1 W2 W3]))
        
        % add one to the substrate point's adhesion numbers
        d.sub.adhesionNumbers(focalAdhesionPoints) = d.sub.adhesionNumbers(focalAdhesionPoints) + 1;
        
        % add the substrate point indices, weights, the columns in the
        % substrateMatrix, connected indices to the respective vectors, and
        % get the linearized versions of the points and weights
        if pos == 1
            d.cells(k).substrate.points = [d.cells(k).substrate.points(1:idxTemp(1),:) ; focalAdhesionPoints' ; d.cells(k).substrate.points(idxTemp(2):end,:)];
            d.cells(k).substrate.pointsLin = d.cells(k).substrate.points(:);
            d.cells(k).substrate.weights = [d.cells(k).substrate.weights(1:idxTemp(1),:) ; [W1 W2 W3] ; d.cells(k).substrate.weights(idxTemp(2):end,:)];
            d.cells(k).substrate.weightsLin = d.cells(k).substrate.weights(:);
            d.cells(k).substrate.linkCols = [d.cells(k).substrate.linkCols(1:idxTemp(1),:) ; d.sub.adhesionNumbers(focalAdhesionPoints)' ; d.cells(k).substrate.linkCols(idxTemp(2):end,:) ];
            d.cells(k).substrate.connected = [d.cells(k).substrate.connected(1:idxTemp(1)) ; true ; d.cells(k).substrate.connected(idxTemp(2):end)];
        else
            d.cells(k).substrate.points = [d.cells(k).substrate.points ; focalAdhesionPoints'];
            d.cells(k).substrate.pointsLin = d.cells(k).substrate.points(:);
            d.cells(k).substrate.weights = [d.cells(k).substrate.weights ; [W1 W2 W3]];
            d.cells(k).substrate.weightsLin = d.cells(k).substrate.weights(:);
            d.cells(k).substrate.linkCols = [d.cells(k).substrate.linkCols ; d.sub.adhesionNumbers(focalAdhesionPoints)'];
            d.cells(k).substrate.connected = [d.cells(k).substrate.connected ; true];
        end
        % get the new linear matrix indicies
        d.cells(k).substrate.matrixIdx = sub2ind([d.sub.nPoints 200],d.cells(k).substrate.pointsLin,d.cells(k).substrate.linkCols(:));
        
        % get the connected vertices
        
        
        % if the substrate stiffness is variable and each focal adhesion
        % have their own strength constant, add the mean of the neigboring
        % points as the new value for the new vertex
        if length(d.cells(k).substrate.fFocalAdhesions) > 1
            if pos == 1
                d.cells(k).substrate.fFocalAdhesions = [d.cells(k).substrate.fFocalAdhesions(1:idxTemp(1)) ; 0.5*sum(d.cells(k).substrate.fFocalAdhesions(idxTemp)) ; d.cells(k).substrate.fFocalAdhesions(idxTemp(2):end)];
            else
                d.cells(k).substrate.fFocalAdhesions = [d.cells(k).substrate.fFocalAdhesions ; 0.5*sum(d.cells(k).substrate.fFocalAdhesions(idxTemp))];
            end
        end
    end
    
    % otherwise
else
    
    % no new focal adhesion
    if pos == 1
        d.cells(k).substrate.connected = [d.cells(k).substrate.connected(1:longIdx) ; false ; d.cells(k).substrate.connected(longIdx+1:end)];
    else
        d.cells(k).substrate.connected = [d.cells(k).substrate.connected ; false]; 
    end
end

end
