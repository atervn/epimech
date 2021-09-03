function [d,subDt] = solve_substrate(d,cellDt,subDt)

time = 0;

if subDt > cellDt
   subDt = cellDt; 
end

while time < cellDt
    
    subTemp.selvesX = d.sub.pointsX(d.sub.interactionSelvesIdx);
    subTemp.selvesY = d.sub.pointsY(d.sub.interactionSelvesIdx);
    
    subTemp.pairsX = d.sub.pointsX(d.sub.interactionPairsIdx);
    subTemp.pairsY = d.sub.pointsY(d.sub.interactionPairsIdx);
    
    
    subTemp.verticesX = cell(1,length(d.cells));
    subTemp.verticesY = cell(1,length(d.cells));
    subTemp.weightsLin = cell(1,length(d.cells));
    subTemp.pointsLin = cell(1,length(d.cells));
    subTemp.fFocalAdhesions = cell(1,length(d.cells));
    subTemp.matrixIdx = cell(1,length(d.cells));
    for k = 1:length(d.cells)
        subTemp.verticesX{k} = d.cells(k).verticesX(d.cells(k).substrate.connected);
        subTemp.verticesY{k} = d.cells(k).verticesY(d.cells(k).substrate.connected);
        subTemp.weightsLin{k} = d.cells(k).substrate.weightsLin;
        subTemp.pointsLin{k} = d.cells(k).substrate.pointsLin;
        subTemp.fFocalAdhesions{k} = d.cells(k).substrate.fFocalAdhesions;
        subTemp.matrixIdx{k} = d.cells(k).substrate.matrixIdx;
    end
    
    subTemp.pointsX = zeros(d.sub.nPoints,1);
    subTemp.pointsY = subTemp.pointsX;
    subTemp.vectorsX = zeros(size(subTemp.selvesX));
    subTemp.vectorsY = subTemp.vectorsX;
    subTemp.vectorLengths = subTemp.vectorsX;
    subTemp.reciprocalVectorLengths = subTemp.vectorsX;
    subTemp.unitVectorsX = subTemp.vectorsX;
    subTemp.unitVectorsY = subTemp.vectorsX;
    
    tooLargeMovement = 1;
    
    while tooLargeMovement
        
        while 1
            while 1
                while 1
                    [d, repeat] = get_substrate_increments(d, subTemp, 1, subDt);
                    if repeat; subDt = subDt/2; else; break; end
                end
                
                [d, repeat] = get_substrate_increments(d, subTemp, 2, subDt);
                if repeat; subDt = subDt/2; else; break; end
            end
            [d, repeat] = get_substrate_increments(d, subTemp, 3, subDt);
            if repeat; subDt = subDt/2; else; break; end
        end
        
        [d, ~] = get_substrate_increments(d, subTemp, 4, subDt);
        
        movementX = 1/6.*(d.sub.increments.k1X + 2.*d.sub.increments.k2X + 2.*d.sub.increments.k3X + d.sub.increments.k4X);
        movementY = 1/6.*(d.sub.increments.k1Y + 2.*d.sub.increments.k2Y + 2.*d.sub.increments.k3Y + d.sub.increments.k4Y);
        
        maxMovement = max(movementX.^2 + movementY.^2);
        
        if maxMovement >= d.spar.substrateMaximumMovementSq
            subDt = subDt/2;
            tooLargeMovement = 1;
        else
            d.sub.pointsX = d.sub.pointsX + movementX;
            d.sub.pointsY = d.sub.pointsY + movementY;
            time = time + subDt;
            tooLargeMovement = 0;
        end
    end
    
    if subDt < cellDt && maxMovement <= d.spar.substrateMinimumMovementSq
        multiplier = 2;
    else
        multiplier = 1;
    end
    
    while 1
        if round(10*(floor(time/d.spar.maximumTimeStep+1e-10)*d.spar.maximumTimeStep+d.spar.maximumTimeStep) - (multiplier*subDt+time))/10 >= 0
            subDt = subDt*multiplier;
            break
        else
            multiplier = multiplier/2;
        end
    end
    
end

end


