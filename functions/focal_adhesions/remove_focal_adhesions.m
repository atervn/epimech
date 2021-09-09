function d = remove_focal_adhesions(d)
% REMOVE_FOCAL_ADHESIONS Removes focal adhesions based on FA force
%   The function takes in the main simulation data structure d and goes
%   through each cell to check if there are focal adhesions, whose force
%   exceeds the allowed limit. Those exceeding are removed from the cell
%   and substrate data. Finally, the data structure d outputted.
%   by Aapo Tervonen, 2021

% go through the cells
for k = 1:length(d.cells)
    
    % checks that the cell has focal adhesions and that there is force data
    if any(d.cells(k).substrate.connected) && numel(d.cells(k).forces.substrateX)
 
        % find the vertices whose focal adhesions exceed the limit force
        toRemove = (d.cells(k).forces.substrateX(d.cells(k).substrate.connected)).^2 + (d.cells(k).forces.substrateY(d.cells(k).substrate.connected)).^2 >= d.spar.focalAdhesionBreakingForceSq;
        
        % if there are focal adhesions to remove
        if any(toRemove)
            
            toRemove = find(toRemove);
            
            % go through the focal adhesions to remove in reverse order
            % (to not mixup indexing)
            for i = length(toRemove):-1:1

                % get the indices of the adhesion substrate points 
                removedAdhesions = d.cells(k).substrate.points(toRemove(i),:);
                
                % get the column indices for each of the corresponding
                % substrate points in the substrateMatrix used to calculate
                % the focal adhesion force for the substrate
                removedLinkCols = d.cells(k).substrate.linkCols(toRemove(i),:);
                
                % go through the three focal adhesion points
                for i2 = 1:3
                    
                    % go through the cells to update their focal adhesion
                    % data
                    for k2 = 1:length(d.cells)
                        
                        % find if any of that cell's vertices is linked to
                        % the same point
                        sharedPoints = d.cells(k2).substrate.points(:) == removedAdhesions(i2);
                        
                        if any(sharedPoints)
                            
                            % checks if the shared points have higher 
                            % column index in the substrateMatrix than the 
                            % removed vertice had
                            sharedAndHigher = and(sharedPoints,d.cells(k2).substrate.linkCols(:) > removedLinkCols(i2));
                            
                            % update he linkCols and substrateMatrix
                            % indices
                            d.cells(k2).substrate.linkCols(sharedAndHigher) = d.cells(k2).substrate.linkCols(sharedAndHigher) - 1;
                            d.cells(k2).substrate.matrixIdx = sub2ind([d.sub.nPoints 200],d.cells(k2).substrate.points(:),d.cells(k2).substrate.linkCols(:));
                        end
                    end
                end
                
                % reduce the number of connected cell vertices by one for
                % the substrate points that are affected
                d.sub.adhesionNumbers(d.cells(k).substrate.points(toRemove(i),:)) = d.sub.adhesionNumbers(d.cells(k).substrate.points(toRemove(i),:)) - 1;
                
                % remove the focal adhesions from the various matrices and
                % get the new linear indices of the substrateMatrix
                d.cells(k).substrate.points(toRemove(i),:) = [];
                d.cells(k).substrate.linkCols(toRemove(i),:) = [];
                d.cells(k).substrate.matrixIdx = sub2ind([d.sub.nPoints 200],d.cells(k).substrate.points(:),d.cells(k).substrate.linkCols(:));
                d.cells(k).substrate.weights(toRemove(i),:) = [];
                
                % if the substrate is heterogeneous (number of
                % fFocalAdhesions is larger than 0), remove the value
                % corresponding to the removed focal adhesion
                if length(d.cells(k).substrate.fFocalAdhesions) > 1
                    d.cells(k).substrate.fFocalAdhesions(toRemove(i)) = [];
                end
                
                % switch the connection status of the vertex to false
                connectedTemp = find(d.cells(k).substrate.connected);
                d.cells(k).substrate.connected(connectedTemp(toRemove(i))) = false;
                
            end
            
            % get vectors from the points and weights matrices
            d.cells(k).substrate.pointsLin = d.cells(k).substrate.points(:);
            d.cells(k).substrate.weightsLin = d.cells(k).substrate.weights(:);
        end
    end
end

end