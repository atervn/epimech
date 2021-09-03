function forces = get_substrate_total_forces(forces)

forces.totalForcesX = forces.directForcesX + forces.boundaryRepulsionForcesX + forces.restorativeForcesX + forces.focalAdhesionForcesX;
forces.totalForcesY = forces.directForcesY + forces.boundaryRepulsionForcesY + forces.restorativeForcesY + forces.focalAdhesionForcesY;
