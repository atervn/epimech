function [boundaryRepulsionForcesX,boundaryRepulsionForcesY] = get_substrate_boundary_repulsion_forces(d,subTemp)

boundaryRepulsionVectorsX = subTemp.vectorsX(d.sub.boundaryRepulsionVectorsIdx);
boundaryRepulsionVectorsY = subTemp.vectorsY(d.sub.boundaryRepulsionVectorsIdx);

boundaryRepsulsionUnitVectorsX = subTemp.unitVectorsX(d.sub.boundaryRepulsionVectors2Idx);
boundaryRepsulsionUnitVectorsY = subTemp.unitVectorsY(d.sub.boundaryRepulsionVectors2Idx);

temp = (boundaryRepsulsionUnitVectorsX.*boundaryRepulsionVectorsY - boundaryRepsulsionUnitVectorsY.*boundaryRepulsionVectorsX).*d.sub.boundaryRepulsionChangeSigns;

orthogonalLinkX = -temp.*boundaryRepsulsionUnitVectorsY;
orthogonalLinkY = temp.*boundaryRepsulsionUnitVectorsX;

orthogonalLength = abs(temp);

tooClose = orthogonalLength < d.spar.repulsionLength;

orthogonalLengthInv = 1./orthogonalLength(tooClose);

forceStrengths = d.sub.boundaryRepulsionSpringConstants(tooClose).*(orthogonalLength(tooClose) - (d.spar.repulsionLength)^2.*orthogonalLengthInv).*orthogonalLengthInv;

boundaryRepulsionForcesLinX = forceStrengths.*orthogonalLinkX(tooClose);
boundaryRepulsionForcesLinY = forceStrengths.*orthogonalLinkY(tooClose);

boundaryRepulsionForcesX = d.sub.emptyMatrix;
boundaryRepulsionForcesY = d.sub.emptyMatrix;

idx = d.sub.boundaryRepulsionLinIdx(tooClose);

boundaryRepulsionForcesX(idx) = boundaryRepulsionForcesLinX;
boundaryRepulsionForcesY(idx) = boundaryRepulsionForcesLinY;

boundaryRepulsionForcesX = sum(boundaryRepulsionForcesX,1)';
boundaryRepulsionForcesY = sum(boundaryRepulsionForcesY,1)';