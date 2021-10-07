function sub = save_substrate_forces(forces,sub)
% SAVE_SUBSTRATE_FORCES Save the substrate forces
%   The function saves the forces affecting the substrate points.
%   INPUTS:
%       forces: substrate force structure
%       sub: substrate data structure
%   OUTPUT:
%       sub: substrate data structure
%   by Aapo Tervonen, 2021

% save each of the forces to the sub structure
sub.forces.centralX = forces.centralForcesX;
sub.forces.centralY = forces.centralForcesY;
sub.forces.repulsionX = forces.repulsionForcesX;
sub.forces.repulsionY = forces.repulsionForcesY;
sub.forces.restorativeX = forces.restorativeForcesX;
sub.forces.restorativeY = forces.restorativeForcesY;
sub.forces.focalAdhesionsX = forces.focalAdhesionForcesX;
sub.forces.focalAdhesionsY = forces.focalAdhesionForcesY;
sub.forces.totalX = forces.totalForcesX;
sub.forces.totalY = forces.totalForcesY;

end