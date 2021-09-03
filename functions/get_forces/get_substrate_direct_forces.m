function [directForcesX,directForcesY] = get_substrate_direct_forces(d,subTemp)

forceStrengths = d.sub.directInteractionSpringConstants.*(subTemp.vectorLengths - d.spar.substratePointDistance.^2.*subTemp.reciprocalVectorLengths);

directForcesLinX = forceStrengths.*subTemp.unitVectorsX;
directForcesLinY = forceStrengths.*subTemp.unitVectorsY;

directForcesX = d.sub.emptyMatrix;
directForcesY = d.sub.emptyMatrix;

% uniqueTempIdx = subTempPoints.uniqueInds;
% nonuniqueTempIdx = subTempPoints.nonuniqueInds;

directForcesX(d.sub.interactionLinIdx) = directForcesLinX;
directForcesX(d.sub.counterInteractionLinIdx) = -directForcesLinX;
directForcesY(d.sub.interactionLinIdx) = directForcesLinY;
directForcesY(d.sub.counterInteractionLinIdx) = -directForcesLinY;

directForcesX = sum(directForcesX,1)';
directForcesY = sum(directForcesY,1)';