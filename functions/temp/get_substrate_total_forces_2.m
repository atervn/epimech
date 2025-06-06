function forces = get_substrate_total_forces_2(forces,d)
% GET_SUBSTRATE_TOTAL_FORCES Calculate the total substrate forces
%   The function calculates the total forces affecting the substrate points
%   based on the four forces.
%   INPUTS:
%       forces: substrate force structure
%   OUTPUT:
%       forces: substrate force structure
%   by Aapo Tervonen, 2021

% sum over all the forces for each substrate point
forces.totalForcesX = forces.centralForcesX + forces.repulsionForcesX + forces.restorativeForcesX + forces.focalAdhesionForcesX + forces.dampingX;
forces.totalForcesY = forces.centralForcesY + forces.repulsionForcesY + forces.restorativeForcesY + forces.focalAdhesionForcesY + forces.dampingY;





% forces.totalForcesY(end-100:end) = forces.totalForcesY(end-100:end) + 1e-9*d.spar.scalingTime/(d.spar.scalingLength*d.spar.eta);






end