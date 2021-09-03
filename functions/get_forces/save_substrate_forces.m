function sub = save_substrate_forces(forces,sub)

sub.forces.directX = forces.directForcesX;
sub.forces.directY = forces.directForcesY;
sub.forces.boundaryRepulsionX = forces.boundaryRepulsionForcesX;
sub.forces.boundaryRepulsionY = forces.boundaryRepulsionForcesY;
sub.forces.restorativeX = forces.restorativeForcesX;
sub.forces.restorativeY = forces.restorativeForcesY;
sub.forces.focalAdhesionsX = forces.focalAdhesionForcesX;
sub.forces.focalAdhesionsY = forces.focalAdhesionForcesY;
sub.forces.totalX = forces.totalForcesX;
sub.forces.totalY = forces.totalForcesY;