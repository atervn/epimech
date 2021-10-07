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
sub.repulsionLinIdx = 0;
sub.repulsionVectorsIdx = 0;
sub.repulsionVectors2Idx = 0;
sub.repulsionChangeSigns = 0;
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
sub.forces.centralX = 0;
sub.forces.centralY = 0;
sub.forces.repulsionX = 0;
sub.forces.repulsionY = 0;
sub.forces.restorativeX = 0;
sub.forces.restorativeY = 0;
sub.forces.focalAdhesionsX = 0;
sub.forces.focalAdhesionsY = 0;
sub.forces.totalX = 0;
sub.forces.totalY = 0;

end