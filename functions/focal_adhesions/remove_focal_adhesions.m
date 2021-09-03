function d = remove_focal_adhesions(d)

for k = 1:length(d.cells)
    
    if any(d.cells(k).substrate.connected) && numel(d.cells(k).forces.substrateX)

        FAforceMagnitude = (d.cells(k).forces.substrateX(d.cells(k).substrate.connected)).^2 + (d.cells(k).forces.substrateY(d.cells(k).substrate.connected)).^2;
        
        toRemove = FAforceMagnitude >= d.spar.focalAdhesionBreakingForceSq;
        
        if any(toRemove)
            
            toRemove = find(toRemove);
            
            for i = length(toRemove):-1:1

                removedAdhesions = d.cells(k).substrate.points(toRemove(i),:);
                removedLinkCols = d.cells(k).substrate.linkCols(toRemove(i),:);
                
                % for each removed adhesion
                for i2 = 1:3
                    
                    % go through the cells
                    for k2 = 1:length(d.cells)
                        
                        % find if any of that cells vertices is linked with
                        % the same point
                        sharedPoints = d.cells(k2).substrate.points(:) == removedAdhesions(i2);
                        if any(sharedPoints)
                            % checks if the shared points have higher index
                            % in the substrateMatrix than the removed
                            % vertice had
                            sharedAndHigher = and(sharedPoints,d.cells(k2).substrate.linkCols(:) > removedLinkCols(i2));
                            
                            % update he linkCols and substrateMatrix
                            % indices
                            d.cells(k2).substrate.linkCols(sharedAndHigher) = d.cells(k2).substrate.linkCols(sharedAndHigher) - 1;
                            d.cells(k2).substrate.matrixIdx = sub2ind([d.sub.nPoints 200],d.cells(k2).substrate.points(:),d.cells(k2).substrate.linkCols(:));
                        end
                    end
                end
                
                d.sub.adhesionNumbers(d.cells(k).substrate.points(toRemove(i),:)) = d.sub.adhesionNumbers(d.cells(k).substrate.points(toRemove(i),:)) - 1;
                d.cells(k).substrate.points(toRemove(i),:) = [];
                d.cells(k).substrate.linkCols(toRemove(i),:) = [];
                d.cells(k).substrate.matrixIdx = sub2ind([d.sub.nPoints 200],d.cells(k).substrate.points(:),d.cells(k).substrate.linkCols(:));
                d.cells(k).substrate.weights(toRemove(i),:) = [];
                
                connectedTemp = find(d.cells(k).substrate.connected);
                
                if length(d.cells(k).substrate.fFocalAdhesions) > 1
                    d.cells(k).substrate.fFocalAdhesions(toRemove(i)) = [];
                end
                d.cells(k).substrate.connected(connectedTemp(toRemove(i))) = false;
                
            end
            d.cells(k).substrate.pointsLin = d.cells(k).substrate.points(:);
            d.cells(k).substrate.weightsLin = d.cells(k).substrate.weights(:);
        end
    end
    
end

end