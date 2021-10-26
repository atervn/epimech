function d = scale_parameters(app,d)
% SCALE_PARAMETERS Scale simulation parameters to dimensionless
%   The function scales the model parameters with the eta, scaling length
%   and time to dimensionless values.
%   INPUT:
%       app: main application structure
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% scale the main cell parameters
d.spar.rCell = app.cellParameters.rCell/app.systemParameters.scalingLength; % L^-1
d.spar.membraneLength = app.cellParameters.membraneLength/app.systemParameters.scalingLength; % L^-1
d.spar.junctionLength = app.cellParameters.junctionLength/app.systemParameters.scalingLength; % L^-1
d.spar.fArea = app.cellParameters.fArea*app.systemParameters.scalingTime/app.systemParameters.eta; % T*eta^-1
d.spar.fCortex = app.cellParameters.fCortex*app.systemParameters.scalingTime/app.systemParameters.eta; % T*eta^-1
d.spar.fJunctions = app.cellParameters.fJunctions*app.systemParameters.scalingTime/app.systemParameters.eta; % T*eta^-1
d.spar.fContact = app.cellParameters.fContact*app.systemParameters.scalingTime/app.systemParameters.eta; % T*eta^-1
d.spar.perimeterConstant = app.cellParameters.perimeterConstant; % dimensionless
d.spar.perimeterModelingRate = app.cellParameters.perimeterModelingRate*app.systemParameters.scalingTime;  % T^-1

% LEGACY (changed from system default system parameters to normal cell
% parameters)
if isfield(app.cellParameters,'minimumCellSize')
    d.spar.minimumCellSize = app.cellParameters.minimumCellSize/app.systemParameters.scalingLength^2; % L^-2
else
    d.spar.minimumCellSize = app.import.specificCellParameters.minimumCellSize/app.systemParameters.scalingLength^2; % L^-2
end
    
% scale the growth-specific parameters (or parameters whose values are
% simulation specific)
if strcmp(app.simulationType,'growth')
    d.spar.fMembrane = app.specificCellParameters.fMembrane*app.systemParameters.scalingTime/app.systemParameters.eta; % T*eta^-1
    d.spar.fDivision = app.specificCellParameters.fDivision*app.systemParameters.scalingTime/app.systemParameters.eta/app.systemParameters.scalingLength; % T*eta^-1
    d.spar.divisionTimeMean = app.specificCellParameters.divisionTimeMean/app.systemParameters.scalingTime; % T^-1
    d.spar.divisionTimeSD = app.specificCellParameters.divisionTimeSD/app.systemParameters.scalingTime; % T^-1
    d.spar.divisionDistanceConstant = app.specificCellParameters.divisionDistanceConstant; % dimensionless
    d.spar.newCellAreaConstant = app.specificCellParameters.newCellAreaConstant; % dimensionless
    d.spar.cellGrowthConstant = app.specificCellParameters.cellGrowthConstant; % dimensionless
    d.spar.cellGrowthForceConstant = app.specificCellParameters.cellGrowthForceConstant; % dimensionless
    d.spar.baseDivisionRate = app.specificCellParameters.baseDivisionRate*(1e6*app.systemParameters.scalingLength)^6*app.systemParameters.scalingTime; % L(in um)^6*T
    d.spar.divisionRateExponents = app.specificCellParameters.divisionRateExponents; % dimensionless
    d.spar.maxMembraneAngle = app.specificCellParameters.maxMembraneAngle; % radians
    d.spar.maxJunctionAngleConstant = app.specificCellParameters.maxJunctionAngleConstant; % dimensionless
    d.spar.stopDivisionTime = app.systemParameters.stopDivisionTime/app.systemParameters.scalingTime; % T^-1
    d.spar.junctionModificationTimeStep = app.systemParameters.junctionModificationTimeStep/app.systemParameters.scalingTime; % T^-1
    d.spar.maximumGrowthTime = app.specificCellParameters.maximumGrowthTime/app.systemParameters.scalingTime; % T^-1
    d.spar.maximumDivisionTime = app.specificCellParameters.maximumDivisionTime/app.systemParameters.scalingTime; % T^-1

% scale the pointlike-specific parameters (or parameters whose values are
% simulation specific)   
elseif strcmp(app.simulationType,'pointlike')
    d.spar.fMembrane = app.specificCellParameters.fMembrane*app.systemParameters.scalingTime/app.systemParameters.eta; % T*eta^-1
    d.spar.fEdgeCell = app.specificCellParameters.fEdgeCell*app.systemParameters.scalingTime/app.systemParameters.eta*app.cellParameters.membraneLength*1e6; % T*eta^-1*membraneLength(in um)
    d.spar.fPointlike = app.systemParameters.fPointlike*app.systemParameters.scalingTime/app.systemParameters.eta; % T*eta^-1
    d.spar.focalAdhesionBreakingForceSq = ((app.cellParameters.membraneLength*1e6)*app.specificCellParameters.focalAdhesionBreakingForce*app.systemParameters.scalingTime/app.systemParameters.eta/app.systemParameters.scalingLength)^2; % T*eta^-1*L*membraneLength(in um), also squared
    d.spar.substratePointDistance = app.substrateParameters.substratePointDistance/app.systemParameters.scalingLength; % L^-1
    d.spar.repulsionLength = app.substrateParameters.repulsionLengthConstant*d.spar.substratePointDistance*sqrt(3)/2; % L^-1, also calculate the repulsion distance from the normal point distance
    d.spar.substrateMaximumMovementSq = (app.systemParameters.substrateMaximumMovement/app.systemParameters.scalingLength)^2; % L^-1, also squared
    d.spar.substrateMinimumMovementSq = (app.systemParameters.substrateMinimumMovement/app.systemParameters.scalingLength)^2; % L^-1, also squared
    
    % LEGACY (naming has changed)
    if isfield(app.substrateParameters,'substrateEdgeConstant')
        d.spar.edgeMultiplierSubstrate = app.substrateParameters.substrateEdgeConstant; % dimensionless
    else
        d.spar.edgeMultiplierSubstrate = app.substrateParameters.matrixEdgeConstant; % dimensionless
    end

% scale the stretch-specific parameters (or parameters whose values are
% simulation specific)  
elseif strcmp(app.simulationType,'stretch')
    d.spar.fMembrane = app.specificCellParameters.fMembrane*app.systemParameters.scalingTime/app.systemParameters.eta; % T*eta^-1
    d.spar.fEdgeCell = app.specificCellParameters.fEdgeCell*app.systemParameters.scalingTime/app.systemParameters.eta; % T*eta^-1
    d.spar.focalAdhesionBreakingForceSq = ((app.cellParameters.membraneLength*1e6)*app.specificCellParameters.focalAdhesionBreakingForce*app.systemParameters.scalingTime/app.systemParameters.eta/app.systemParameters.scalingLength)^2; % T*eta^-1*L*membraneLength(in um), also squared
    d.spar.substratePointDistance = app.substrateParameters.substratePointDistance/app.systemParameters.scalingLength; % L^-1
    d.spar.maxMembraneAngle = app.specificCellParameters.maxMembraneAngle; % radians
    d.spar.maxJunctionAngleConstant = app.specificCellParameters.maxJunctionAngleConstant; % dimensionless
    d.spar.junctionModificationTimeStep = app.systemParameters.junctionModificationTimeStep/app.systemParameters.scalingTime; % T^-1

% scale the opto-specific parameters (or parameters whose values are
% simulation specific)  
elseif strcmp(app.simulationType,'opto')
    d.spar.fMembrane = app.specificCellParameters.fMembrane*app.systemParameters.scalingTime/app.systemParameters.eta; % T*eta^-1
    d.spar.fEdgeCell = app.specificCellParameters.fEdgeCell*app.systemParameters.scalingTime/app.systemParameters.eta; % T*eta^-1
    d.spar.maxMembraneAngle = app.specificCellParameters.maxMembraneAngle; % radians
    d.spar.maxJunctionAngleConstant = app.specificCellParameters.maxJunctionAngleConstant; % dimensionless
    d.spar.focalAdhesionBreakingForceSq = ((app.cellParameters.membraneLength*1e6)*app.specificCellParameters.focalAdhesionBreakingForce*app.systemParameters.scalingTime/app.systemParameters.eta/app.systemParameters.scalingLength)^2; % T*eta^-1*L*membraneLength(in um), also squared
    d.spar.fullActivationConstant = app.systemParameters.fullActivationConstant; % dimensionless
    d.spar.substratePointDistance = app.substrateParameters.substratePointDistance/app.systemParameters.scalingLength; % L^-1
    d.spar.repulsionLength = app.substrateParameters.repulsionLengthConstant*d.spar.substratePointDistance*sqrt(3)/2; % L^-1, also calculate the repulsion distance from the normal point distance 
    d.spar.junctionModificationTimeStep = app.systemParameters.junctionModificationTimeStep/app.systemParameters.scalingTime; % T^-1
    d.spar.substrateMaximumMovementSq = (app.systemParameters.substrateMaximumMovement/app.systemParameters.scalingTime)^2; % L^-1, also squared
    d.spar.substrateMinimumMovementSq = (app.systemParameters.substrateMinimumMovement/app.systemParameters.scalingTime)^2; % L^-1, also squared
    
    % LEGACY (naming has changed)
    if isfield(app.substrateParameters,'substrateEdgeConstant')
        d.spar.edgeMultiplierSubstrate = app.substrateParameters.substrateEdgeConstant; % dimensionless
    else
        d.spar.edgeMultiplierSubstrate = app.substrateParameters.matrixEdgeConstant; % dimensionless
    end
end

% scale the simulation related parameters
d.spar.simulationTime = app.systemParameters.simulationTime/app.systemParameters.scalingTime; % T^-1
d.spar.maximumTimeStep = app.systemParameters.maximumTimeStep/app.systemParameters.scalingTime; % T^-1
d.spar.cellMaximumMovementSq = (app.systemParameters.cellMaximumMovement/app.systemParameters.scalingLength)^2; % L^-1, also squared
d.spar.cellMinimumMovementSq = (app.systemParameters.cellMinimumMovement/app.systemParameters.scalingLength)^2; % L^-1, also squared

% also save the eta, scaling time and length to the structure
d.spar.eta = app.systemParameters.eta;
d.spar.scalingTime = app.systemParameters.scalingTime;
d.spar.scalingLength = app.systemParameters.scalingLength;

end