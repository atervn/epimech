function sub = initialize_substrate_structure

sub.pointsX = zeros(0,1);
sub.pointsY = zeros(0,1);
sub.adhesionNumbers = zeros(0,1);
sub.nPoints = 0;
sub.pointsOriginalX = 0;
sub.pointsOriginalY = 0;
sub.interactionSelvesIdx = 0;
sub.interactionPairsIdx = 0;
sub.interactionLinIdx = 0;
sub.counterInteractionLinIdx = 0;
sub.boundaryRepulsionLinIdx = 0;
sub.boundaryRepulsionVectorsIdx = 0;
sub.boundaryRepulsionVectors2Idx = 0;
sub.boundaryRepulsionChangeSigns = 0;
sub.springMultipliers = 0;
sub.emptyMatrix = 0;
sub.increments.k1X = 0;
sub.increments.k1Y = 0;
sub.increments.k2X = 0;
sub.increments.k2Y = 0;
sub.increments.k3X = 0;
sub.increments.k3Y = 0;
sub.increments.k4X = 0;
sub.increments.k4Y = 0;
sub.forces.directX = 0;
sub.forces.directY = 0;
sub.forces.boundaryRepulsionX = 0;
sub.forces.boundaryRepulsionY = 0;
sub.forces.restorativeX = 0;
sub.forces.restorativeY = 0;
sub.forces.focalAdhesionsX = 0;
sub.forces.focalAdhesionsY = 0;
sub.forces.totalX = 0;
sub.forces.totalY = 0;

end