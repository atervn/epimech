function [restorativeForcesX,restorativeForcesY] = get_substrate_restorative_forces(d,subTemp)
% GET_SUBSTRATE_RESTORATIVE_FORCES Calculate the substrate restorative
% forces
%   The function calculates the restorative forces for the substrate
%   points.
%   INPUTS:
%       d: main simulation data structure
%       subTemp: temporary structure that contains the substrate and cell
%       data used in the calculations
%   OUTPUT:
%       restorativeForcesX: x-components of the restorative forces
%       restorativeForcesY: y-components of the restorative forces
%   by Aapo Tervonen, 2021

if d.simset.simulationType == 6
    offsetY = d.sub.pointsOriginalY;
    offsetY(d.simset.glass.substrateIdx) = offsetY(d.simset.glass.substrateIdx) + d.simset.glass.glassOffset;
    restorativeForcesX = d.sub.restorativeSpringConstants.*(d.sub.pointsOriginalX - subTemp.pointsX);
    restorativeForcesY = d.sub.restorativeSpringConstants.*(offsetY - subTemp.pointsY);
else
    % calculate the restorative force components
    restorativeForcesX = d.sub.restorativeSpringConstants.*(d.sub.pointsOriginalX - subTemp.pointsX);
    restorativeForcesY = d.sub.restorativeSpringConstants.*(d.sub.pointsOriginalY - subTemp.pointsY);
end

% for the points at the edges of the substrate area, multiply with the
% additional edge constant
restorativeForcesX(d.sub.edgePoints) = d.spar.edgeMultiplierSubstrate.*restorativeForcesX(d.sub.edgePoints);
restorativeForcesY(d.sub.edgePoints) = d.spar.edgeMultiplierSubstrate.*restorativeForcesY(d.sub.edgePoints);

end