function [restorativeForcesX,restorativeForcesY] = get_substrate_restorative_forces(d,subTemp,spar)

restorativeForcesX = d.sub.restorativeSpringConstants.*(d.sub.pointsOriginalX - subTemp.pointsX);
restorativeForcesY = d.sub.restorativeSpringConstants.*(d.sub.pointsOriginalY - subTemp.pointsY);

restorativeForcesX(d.sub.edgePoints) = d.spar.edgeMultiplierSubstrate.*restorativeForcesX(d.sub.edgePoints);
restorativeForcesY(d.sub.edgePoints) = d.spar.edgeMultiplierSubstrate.*restorativeForcesY(d.sub.edgePoints);