function forces = get_substrate_total_forces(forces)
% GET_SUBSTRATE_TOTAL_FORCES Calculate the total substrate forces
%   The function calculates the total forces affecting the substrate points
%   based on the four forces.
%   INPUTS:
%       forces: substrate force structure
%   OUTPUT:
%       forces: substrate force structure
%   by Aapo Tervonen, 2021

% sum over all the forces for each substrate point
forces.totalForcesX = forces.centralForcesX + forces.repulsionForcesX + forces.restorativeForcesX + forces.focalAdhesionForcesX;
forces.totalForcesY = forces.centralForcesY + forces.repulsionForcesY + forces.restorativeForcesY + forces.focalAdhesionForcesY;

end