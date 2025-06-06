function [d,subDt] = solve_substrate_vv(d,dt,subDt)

if subDt > dt
    subDt = dt;
end

mass = 1e-23/d.spar.eta/d.spar.scalingTime;

time = 0;

etaMult = 1;

while 1
    
    subTemp = get_subtemp(d);
    
    % calculate the central substrate forces
    [forces.centralForcesX,forces.centralForcesY] = get_substrate_central_forces(d,subTemp);
    
    % calculate the repulsive forces between points and line segments between
    % the neighboring edges
    [forces.repulsionForcesX,forces.repulsionForcesY] = get_substrate_repulsion_forces(d,subTemp);
    
    % calculate the restorative forces
    [forces.restorativeForcesX,forces.restorativeForcesY] = get_substrate_restorative_forces(d,subTemp);
    
    % calculate the focal adhesion forces
    [forces.focalAdhesionForcesX,forces.focalAdhesionForcesY] = get_substrate_focal_adhesion_forces(d,subTemp);
    
    forces.dampingX = -etaMult.*d.sub.velocitiesX;
    forces.dampingY = -etaMult.*d.sub.velocitiesY;
    
    % calculate the total forces
    forces = get_substrate_total_forces_2(forces);
    
    tempForces = forces;
    
    allNotGood = 1;
    
    while allNotGood
        
        movementX = subDt.*d.sub.velocitiesX + 0.5.*forces.totalForcesX./mass.*subDt^2;
        movementY = subDt.*d.sub.velocitiesY + 0.5.*forces.totalForcesY./mass.*subDt^2;
        
        maxMovement = sqrt(max(movementX.^2 + movementY.^2));
        
        if maxMovement > 0.0005
            subDt = subDt/2;
        else
            
            allNotGood = 0;
            
            d.sub.pointsX = d.sub.pointsX + movementX;
            d.sub.pointsY = d.sub.pointsY + movementY;
            
            tempVeloX = d.sub.velocitiesX + 0.5.*forces.totalForcesX./mass.*subDt;
            tempVeloY = d.sub.velocitiesY + 0.5.*forces.totalForcesY./mass.*subDt;
        end
    end
    
    subTemp = get_subtemp(d);
    
    % calculate the central substrate forces
    [forces.centralForcesX,forces.centralForcesY] = get_substrate_central_forces(d,subTemp);
    
    % calculate the repulsive forces between points and line segments between
    % the neighboring edges
    [forces.repulsionForcesX,forces.repulsionForcesY] = get_substrate_repulsion_forces(d,subTemp);
    
    % calculate the restorative forces
    [forces.restorativeForcesX,forces.restorativeForcesY] = get_substrate_restorative_forces(d,subTemp);
    
    % calculate the focal adhesion forces
    [forces.focalAdhesionForcesX,forces.focalAdhesionForcesY] = get_substrate_focal_adhesion_forces(d,subTemp);
    
    forces.dampingX = -etaMult.*tempVeloX;
    forces.dampingY = -etaMult.*tempVeloY;
    
    % calculate the total forces
    forces = get_substrate_total_forces_2(forces);
    
    d.sub.velocitiesX = d.sub.velocitiesX + 0.5.*(tempForces.totalForcesX + forces.totalForcesX)./mass.*dt;
    d.sub.velocitiesY = d.sub.velocitiesY + 0.5.*(tempForces.totalForcesY + forces.totalForcesY)./mass.*dt;
    
    time = time + subDt;
    
    if subDt < dt && maxMovement <= 0.00005
        multiplier = 2;
    else
        multiplier = 1;
    end
    
    if abs(dt - time) < 1e-8

        subDt = subDt*multiplier;
        break

    else
        
        while 1
            
            if  multiplier*subDt + time <= dt
                
                % get the new time step
                subDt = subDt*multiplier;
                break
               
            else
                multiplier = multiplier/2;
            end
        end
    end
    
end

end





function subTemp = get_subtemp(d)

% initialize cells to temporarily save data on the cell vertex
% coordiantes, their focal adhesion connetions and weights, focal
% adhesion strengths, and their indices in the substrateMatrix
subTemp.verticesX = cell(1,length(d.cells));
subTemp.verticesY = cell(1,length(d.cells));
subTemp.weightsLin = cell(1,length(d.cells));
subTemp.pointsLin = cell(1,length(d.cells));
subTemp.fFocalAdhesions = cell(1,length(d.cells));
subTemp.matrixIdx = cell(1,length(d.cells));

% go through the cells
for k = 1:length(d.cells)
    
    % get the data for cell k
    subTemp.verticesX{k} = d.cells(k).verticesX(d.cells(k).substrate.connected);
    subTemp.verticesY{k} = d.cells(k).verticesY(d.cells(k).substrate.connected);
    subTemp.weightsLin{k} = d.cells(k).substrate.weightsLin;
    subTemp.pointsLin{k} = d.cells(k).substrate.pointsLin;
    subTemp.fFocalAdhesions{k} = d.cells(k).substrate.fFocalAdhesions;
    subTemp.matrixIdx{k} = d.cells(k).substrate.matrixIdx;
end
    
% get the coordinates of the point that the central force is calculated
% for (called selves here)
subTemp.selvesX = d.sub.pointsX(d.sub.interactionSelvesIdx);
subTemp.selvesY = d.sub.pointsY(d.sub.interactionSelvesIdx);

% get the coordinates of the pair for the selves in the central forces
subTemp.pairsX = d.sub.pointsX(d.sub.interactionPairsIdx);
subTemp.pairsY = d.sub.pointsY(d.sub.interactionPairsIdx);

% initialize vectors to store the data for calculating each increment
subTemp.pointsX = zeros(d.sub.nPoints,1);
subTemp.pointsY = subTemp.pointsX;
subTemp.vectorsX = zeros(size(subTemp.selvesX));
subTemp.vectorsY = subTemp.vectorsX;
subTemp.vectorLengths = subTemp.vectorsX;
subTemp.reciprocalVectorLengths = subTemp.vectorsX;
subTemp.unitVectorsX = subTemp.vectorsX;
subTemp.unitVectorsY = subTemp.vectorsX;

subTemp.pointsX = d.sub.pointsX;
subTemp.pointsY = d.sub.pointsY;

% get the vectors between the pairs and "selves"
subTemp.vectorsX = subTemp.pairsX - subTemp.selvesX;
subTemp.vectorsY = subTemp.pairsY - subTemp.selvesY;

% get the central force vector lengths and their reciprocals
subTemp.vectorLengths = sqrt((subTemp.vectorsX).^2 + (subTemp.vectorsY).^2); 
subTemp.reciprocalVectorLengths = 1./subTemp.vectorLengths;

% get the central force unit vectors
subTemp.unitVectorsX = subTemp.vectorsX.*subTemp.reciprocalVectorLengths;
subTemp.unitVectorsY = subTemp.vectorsY.*subTemp.reciprocalVectorLengths;

end