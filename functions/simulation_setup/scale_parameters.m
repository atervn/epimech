function spar = scale_parameters(app)

spar.rCell = app.cellParameters.rCell/app.systemParameters.scalingLength;
spar.membraneLength = app.cellParameters.membraneLength/app.systemParameters.scalingLength;
spar.junctionLength = app.cellParameters.junctionLength/app.systemParameters.scalingLength;
spar.fArea = app.cellParameters.fArea*app.systemParameters.scalingTime/app.systemParameters.eta;
spar.fCortex = app.cellParameters.fCortex*app.systemParameters.scalingTime/app.systemParameters.eta;
spar.fJunctions = app.cellParameters.fJunctions*app.systemParameters.scalingTime/app.systemParameters.eta;
spar.fContact = app.cellParameters.fContact*app.systemParameters.scalingTime/app.systemParameters.eta;
spar.perimeterConstant = app.cellParameters.perimeterConstant;
spar.perimeterModelingRate = app.cellParameters.perimeterModelingRate*app.systemParameters.scalingTime;

if strcmp(app.simulationType,'growth')
    spar.fMembrane = app.specificCellParameters.fMembrane*app.systemParameters.scalingTime/app.systemParameters.eta;
    spar.fDivision = app.specificCellParameters.fDivision*app.systemParameters.scalingTime/app.systemParameters.eta/app.systemParameters.scalingLength;
    spar.divisionTimeMean = app.specificCellParameters.divisionTimeMean/app.systemParameters.scalingTime;
    spar.divisionTimeSD = app.specificCellParameters.divisionTimeSD/app.systemParameters.scalingTime;
    spar.divisionDistanceConstant = app.specificCellParameters.divisionDistanceConstant;
    spar.newCellAreaConstant = app.specificCellParameters.newCellAreaConstant;
    spar.cellGrowthConstant = app.specificCellParameters.cellGrowthConstant;
    spar.cellGrowthForceConstant = app.specificCellParameters.cellGrowthForceConstant;
    spar.baseDivisionRate = app.specificCellParameters.baseDivisionRate*(1e6*app.systemParameters.scalingLength)^6*app.systemParameters.scalingTime;
    spar.divisionRateExponents = app.specificCellParameters.divisionRateExponents;
    spar.maxMembraneAngle = app.specificCellParameters.maxMembraneAngle;
    spar.maxJunctionAngleConstant = app.specificCellParameters.maxJunctionAngleConstant;
    spar.stopDivisionTime = app.systemParameters.stopDivisionTime/app.systemParameters.scalingTime;
    spar.junctionModificationTimeStep = app.systemParameters.junctionModificationTimeStep/app.systemParameters.scalingTime;
    spar.maximumGrowthTime = app.specificCellParameters.maximumGrowthTime/app.systemParameters.scalingTime;
    spar.maximumDivisionTime = app.specificCellParameters.maximumDivisionTime/app.systemParameters.scalingTime;
    spar.minimumCellSize = app.specificCellParameters.minimumCellSize/app.systemParameters.scalingLength^2;
    
elseif strcmp(app.simulationType,'pointlike')
    spar.fMembrane = app.specificCellParameters.fMembrane*app.systemParameters.scalingTime/app.systemParameters.eta;
    spar.fEdgeCell = app.specificCellParameters.fEdgeCell*app.systemParameters.scalingTime/app.systemParameters.eta*app.cellParameters.membraneLength*1e6;
    spar.fPointlike = app.systemParameters.fPointlike*app.systemParameters.scalingTime/app.systemParameters.eta;
    spar.focalAdhesionBreakingForceSq = ((app.cellParameters.membraneLength*1e6)*app.specificCellParameters.focalAdhesionBreakingForce*app.systemParameters.scalingTime/app.systemParameters.eta/app.systemParameters.scalingLength)^2;
    spar.substratePointDistance = app.substrateParameters.substratePointDistance/app.systemParameters.scalingLength;
    spar.repulsionLength = app.substrateParameters.repulsionLengthConstant*app.substrateParameters.substratePointDistance*sqrt(3)/2;
    spar.edgeMultiplierSubstrate = app.substrateParameters.substrateEdgeConstant;
    spar.substrateMaximumMovementSq = (app.systemParameters.substrateMaximumMovement/app.systemParameters.scalingLength)^2;
    spar.substrateMinimumMovementSq = (app.systemParameters.substrateMinimumMovement/app.systemParameters.scalingLength)^2;
    
elseif strcmp(app.simulationType,'stretch')
    spar.fMembrane = app.specificCellParameters.fMembrane*app.systemParameters.scalingTime/app.systemParameters.eta;
    spar.fEdgeCell = app.specificCellParameters.fEdgeCell*app.systemParameters.scalingTime/app.systemParameters.eta;
    spar.focalAdhesionBreakingForceSq = ((app.cellParameters.membraneLength*1e6)*app.specificCellParameters.focalAdhesionBreakingForce*app.systemParameters.scalingTime/app.systemParameters.eta/app.systemParameters.scalingLength)^2;
    spar.substratePointDistance = app.substrateParameters.substratePointDistance/app.systemParameters.scalingLength;
    spar.maxMembraneAngle = app.specificCellParameters.maxMembraneAngle;
    spar.maxJunctionAngleConstant = app.specificCellParameters.maxJunctionAngleConstant;
 
elseif strcmp(app.simulationType,'opto')
    spar.fMembrane = app.specificCellParameters.fMembrane*app.systemParameters.scalingTime/app.systemParameters.eta;
    spar.fEdgeCell = app.specificCellParameters.fEdgeCell*app.systemParameters.scalingTime/app.systemParameters.eta;
    spar.maxMembraneAngle = app.specificCellParameters.maxMembraneAngle;
    spar.maxJunctionAngleConstant = app.specificCellParameters.maxJunctionAngleConstant;
    spar.focalAdhesionBreakingForceSq = ((app.cellParameters.membraneLength*1e6)*app.specificCellParameters.focalAdhesionBreakingForce*app.systemParameters.scalingTime/app.systemParameters.eta/app.systemParameters.scalingLength)^2;
    spar.fullActivationConstant = app.systemParameters.fullActivationConstant;
    spar.substratePointDistance = app.substrateParameters.substratePointDistance/app.systemParameters.scalingLength;
    spar.repulsionLength = app.substrateParameters.repulsionLengthConstant*app.substrateParameters.substratePointDistance*sqrt(3)/2;
    spar.edgeMultiplierSubstrate = app.substrateParameters.substrateEdgeConstant;
    spar.junctionModificationTimeStep = app.systemParameters.junctionModificationTimeStep/app.systemParameters.scalingTime;
    spar.substrateMaximumMovementSq = (app.systemParameters.substrateMaximumMovement/app.systemParameters.scalingTime)^2;
    spar.substrateMinimumMovementSq = (app.systemParameters.substrateMinimumMovement/app.systemParameters.scalingTime)^2;
end

spar.eta = app.systemParameters.eta;
spar.scalingTime = app.systemParameters.scalingTime;
spar.scalingLength = app.systemParameters.scalingLength;

spar.simulationTime = app.systemParameters.simulationTime/app.systemParameters.scalingTime;
spar.maximumTimeStep = app.systemParameters.maximumTimeStep/app.systemParameters.scalingTime;

spar.cellMaximumMovementSq = (app.systemParameters.cellMaximumMovement/app.systemParameters.scalingLength)^2;
spar.cellMinimumMovementSq = (app.systemParameters.cellMinimumMovement/app.systemParameters.scalingLength)^2;

end