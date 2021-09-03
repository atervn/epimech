function d = add_vertices(d)

longLengths = 1;
verticesAdded = zeros(size(d.cells));
while longLengths ~= 0
    
    longLengths = size(d.cells,2);    
    
% go through the d.cells
for k = 1:length(d.cells)

    % finds the indices of the sections that have two times the normal
    % section length
    longIdx = find(d.cells(k).leftLengths >= 2*d.spar.membraneLength);
    
    if isempty(longIdx)
        longLengths = longLengths - 1;
    
    else
        verticesAdded(k) = 1;
        % goes through the too long sections, if no, skips this step
        for i = 1:size(longIdx,1)
            
            % the case when too long section is the last one is dealt separately
             if longIdx(i) < d.cells(k).nVertices
                
                % creates a new vertex to the midway between the two vertices with
                % too long section
                newVertexX = (d.cells(k).verticesX(longIdx(i)) + d.cells(k).verticesX(longIdx(i)+1))/2;
                newVertexY = (d.cells(k).verticesY(longIdx(i)) + d.cells(k).verticesY(longIdx(i)+1))/2;
                
                % add the new vertex into the boundaryVertices matrix
                d.cells(k).verticesX = [d.cells(k).verticesX(1:longIdx(i)) ; newVertexX ; d.cells(k).verticesX(longIdx(i)+1:end)];
                d.cells(k).verticesY = [d.cells(k).verticesY(1:longIdx(i)) ; newVertexY ; d.cells(k).verticesY(longIdx(i)+1:end)];
                
                % add the new vertex into the vertexStates vector
                d.cells(k).vertexStates = [d.cells(k).vertexStates(1:longIdx(i)) ; 0 ; d.cells(k).vertexStates(longIdx(i)+1:end)];
                              
                % update the divisionVertices vector
                d.cells(k).division.vertices = d.cells(k).division.vertices + 1.*(d.cells(k).division.vertices > longIdx(i));
                
                % add the new vertex into the junctions matrix
                d.cells(k).junctions.cells = [d.cells(k).junctions.cells(1:longIdx(i),:) ; [0 0] ; d.cells(k).junctions.cells(longIdx(i)+1:end,:)];
                d.cells(k).junctions.vertices = [d.cells(k).junctions.vertices(1:longIdx(i),:) ; [0 0] ; d.cells(k).junctions.vertices(longIdx(i)+1:end,:)];
                              
                originals = d.cells(k).vertexCorticalTensions;
                if longIdx(i) == 1
                    d.cells(k).vertexCorticalTensions(1) = (originals(end) + originals(1))./2;
                    d.cells(k).vertexCorticalTensions = [d.cells(k).vertexCorticalTensions(1) ; (originals(end) + originals(1))./2 ; d.cells(k).vertexCorticalTensions(2:end)];
                else
                    d.cells(k).vertexCorticalTensions(longIdx(i)) = (originals(longIdx(i)-1) + originals(longIdx(i)))./2;
                    d.cells(k).vertexCorticalTensions = [d.cells(k).vertexCorticalTensions(1:longIdx(i)) ; (originals(longIdx(i)-1) + originals(longIdx(i)))./2 ; d.cells(k).vertexCorticalTensions(longIdx(i)+1:end)];
                end
                        
                if d.simset.simulationType == 5
                    if any(d.simset.opto.cells == k)
                        longVertex = longIdx(i);
                        cellIdx = d.simset.opto.cells == k;
                        d.simset.opto.vertices{cellIdx}(d.simset.opto.vertices{cellIdx} > longVertex) = d.simset.opto.vertices{cellIdx}(d.simset.opto.vertices{cellIdx} > longVertex) + 1;
                        
                        if any(d.simset.opto.vertices{cellIdx} == longVertex) || any(d.simset.opto.vertices{cellIdx} == longVertex + 2)
                            d.simset.opto.vertices{cellIdx} = sort([d.simset.opto.vertices{cellIdx} ; longVertex + 1]);
                        end
                        
                    end
                end
                
                %% Add new focal adhesions
                
                if any(d.simset.simulationType == [3,5])
                    if all(d.cells(k).substrate.connected(longIdx(i):longIdx(i)+1))
                        
                        idxTemp = find(find(d.cells(k).substrate.connected) == longIdx(i));
                        idxTemp = [idxTemp idxTemp+1]; %#ok<AGROW>
                        
                       vertex1X = sum(d.sub.pointsX(d.cells(k).substrate.points(idxTemp(1),:)).*(d.cells(k).substrate.weights(idxTemp(1),:))');
                       vertex1Y = sum(d.sub.pointsY(d.cells(k).substrate.points(idxTemp(1),:)).*(d.cells(k).substrate.weights(idxTemp(1),:))');
                       vertex2X = sum(d.sub.pointsX(d.cells(k).substrate.points(idxTemp(2),:)).*(d.cells(k).substrate.weights(idxTemp(2),:))');
                       vertex2Y = sum(d.sub.pointsY(d.cells(k).substrate.points(idxTemp(2),:)).*(d.cells(k).substrate.weights(idxTemp(2),:))');
                       
                       newX = 0.5*(vertex1X + vertex2X);
                       newY = 0.5*(vertex1Y + vertex2Y);

                       [~, focalAdhesionPoints] = mink((newX - d.sub.pointsX).^2 + (newY - d.sub.pointsY).^2,3);
                       
                       pointXs = reshape(d.sub.pointsX(focalAdhesionPoints),[],3);
                       pointYs = reshape(d.sub.pointsY(focalAdhesionPoints),[],3);
                                             
                       W1 = ((pointYs(2) - pointYs(3)).*(newX - pointXs(3)) + (pointXs(3) - pointXs(2)).*(newY - pointYs(3)))./...
                           ((pointYs(2) - pointYs(3)).*(pointXs(1) - pointXs(3)) + (pointXs(3) - pointXs(2)).*(pointYs(1) - pointYs(3)));
                       W2 = ((pointYs(3) - pointYs(1)).*(newX - pointXs(3)) + (pointXs(1) - pointXs(3)).*(newY - pointYs(3)))./...
                           ((pointYs(2) - pointYs(3)).*(pointXs(1) - pointXs(3)) + (pointXs(3) - pointXs(2)).*(pointYs(1) - pointYs(3)));
                       W3 = 1 - W1 - W2;
                       
                       if all(~isnan([W1 W2 W3]))
                           
                           d.sub.adhesionNumbers(focalAdhesionPoints) = d.sub.adhesionNumbers(focalAdhesionPoints) + 1;
                           adhesionLinkCols = d.sub.adhesionNumbers(focalAdhesionPoints)';
                           
                           
                           d.cells(k).substrate.points = [d.cells(k).substrate.points(1:idxTemp(1),:) ; focalAdhesionPoints' ; d.cells(k).substrate.points(idxTemp(2):end,:)];
                           d.cells(k).substrate.pointsLin = d.cells(k).substrate.points(:);
                           d.cells(k).substrate.weights = [d.cells(k).substrate.weights(1:idxTemp(1),:) ; [W1 W2 W3] ; d.cells(k).substrate.weights(idxTemp(2):end,:)];
                           d.cells(k).substrate.weightsLin = d.cells(k).substrate.weights(:);
                           d.cells(k).substrate.linkCols = [d.cells(k).substrate.linkCols(1:idxTemp(1),:) ; adhesionLinkCols ; d.cells(k).substrate.linkCols(idxTemp(2):end,:) ];
                           d.cells(k).substrate.matrixIdx = sub2ind([d.sub.nPoints 200],d.cells(k).substrate.pointsLin,d.cells(k).substrate.linkCols(:));
                           d.cells(k).substrate.connected = [d.cells(k).substrate.connected(1:idxTemp(1)) ; true ; d.cells(k).substrate.connected(idxTemp(2):end)];
                           
                           if length(d.cells(k).substrate.fFocalAdhesions) > 1
                               meanFA = 0.5*sum(d.cells(k).substrate.fFocalAdhesions(idxTemp));
                               
                               d.cells(k).substrate.fFocalAdhesions = [d.cells(k).substrate.fFocalAdhesions(1:idxTemp(1)) ; meanFA ; d.cells(k).substrate.fFocalAdhesions(idxTemp(2):end)];
                           end
                       end
                    else
                        d.cells(k).substrate.connected = [d.cells(k).substrate.connected(1:longIdx(i)) ; false ; d.cells(k).substrate.connected(longIdx(i)+1:end)];
                    end
                    
                    if d.cells(k).cellState == 0
                        d.cells(k).edgeVertices(d.cells(k).edgeVertices > longIdx(i)) = d.cells(k).edgeVertices(d.cells(k).edgeVertices > longIdx(i)) + 1;
                        
                        if any(d.cells(k).edgeVertices == longIdx(i)) && any(d.cells(k).edgeVertices == longIdx(i)+1)
                            
                            prevIdx = d.cells(k).edgeVertices == longIdx(i);
                            nextIdx = d.cells(k).edgeVertices == longIdx(i)+1;
                            
                            d.cells(k).edgeVertices = [d.cells(k).edgeVertices ; longIdx(i)+1];
                            
                            d.cells(k).edgeInitialX = [d.cells(k).edgeInitialX ; 0.5*(d.cells(k).edgeInitialX(prevIdx) + d.cells(k).edgeInitialX(nextIdx))];
                            d.cells(k).edgeInitialY = [d.cells(k).edgeInitialY ; 0.5*(d.cells(k).edgeInitialY(prevIdx) + d.cells(k).edgeInitialY(nextIdx))];
                            
                        end
                    end
                end

            else
                
                % creates a new vertex to the midway between the two vertices with
                % too long section
                newVertexX = (d.cells(k).verticesX(end) + d.cells(k).verticesX(1))/2;
                newVertexY = (d.cells(k).verticesY(end) + d.cells(k).verticesY(1))/2;
                
                % add the new vertex into the boundaryVertices matrix
                d.cells(k).verticesX = [d.cells(k).verticesX ; newVertexX];
                d.cells(k).verticesY = [d.cells(k).verticesY ; newVertexY];
                
                % add the new vertex into the vertexStates vector
                d.cells(k).vertexStates = [d.cells(k).vertexStates ; 0];
                
                % add the new vertex into the junctions matrix
                d.cells(k).junctions.cells = [d.cells(k).junctions.cells ; [0 0]];
                d.cells(k).junctions.vertices = [d.cells(k).junctions.vertices ; [0 0]];
                
                originals = d.cells(k).vertexCorticalTensions;
                d.cells(k).vertexCorticalTensions(end) = (originals(end-1) + originals(end))./2;
                d.cells(k).vertexCorticalTensions = [d.cells(k).vertexCorticalTensions ; (originals(end-1) + originals(end))./2;];
                
                if any(d.simset.simulationType == [3,5])
                    if all(d.cells(k).substrate.connected([1 end]))
                        
                        idxTemp = find(find(d.cells(k).substrate.connected) == longIdx(i));
                        idxTemp = [idxTemp 1]; %#ok<AGROW>
                        
                        vertex1X = sum(d.sub.pointsX(d.cells(k).substrate.points(idxTemp(1),:)).*(d.cells(k).substrate.weights(idxTemp(1),:))');
                        vertex1Y = sum(d.sub.pointsY(d.cells(k).substrate.points(idxTemp(1),:)).*(d.cells(k).substrate.weights(idxTemp(1),:))');
                        vertex2X = sum(d.sub.pointsX(d.cells(k).substrate.points(idxTemp(2),:)).*(d.cells(k).substrate.weights(idxTemp(2),:))');
                        vertex2Y = sum(d.sub.pointsY(d.cells(k).substrate.points(idxTemp(2),:)).*(d.cells(k).substrate.weights(idxTemp(2),:))');
                        
                        newX = 0.5*(vertex1X + vertex2X);
                        newY = 0.5*(vertex1Y + vertex2Y);
                        
                        [~, focalAdhesionPoints] = mink((newX - d.sub.pointsX).^2 + (newY - d.sub.pointsY).^2,3);
                        
                        pointXs = reshape(d.sub.pointsX(focalAdhesionPoints),[],3);
                        pointYs = reshape(d.sub.pointsY(focalAdhesionPoints),[],3);
                        
                        W1 = ((pointYs(2) - pointYs(3)).*(newX - pointXs(3)) + (pointXs(3) - pointXs(2)).*(newY - pointYs(3)))./...
                            ((pointYs(2) - pointYs(3)).*(pointXs(1) - pointXs(3)) + (pointXs(3) - pointXs(2)).*(pointYs(1) - pointYs(3)));
                        W2 = ((pointYs(3) - pointYs(1)).*(newX - pointXs(3)) + (pointXs(1) - pointXs(3)).*(newY - pointYs(3)))./...
                            ((pointYs(2) - pointYs(3)).*(pointXs(1) - pointXs(3)) + (pointXs(3) - pointXs(2)).*(pointYs(1) - pointYs(3)));
                        W3 = 1 - W1 - W2;
                        
                        if all(~isnan([W1 W2 W3]))
                            
                            d.sub.adhesionNumbers(focalAdhesionPoints) = d.sub.adhesionNumbers(focalAdhesionPoints) + 1;
                            adhesionLinkCols = d.sub.adhesionNumbers(focalAdhesionPoints)';
                            
                            
                            d.cells(k).substrate.points = [d.cells(k).substrate.points ; focalAdhesionPoints'];
                            d.cells(k).substrate.pointsLin = d.cells(k).substrate.points(:);
                            d.cells(k).substrate.weights = [d.cells(k).substrate.weights ; [W1 W2 W3]];
                            d.cells(k).substrate.weightsLin = d.cells(k).substrate.weights(:);
                            d.cells(k).substrate.linkCols = [d.cells(k).substrate.linkCols ; adhesionLinkCols];
                            d.cells(k).substrate.matrixIdx = sub2ind([d.sub.nPoints 200],d.cells(k).substrate.pointsLin,d.cells(k).substrate.linkCols(:));
                            d.cells(k).substrate.connected = [d.cells(k).substrate.connected ; true];
                            
                            if length(d.cells(k).substrate.fFocalAdhesions) > 1
                                meanFA = 0.5*sum(d.cells(k).substrate.fFocalAdhesions(idxTemp));
                                
                                d.cells(k).substrate.fFocalAdhesions = [d.cells(k).substrate.fFocalAdhesions ; meanFA];
                            end
                        end
                    else
                       d.cells(k).substrate.connected = [d.cells(k).substrate.connected ; false]; 
                    end
                    
                    
                    d.cells(k).edgeVertices(d.cells(k).edgeVertices > longIdx(i)) = d.cells(k).edgeVertices(d.cells(k).edgeVertices > longIdx(i)) + 1;
                    
                    if any(d.cells(k).edgeVertices == longIdx(i)) && any(d.cells(k).edgeVertices == longIdx(i)+2)
                        d.cells(k).edgeVertices = [d.cells(k).edgeVertices longIdx(i)+1];
                        
                        d.cells(k).edgeInitialX = [d.cells(k).edgeInitialX 0.5*(d.cells(k).edgeInitialX(longIdx(i)) + d.cells(k).edgeInitialX(longIdx(i)+2))];
                        d.cells(k).edgeInitialY = [d.cells(k).edgeInitialY 0.5*(d.cells(k).edgeInitialY(longIdx(i)) + d.cells(k).edgeInitialY(longIdx(i)+2))];
                        
                    end
                    
                    if d.cells(k).cellState == 0
                        if any(d.cells(k).edgeVertices == longIdx(i)) && any(d.cells(k).edgeVertices == 1)
                            
                            prevIdx = d.cells(k).edgeVertices == longIdx(i);
                            nextIdx = d.cells(k).edgeVertices == 1;
                            
                            d.cells(k).edgeVertices = [d.cells(k).edgeVertices ; longIdx(i)+1];
                            
                            d.cells(k).edgeInitialX = [d.cells(k).edgeInitialX ; 0.5*(d.cells(k).edgeInitialX(prevIdx) + d.cells(k).edgeInitialX(nextIdx))];
                            d.cells(k).edgeInitialY = [d.cells(k).edgeInitialY ; 0.5*(d.cells(k).edgeInitialY(prevIdx) + d.cells(k).edgeInitialY(nextIdx))];
                        end
                    end
                    
                end

            end
            
            % increase the indices of the following too long sections as a
            % vertex was added into the cell
            
            d.cells(k).nVertices = d.cells(k).nVertices + 1;
            
            d.cells(k).junctions.linkedIdx1 = find(d.cells(k).vertexStates > 0);
            d.cells(k).junctions.linkedIdx2 = find(d.cells(k).vertexStates == 2);
            
            junctions2UpdateIdx = d.cells(k).junctions.linkedIdx1;
            
            junctions2UpdateIdx(junctions2UpdateIdx <= longIdx(i)) = [];
            
            if numel(junctions2UpdateIdx) > 0
                for j = junctions2UpdateIdx'
                    
                    % temporary index
                    cellid = d.cells(k).junctions.cells(j,1);
                    vertexid = d.cells(k).junctions.vertices(j,1);
                    
                    whichJunction = find(d.cells(cellid).junctions.cells(vertexid,:) == k);
                    
                    % update the junction pairs
                    d.cells(cellid).junctions.vertices(vertexid,whichJunction) = d.cells(cellid).junctions.vertices(vertexid,whichJunction) + 1;
                    
                    if ~d.simset.junctionModification
                        if whichJunction == 1
                            tempIdx2 = d.cells(cellid).junctions.linkedIdx1 == vertexid;
                            d.cells(cellid).junctions.pairVertices1(tempIdx2) = d.cells(cellid).junctions.pairVertices1(tempIdx2) + 1;
                        else
                            tempIdx2 = d.cells(cellid).junctions.linkedIdx2 == vertexid;
                            d.cells(cellid).junctions.pairVertices2(tempIdx2) = d.cells(cellid).junctions.pairVertices2(tempIdx2) + 1;
                        end
                    end
                    
                end
            end
            
            junctions2UpdateIdx = d.cells(k).junctions.linkedIdx2;
            
            junctions2UpdateIdx(junctions2UpdateIdx <= longIdx(i)) = [];
            
            
            if numel(junctions2UpdateIdx) > 0
                for j = junctions2UpdateIdx'
                    
                    % temporary index
                    cellid = d.cells(k).junctions.cells(j,2);
                    vertexid = d.cells(k).junctions.vertices(j,2);
                    
                    whichJunction = find(d.cells(cellid).junctions.cells(vertexid,:) == k);
                    
                    % update the junction pairs
                    d.cells(cellid).junctions.vertices(vertexid,whichJunction) = d.cells(cellid).junctions.vertices(vertexid,whichJunction) + 1;
                    
                    if ~d.simset.junctionModification
                        if whichJunction == 1
                            tempIdx2 = d.cells(cellid).junctions.linkedIdx1 == vertexid;
                            d.cells(cellid).junctions.pairVertices1(tempIdx2) = d.cells(cellid).junctions.pairVertices1(tempIdx2) + 1;
                        else
                            tempIdx2 = d.cells(cellid).junctions.linkedIdx2 == vertexid;
                            d.cells(cellid).junctions.pairVertices2(tempIdx2) = d.cells(cellid).junctions.pairVertices2(tempIdx2) + 1;
                        end
                    end
                    
                end
            end
            
            longIdx = longIdx + 1;
        end
        d.cells(k) = get_boundary_vectors(d.cells(k));
        d.cells(k) = get_boundary_lengths(d.cells(k));
    end
end
 
end

for k = find(verticesAdded)
   
    d.cells(k) = get_convexities(d.cells(k));
    d.cells(k) = get_vertex_angles(d.cells(k));
end

end