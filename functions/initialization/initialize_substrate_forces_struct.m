function forces = initialize_substrate_forces_struct(nPoints)

forces.directForcesX = zeros(nPoints,1);
forces.directForcesY = forces.directForcesX;
forces.boundaryRepulsionForcesX = forces.directForcesX;
forces.boundaryRepulsionForcesY = forces.directForcesX;
forces.restorativeForcesX = forces.directForcesX;
forces.restorativeForcesY = forces.directForcesX;
forces.focalAdhesionForcesX = forces.directForcesX;
forces.focalAdhesionForcesY = forces.directForcesX;
forces.totalForcesX = forces.directForcesX;
forces.totalForcesY = forces.directForcesX;
