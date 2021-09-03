function cells = get_cell_contact_forces(cells,spar,k)

junctionLengthSq = spar.junctionLength.^2;

% initialize the contact force vectors

% zeroVector = zeros(10000,1);

if cells(k).contacts.present
        
    
    forcesCell1X = zeros(cells(k).nVertices,1);
    forcesCell1Y = forcesCell1X;
    forcesCell2X = forcesCell1X;
    forcesCell2Y = forcesCell1X;
    
    temp = cells(k).contacts.cell1;
    
    tooClosePrevIdx = [];
    if temp.prev.present
        prevPairVerticesX = zeros(length(temp.prev.vertices),1);
        prevPairVerticesY = prevPairVerticesX;
        prevPairVectorsX = prevPairVerticesX;
        prevPairVectorsY = prevPairVerticesX;
        prevLengths = prevPairVerticesX;
        for k2 = temp.prev.pairCells
            verticesIdx = temp.prev.pairCellIDs == k2;
            pairIdx = temp.prev.pairVertexIDs(verticesIdx);

            prevPairVerticesX(verticesIdx) = cells(k2).verticesX(pairIdx);
            prevPairVerticesY(verticesIdx) = cells(k2).verticesY(pairIdx);
            prevPairVectorsX(verticesIdx) = cells(k2).leftVectorsX(pairIdx);
            prevPairVectorsY(verticesIdx) = cells(k2).leftVectorsY(pairIdx);
            prevLengths(verticesIdx) = cells(k2).leftLengths(pairIdx);
        end
        
        reciprocalPairLengths = 1./prevLengths;
        
        boundaryUnitVectorsX = prevPairVectorsX.*reciprocalPairLengths;
        boundaryUnitVectorsY = prevPairVectorsY.*reciprocalPairLengths;
        
        pairVectorsX = cells(k).verticesX(temp.prev.vertices) - prevPairVerticesX;
        pairVectorsY = cells(k).verticesY(temp.prev.vertices) - prevPairVerticesY;
        
        perpendicularLengths = abs(boundaryUnitVectorsX.*pairVectorsY - boundaryUnitVectorsY.*pairVectorsX);
        
        reciprocalPerpendicularLengths = 1./perpendicularLengths;
        
        tooClose = perpendicularLengths < spar.junctionLength;
        if any(tooClose)
            tooClosePrevIdx = temp.prev.vertices(tooClose);
            
            forceMagnitudes = spar.fContact.*(perpendicularLengths(tooClose) - junctionLengthSq.*reciprocalPerpendicularLengths(tooClose));
            
            forcesCell1X(tooClosePrevIdx) = forcesCell1X(tooClosePrevIdx) - forceMagnitudes.*boundaryUnitVectorsY(tooClose);
            forcesCell1Y(tooClosePrevIdx) = forcesCell1Y(tooClosePrevIdx) + forceMagnitudes.*boundaryUnitVectorsX(tooClose);
        end
    end
    
    tooCloseNextIdx = [];
    if temp.next.present
        nextPairVerticesX = zeros(length(temp.next.vertices),1);
        nextPairVerticesY = nextPairVerticesX;
        nextPairVectorsX = nextPairVerticesX;
        nextPairVectorsY = nextPairVerticesX;
        nextLengths = nextPairVerticesX;
        for k2 = temp.next.pairCells
            verticesIdx = temp.next.pairCellIDs == k2;
            pairIdx = temp.next.pairVertexIDs(verticesIdx);
            
            nextPairVerticesX(verticesIdx) = cells(k2).verticesX(pairIdx);
            nextPairVerticesY(verticesIdx) = cells(k2).verticesY(pairIdx);
            nextPairVectorsX(verticesIdx) = cells(k2).leftVectorsX(pairIdx);
            nextPairVectorsY(verticesIdx) = cells(k2).leftVectorsY(pairIdx);
            nextLengths(verticesIdx) = cells(k2).leftLengths(pairIdx);
        end
        
        reciprocalPairLengths = 1./nextLengths;
        
        boundaryUnitVectorsX = nextPairVectorsX.*reciprocalPairLengths;
        boundaryUnitVectorsY = nextPairVectorsY.*reciprocalPairLengths;
        
        pairVectorsX = cells(k).verticesX(temp.next.vertices) - nextPairVerticesX;
        pairVectorsY = cells(k).verticesY(temp.next.vertices) - nextPairVerticesY;
        
        perpendicularLengths = abs(boundaryUnitVectorsX.*pairVectorsY - boundaryUnitVectorsY.*pairVectorsX);
        
        reciprocalPerpendicularLengths = 1./perpendicularLengths;
        
        tooClose = perpendicularLengths < spar.junctionLength;
        if any(tooClose)
            tooCloseNextIdx = temp.next.vertices(tooClose);
            
            forceMagnitudes = spar.fContact.*(perpendicularLengths(tooClose) - junctionLengthSq.*reciprocalPerpendicularLengths(tooClose));
            
            forcesCell1X(tooCloseNextIdx) = forcesCell1X(tooCloseNextIdx) - forceMagnitudes.*boundaryUnitVectorsY(tooClose);
            forcesCell1Y(tooCloseNextIdx) = forcesCell1Y(tooCloseNextIdx) + forceMagnitudes.*boundaryUnitVectorsX(tooClose);
        end
    end
    
    if temp.vertex.present
        vertexPairVerticesX = zeros(length(temp.vertex.vertices),1);
        vertexPairVerticesY = vertexPairVerticesX;
        for k2 = temp.vertex.pairCells
           
            verticesIdx = temp.vertex.pairCellIDs == k2;
            pairIdx = temp.vertex.pairVertexIDs(verticesIdx);
            
            vertexPairVerticesX(verticesIdx) = cells(k2).verticesX(pairIdx);
            vertexPairVerticesY(verticesIdx) = cells(k2).verticesY(pairIdx);
        end
        
        vectorsX = vertexPairVerticesX - cells(k).verticesX(temp.vertex.vertices);
        vectorsY = vertexPairVerticesY - cells(k).verticesY(temp.vertex.vertices);
        
        % calculate the vector lengths
        vectorLengths = sqrt(vectorsX.^2 + vectorsY.^2);
        
        tooClose = vectorLengths < spar.junctionLength;
        
        if any(tooClose)
            
            vectorLengths = vectorLengths(tooClose);
            
            % get the reciprocal vector lengths
            reciprocalVectors = 1./vectorLengths;

            tooCloseIdx = temp.vertex.vertices(tooClose);
            
            forceMagnitudes = spar.fContact.*(vectorLengths - junctionLengthSq.*reciprocalVectors).*reciprocalVectors;
            
            forcesCell1X(tooCloseIdx) = forcesCell1X(tooCloseIdx) + forceMagnitudes.*vectorsX(tooClose);
            forcesCell1Y(tooCloseIdx) = forcesCell1Y(tooCloseIdx) + forceMagnitudes.*vectorsY(tooClose);
        end
        
    end
    

    if ~isempty(tooClosePrevIdx)&&~isempty(tooCloseNextIdx)
        P = zeros(1, max(max(tooClosePrevIdx),max(tooCloseNextIdx)) ) ;
        P(tooClosePrevIdx) = 1;
        bothCell1 = tooCloseNextIdx(logical(P(tooCloseNextIdx)));
    else
        bothCell1 = [];
    end
    if numel(bothCell1) > 0
        forcesCell1X(bothCell1) = forcesCell1X(bothCell1)./2;
        forcesCell1Y(bothCell1) = forcesCell1Y(bothCell1)./2;
    end
    
    
    
    temp = cells(k).contacts.cell2;
    tooClosePrevIdx = [];
    if temp.prev.present
        prevPairVerticesX = zeros(length(temp.prev.vertices),1);
        prevPairVerticesY = prevPairVerticesX;
        prevPairVectorsX = prevPairVerticesX;
        prevPairVectorsY = prevPairVerticesX;
        prevLengths = prevPairVerticesX;
        for k2 = temp.prev.pairCells
            verticesIdx = temp.prev.pairCellIDs == k2;
            pairIdx = temp.prev.pairVertexIDs(verticesIdx);
            
            prevPairVerticesX(verticesIdx) = cells(k2).verticesX(pairIdx);
            prevPairVerticesY(verticesIdx) = cells(k2).verticesY(pairIdx);
            prevPairVectorsX(verticesIdx) = cells(k2).leftVectorsX(pairIdx);
            prevPairVectorsY(verticesIdx) = cells(k2).leftVectorsY(pairIdx);
            prevLengths(verticesIdx) = cells(k2).leftLengths(pairIdx);
        end
        
        reciprocalPairLengths = 1./prevLengths;
        
        boundaryUnitVectorsX = prevPairVectorsX.*reciprocalPairLengths;
        boundaryUnitVectorsY = prevPairVectorsY.*reciprocalPairLengths;
        
        pairVectorsX = cells(k).verticesX(temp.prev.vertices) - prevPairVerticesX;
        pairVectorsY = cells(k).verticesY(temp.prev.vertices) - prevPairVerticesY;
        
        perpendicularLengths = abs(boundaryUnitVectorsX.*pairVectorsY - boundaryUnitVectorsY.*pairVectorsX);
        
        reciprocalPerpendicularLengths = 1./perpendicularLengths;
        
        tooClose = perpendicularLengths < spar.junctionLength;
        if any(tooClose)
            tooClosePrevIdx = temp.prev.vertices(tooClose);
            
            forceMagnitudes = spar.fContact.*(perpendicularLengths(tooClose) - junctionLengthSq.*reciprocalPerpendicularLengths(tooClose));
            
            forcesCell2X(tooClosePrevIdx) = forcesCell2X(tooClosePrevIdx) - forceMagnitudes.*boundaryUnitVectorsY(tooClose);
            forcesCell2Y(tooClosePrevIdx) = forcesCell2Y(tooClosePrevIdx) + forceMagnitudes.*boundaryUnitVectorsX(tooClose);
        end
    end

    tooCloseNextIdx = [];
    if temp.next.present
        nextPairVerticesX = zeros(length(temp.next.vertices),1);
        nextPairVerticesY = nextPairVerticesX;
        nextPairVectorsX = nextPairVerticesX;
        nextPairVectorsY = nextPairVerticesX;
        nextLengths = nextPairVerticesX;
        for k2 = temp.next.pairCells
            verticesIdx = temp.next.pairCellIDs == k2;
            pairIdx = temp.next.pairVertexIDs(verticesIdx);
            
            nextPairVerticesX(verticesIdx) = cells(k2).verticesX(pairIdx);
            nextPairVerticesY(verticesIdx) = cells(k2).verticesY(pairIdx);
            nextPairVectorsX(verticesIdx) = cells(k2).leftVectorsX(pairIdx);
            nextPairVectorsY(verticesIdx) = cells(k2).leftVectorsY(pairIdx);
            nextLengths(verticesIdx) = cells(k2).leftLengths(pairIdx);
        end
        
        reciprocalPairLengths = 1./nextLengths;
        
        boundaryUnitVectorsX = nextPairVectorsX.*reciprocalPairLengths;
        boundaryUnitVectorsY = nextPairVectorsY.*reciprocalPairLengths;
        
        pairVectorsX = cells(k).verticesX(temp.next.vertices) - nextPairVerticesX;
        pairVectorsY = cells(k).verticesY(temp.next.vertices) - nextPairVerticesY;
        
        perpendicularLengths = abs(boundaryUnitVectorsX.*pairVectorsY - boundaryUnitVectorsY.*pairVectorsX);
        
        reciprocalPerpendicularLengths = 1./perpendicularLengths;
        
        tooClose = perpendicularLengths < spar.junctionLength;
        if any(tooClose)
            tooCloseNextIdx = temp.next.vertices(tooClose);
            
            forceMagnitudes = spar.fContact.*(perpendicularLengths(tooClose) - junctionLengthSq.*reciprocalPerpendicularLengths(tooClose));
            
            forcesCell2X(tooCloseNextIdx) = forcesCell2X(tooCloseNextIdx) - forceMagnitudes.*boundaryUnitVectorsY(tooClose);
            forcesCell2Y(tooCloseNextIdx) = forcesCell2Y(tooCloseNextIdx) + forceMagnitudes.*boundaryUnitVectorsX(tooClose);
        end
    end
    
    if temp.vertex.present
        vertexPairVerticesX = zeros(length(temp.vertex.vertices),1);
        vertexPairVerticesY = vertexPairVerticesX;
        for k2 = temp.vertex.pairCells
            verticesIdx = temp.vertex.pairCellIDs == k2;
            pairIdx = temp.vertex.pairVertexIDs(verticesIdx);
            
            vertexPairVerticesX(verticesIdx) = cells(k2).verticesX(pairIdx);
            vertexPairVerticesY(verticesIdx) = cells(k2).verticesY(pairIdx);
        end
        
        vectorsX = vertexPairVerticesX - cells(k).verticesX(temp.vertex.vertices);
        vectorsY = vertexPairVerticesY - cells(k).verticesY(temp.vertex.vertices);
        
        % calculate the vector lengths
        vectorLengths = sqrt(vectorsX.^2 + vectorsY.^2);
        
        tooClose = vectorLengths < spar.junctionLength;
        
        if any(tooClose)
            
            vectorLengths = vectorLengths(tooClose);
            
            % get the reciprocal vector lengths
            reciprocalVectors = 1./vectorLengths;

            tooCloseIdx = temp.vertex.vertices(tooClose);
            
            forceMagnitudes = spar.fContact.*(vectorLengths - junctionLengthSq.*reciprocalVectors).*reciprocalVectors;
            
            forcesCell2X(tooCloseIdx) = forcesCell2X(tooCloseIdx) + forceMagnitudes.*vectorsX(tooClose);
            forcesCell2Y(tooCloseIdx) = forcesCell2Y(tooCloseIdx) + forceMagnitudes.*vectorsY(tooClose);
        end
        
    end
    
     if ~isempty(tooClosePrevIdx)&&~isempty(tooCloseNextIdx)
        P = zeros(1, max(max(tooClosePrevIdx),max(tooCloseNextIdx)) ) ;
        P(tooClosePrevIdx) = 1;
        bothCell2 = tooCloseNextIdx(logical(P(tooCloseNextIdx)));
    else
        bothCell2 = [];
    end
    if numel(bothCell2) > 0
        forcesCell2X(bothCell2) = forcesCell2X(bothCell2)./2;
        forcesCell2Y(bothCell2) = forcesCell2Y(bothCell2)./2;
    end
    
    cells(k).forces.contactX = forcesCell1X + forcesCell2X;
    cells(k).forces.contactY = forcesCell1Y + forcesCell2Y;
    
    if ~isempty(bothCell1)&&~isempty(bothCell2)
        P = zeros(1, max(max(bothCell1),max(bothCell2)) ) ;
        P(tooClosePrevIdx) = 1;
        both = bothCell2(logical(P(bothCell2)));
    else
        both = [];
    end
    if numel(bothCell2) > 0
        cells(k).forces.contactX(both) = cells(k).forces.contactX(both)./2;
        cells(k).forces.contactY(both) = cells(k).forces.contactY(both)./2;
    end
    
   
else
    cells(k).forces.contactX = zeros(cells(k).nVertices,1);
    cells(k).forces.contactY = zeros(cells(k).nVertices,1);
end



if cells(k).division.state == 2
    
    forcesX = zeros(cells(k).nVertices,1);
    forcesY = forcesX;

    temp = cells(k).contacts.division;
    
    tooClosePrevIdx = [];
    if temp.prev.present
        
        prevPairVerticesX = cells(k).verticesX(temp.prev.pairIDs);
        prevPairVerticesY = cells(k).verticesY(temp.prev.pairIDs);
        prevPairVectorsX = cells(k).leftVectorsX(temp.prev.pairIDs);
        prevPairVectorsY = cells(k).leftVectorsY(temp.prev.pairIDs);
        prevLengths = cells(k).leftLengths(temp.prev.pairIDs);
        
        reciprocalPairLengths = 1./prevLengths;
        
        boundaryUnitVectorsX = prevPairVectorsX.*reciprocalPairLengths;
        boundaryUnitVectorsY = prevPairVectorsY.*reciprocalPairLengths;
        
        pairVectorsX = cells(k).verticesX(temp.prev.vertices) - prevPairVerticesX;
        pairVectorsY = cells(k).verticesY(temp.prev.vertices) - prevPairVerticesY;
        
        perpendicularLengths = abs(boundaryUnitVectorsX.*pairVectorsY - boundaryUnitVectorsY.*pairVectorsX);
        
        reciprocalPerpendicularLengths = 1./perpendicularLengths;
        
        tooClose = perpendicularLengths < spar.junctionLength;
        if any(tooClose)
            tooClosePrevIdx = temp.prev.vertices(tooClose);
            
            forceMagnitudes = spar.fContact.*(perpendicularLengths(tooClose) - junctionLengthSq.*reciprocalPerpendicularLengths(tooClose));
            
            forcesX(tooClosePrevIdx) = forcesX(tooClosePrevIdx) - forceMagnitudes.*boundaryUnitVectorsY(tooClose);
            forcesY(tooClosePrevIdx) = forcesY(tooClosePrevIdx) + forceMagnitudes.*boundaryUnitVectorsX(tooClose);
        end
    end
    
    tooCloseNextIdx = [];
    if temp.next.present
        nextPairVerticesX = cells(k).verticesX(temp.next.pairIDs);
        nextPairVerticesY = cells(k).verticesY(temp.next.pairIDs);
        nextPairVectorsX = cells(k).leftVectorsX(temp.next.pairIDs);
        nextPairVectorsY = cells(k).leftVectorsY(temp.next.pairIDs);
        nextLengths = cells(k).leftLengths(temp.next.pairIDs);

        reciprocalPairLengths = 1./nextLengths;
        
        boundaryUnitVectorsX = nextPairVectorsX.*reciprocalPairLengths;
        boundaryUnitVectorsY = nextPairVectorsY.*reciprocalPairLengths;
        
        pairVectorsX = cells(k).verticesX(temp.next.vertices) - nextPairVerticesX;
        pairVectorsY = cells(k).verticesY(temp.next.vertices) - nextPairVerticesY;
        
        perpendicularLengths = abs(boundaryUnitVectorsX.*pairVectorsY - boundaryUnitVectorsY.*pairVectorsX);
        
        reciprocalPerpendicularLengths = 1./perpendicularLengths;
        
        tooClose = perpendicularLengths < spar.junctionLength;
        if any(tooClose)
            tooCloseNextIdx = temp.next.vertices(tooClose);
            
            forceMagnitudes = spar.fContact.*(perpendicularLengths(tooClose) - junctionLengthSq.*reciprocalPerpendicularLengths(tooClose));
            
            forcesX(tooCloseNextIdx) = forcesX(tooCloseNextIdx) - forceMagnitudes.*boundaryUnitVectorsY(tooClose);
            forcesY(tooCloseNextIdx) = forcesY(tooCloseNextIdx) + forceMagnitudes.*boundaryUnitVectorsX(tooClose);
        end
    end
    
    if temp.vertex.present

        vectorsX = cells(k).verticesX(temp.vertex.pairIDs) - cells(k).verticesX(temp.vertex.vertices);
        vectorsY = cells(k).verticesY(temp.vertex.pairIDs) - cells(k).verticesY(temp.vertex.vertices);
        
        % calculate the vector lengths
        vectorLengths = sqrt(vectorsX.^2 + vectorsY.^2);
        
        tooClose = vectorLengths < spar.junctionLength;
        
        if any(tooClose)
            
            vectorLengths = vectorLengths(tooClose);
            
            % get the reciprocal vector lengths
            reciprocalVectors = 1./vectorLengths;

            tooCloseIdx = temp.vertex.vertices(tooClose);
            
            forceMagnitudes = spar.fContact.*(vectorLengths - junctionLengthSq.*reciprocalVectors).*reciprocalVectors;
            
            forcesX(tooCloseIdx) = forcesX(tooCloseIdx) + forceMagnitudes.*vectorsX(tooClose);
            forcesY(tooCloseIdx) = forcesY(tooCloseIdx) + forceMagnitudes.*vectorsY(tooClose);
        end
        
    end
    

    if ~isempty(tooClosePrevIdx)&&~isempty(tooCloseNextIdx)
        P = zeros(1, max(max(tooClosePrevIdx),max(tooCloseNextIdx)) ) ;
        P(tooClosePrevIdx) = 1;
        bothInteractions = tooCloseNextIdx(logical(P(tooCloseNextIdx)));
    else
        bothInteractions = [];
    end
    if numel(bothInteractions) > 0
        forcesX(bothInteractions) = forcesX(bothInteractions)./2;
        forcesY(bothInteractions) = forcesY(bothInteractions)./2;
    end
    
    cells(k).forces.contactX = cells(k).forces.contactX + forcesX;
    cells(k).forces.contactY = cells(k).forces.contactY + forcesY;
  
end

end