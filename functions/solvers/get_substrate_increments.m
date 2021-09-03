function [d, repeat] = get_substrate_increments(d, subTemp, kIteration, dt)

repeat = false;

if kIteration == 1
    subTemp.pointsX = d.sub.pointsX;
    subTemp.pointsY = d.sub.pointsY;
    subTemp.vectorsX = subTemp.pairsX - subTemp.selvesX;
    subTemp.vectorsY = subTemp.pairsY - subTemp.selvesY;
else
    if kIteration == 2
        kPrevX = d.sub.increments.k1X./2;
        kPrevY = d.sub.increments.k1Y./2;
    elseif kIteration == 3
        kPrevX = d.sub.increments.k2X./2;
        kPrevY = d.sub.increments.k2Y./2;
    elseif kIteration == 4
        kPrevX = d.sub.increments.k3X;
        kPrevY = d.sub.increments.k3Y;
    end
    
    subTemp.pointsX = d.sub.pointsX + kPrevX;
    subTemp.pointsY = d.sub.pointsY + kPrevY;
    
    subTemp.selvesX = subTemp.selvesX + kPrevX(d.sub.interactionSelvesIdx);
    subTemp.selvesY = subTemp.selvesY + kPrevY(d.sub.interactionSelvesIdx);
    
    subTemp.pairsX = subTemp.pairsX + kPrevX(d.sub.interactionPairsIdx);
    subTemp.pairsY = subTemp.pairsY + kPrevY(d.sub.interactionPairsIdx);
    
    subTemp.vectorsX = subTemp.pairsX - subTemp.selvesX;
    subTemp.vectorsY = subTemp.pairsY - subTemp.selvesY;
end

subTemp.vectorLengths = sqrt((subTemp.vectorsX).^2 + (subTemp.vectorsY).^2); 

subTemp.reciprocalVectorLengths = 1./subTemp.vectorLengths;

subTemp.unitVectorsX = subTemp.vectorsX.*subTemp.reciprocalVectorLengths;
subTemp.unitVectorsY = subTemp.vectorsY.*subTemp.reciprocalVectorLengths;

forces = initialize_substrate_forces_struct(d.sub.nPoints);

[forces.directForcesX,forces.directForcesY] = get_substrate_direct_forces(d,subTemp);
[forces.boundaryRepulsionForcesX,forces.boundaryRepulsionForcesY] = get_substrate_boundary_repulsion_forces(d,subTemp);
[forces.restorativeForcesX,forces.restorativeForcesY] = get_substrate_restorative_forces(d,subTemp);
[forces.focalAdhesionForcesX,forces.focalAdhesionForcesY] = get_substrate_focal_adhesion_forces(d,subTemp);

forces = get_substrate_total_forces(forces);

if kIteration == 1
    d.sub = save_substrate_forces(forces,d.sub);
    d.sub.increments.k1X = dt.*forces.totalForcesX;
    d.sub.increments.k1Y = dt.*forces.totalForcesY;
    if max(d.sub.increments.k1X.^2 + d.sub.increments.k1Y.^2) >= 5*d.spar.substrateMaximumMovementSq
        repeat = true;
        return
    end
elseif kIteration == 2
    d.sub.increments.k2X = dt.*forces.totalForcesX;
    d.sub.increments.k2Y = dt.*forces.totalForcesY;
    if max(d.sub.increments.k2X.^2 + d.sub.increments.k2Y.^2) >= 5*d.spar.substrateMaximumMovementSq
        repeat = true;
        return
    end
elseif kIteration == 3
    d.sub.increments.k3X = dt.*forces.totalForcesX;
    d.sub.increments.k3Y = dt.*forces.totalForcesY;
    if max(d.sub.increments.k3X.^2 + d.sub.increments.k3Y.^2) >= 5*d.spar.substrateMaximumMovementSq
        repeat = true;
        return
    end
elseif kIteration == 4
    d.sub.increments.k4X = dt.*forces.totalForcesX;
    d.sub.increments.k4Y = dt.*forces.totalForcesY;
end

end