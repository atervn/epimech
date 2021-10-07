function forces = initialize_substrate_forces_struct(nPoints)
% INITIALIZE_SUBSTRATE_FORCES_STRUCT Initializes a structure for the
% substrate forces
%   The function creates a structure of zero vectors to store the substrate
%   forces.
%   INPUTS:
%       nPoints: number of substrate points
%   OUTPUT:
%       forces: force structure
%   by Aapo Tervonen, 2021

% create a zero vector for each component of each substrate force
forces.centralForcesX = zeros(nPoints,1);
forces.centralForcesY = forces.centralForcesX;
forces.repulsionForcesX = forces.centralForcesX;
forces.repulsionForcesY = forces.centralForcesX;
forces.restorativeForcesX = forces.centralForcesX;
forces.restorativeForcesY = forces.centralForcesX;
forces.focalAdhesionForcesX = forces.centralForcesX;
forces.focalAdhesionForcesY = forces.centralForcesX;
forces.totalForcesX = forces.centralForcesX;
forces.totalForcesY = forces.centralForcesX;

end