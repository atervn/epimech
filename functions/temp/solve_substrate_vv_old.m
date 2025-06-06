function [d,dt] = solve_substrate_vv_old(d,dt)

cells = d.cells;

mass = 5e-8/d.spar.eta/d.spar.scalingTime;


% initialize cells to temporarily save data on the cell vertex
% coordiantes, their focal adhesion connetions and weights, focal
% adhesion strengths, and their indices in the substrateMatrix
subTemp.verticesX = cell(1,length(d.cells));
subTemp.verticesY = cell(1,length(d.cells));
subTemp.weightsLin = cell(1,length(d.cells));
subTemp.pointsLin = cell(1,length(d.cells));
subTemp.fFocalAdhesions = cell(1,length(d.cells));
subTemp.matrixIdx = cell(1,length(d.cells));

% go through the cells
for k = 1:length(d.cells)
    
    % get the data for cell k
    subTemp.verticesX{k} = d.cells(k).verticesX(d.cells(k).substrate.connected);
    subTemp.verticesY{k} = d.cells(k).verticesY(d.cells(k).substrate.connected);
    subTemp.weightsLin{k} = d.cells(k).substrate.weightsLin;
    subTemp.pointsLin{k} = d.cells(k).substrate.pointsLin;
    subTemp.fFocalAdhesions{k} = d.cells(k).substrate.fFocalAdhesions;
    subTemp.matrixIdx{k} = d.cells(k).substrate.matrixIdx;
end
    
% get the coordinates of the point that the central force is calculated
% for (called selves here)
subTemp.selvesX = d.sub.pointsX(d.sub.interactionSelvesIdx);
subTemp.selvesY = d.sub.pointsY(d.sub.interactionSelvesIdx);

% get the coordinates of the pair for the selves in the central forces
subTemp.pairsX = d.sub.pointsX(d.sub.interactionPairsIdx);
subTemp.pairsY = d.sub.pointsY(d.sub.interactionPairsIdx);

% initialize vectors to store the data for calculating each increment
subTemp.pointsX = zeros(d.sub.nPoints,1);
subTemp.pointsY = subTemp.pointsX;
subTemp.vectorsX = zeros(size(subTemp.selvesX));
subTemp.vectorsY = subTemp.vectorsX;
subTemp.vectorLengths = subTemp.vectorsX;
subTemp.reciprocalVectorLengths = subTemp.vectorsX;
subTemp.unitVectorsX = subTemp.vectorsX;
subTemp.unitVectorsY = subTemp.vectorsX;

subTemp.pointsX = d.sub.pointsX;
subTemp.pointsY = d.sub.pointsY;

% get the vectors between the pairs and "selves"
subTemp.vectorsX = subTemp.pairsX - subTemp.selvesX;
subTemp.vectorsY = subTemp.pairsY - subTemp.selvesY;

% get the central force vector lengths and their reciprocals
subTemp.vectorLengths = sqrt((subTemp.vectorsX).^2 + (subTemp.vectorsY).^2); 
subTemp.reciprocalVectorLengths = 1./subTemp.vectorLengths;

% get the central force unit vectors
subTemp.unitVectorsX = subTemp.vectorsX.*subTemp.reciprocalVectorLengths;
subTemp.unitVectorsY = subTemp.vectorsY.*subTemp.reciprocalVectorLengths;

% calculate the central substrate forces
[forces.centralForcesX,forces.centralForcesY] = get_substrate_central_forces(d,subTemp);

% calculate the repulsive forces between points and line segments between
% the neighboring edges
[forces.repulsionForcesX,forces.repulsionForcesY] = get_substrate_repulsion_forces(d,subTemp);

% calculate the restorative forces
[forces.restorativeForcesX,forces.restorativeForcesY] = get_substrate_restorative_forces(d,subTemp);

% calculate the focal adhesion forces
[forces.focalAdhesionForcesX,forces.focalAdhesionForcesY] = get_substrate_focal_adhesion_forces(d,subTemp);

forces.dampingX = -d.sub.velocitiesX;
forces.dampingY = -d.sub.velocitiesY;

% calculate the total forces
forces = get_substrate_total_forces_2(forces,d);

d.sub.pointsX = d.sub.pointsX + dt.*d.sub.velocitiesX + 0.5.*forces.totalForcesX./mass.*dt^2;
d.sub.pointsY = d.sub.pointsY + dt.*d.sub.velocitiesY + 0.5.*forces.totalForcesY./mass.*dt^2;

tempVeloX = d.sub.velocitiesX + 0.5.*forces.totalForcesX./mass.*dt;
tempVeloY = d.sub.velocitiesY + 0.5.*forces.totalForcesY./mass.*dt;


% get the coordinates of the point that the central force is calculated
% for (called selves here)
subTemp.selvesX = d.sub.pointsX(d.sub.interactionSelvesIdx);
subTemp.selvesY = d.sub.pointsY(d.sub.interactionSelvesIdx);

% get the coordinates of the pair for the selves in the central forces
subTemp.pairsX = d.sub.pointsX(d.sub.interactionPairsIdx);
subTemp.pairsY = d.sub.pointsY(d.sub.interactionPairsIdx);

% initialize vectors to store the data for calculating each increment
subTemp.pointsX = zeros(d.sub.nPoints,1);
subTemp.pointsY = subTemp.pointsX;
subTemp.vectorsX = zeros(size(subTemp.selvesX));
subTemp.vectorsY = subTemp.vectorsX;
subTemp.vectorLengths = subTemp.vectorsX;
subTemp.reciprocalVectorLengths = subTemp.vectorsX;
subTemp.unitVectorsX = subTemp.vectorsX;
subTemp.unitVectorsY = subTemp.vectorsX;

subTemp.pointsX = d.sub.pointsX;
subTemp.pointsY = d.sub.pointsY;
% get the vectors between the pairs and "selves"
subTemp.vectorsX = subTemp.pairsX - subTemp.selvesX;
subTemp.vectorsY = subTemp.pairsY - subTemp.selvesY;

% get the central force vector lengths and their reciprocals
subTemp.vectorLengths = sqrt((subTemp.vectorsX).^2 + (subTemp.vectorsY).^2); 
subTemp.reciprocalVectorLengths = 1./subTemp.vectorLengths;

% get the central force unit vectors
subTemp.unitVectorsX = subTemp.vectorsX.*subTemp.reciprocalVectorLengths;
subTemp.unitVectorsY = subTemp.vectorsY.*subTemp.reciprocalVectorLengths;



% calculate the central substrate forces
[forces.centralForcesX,forces.centralForcesY] = get_substrate_central_forces(d,subTemp);

% calculate the repulsive forces between points and line segments between
% the neighboring edges
[forces.repulsionForcesX,forces.repulsionForcesY] = get_substrate_repulsion_forces(d,subTemp);

% calculate the restorative forces
[forces.restorativeForcesX,forces.restorativeForcesY] = get_substrate_restorative_forces(d,subTemp);

% calculate the focal adhesion forces
[forces.focalAdhesionForcesX,forces.focalAdhesionForcesY] = get_substrate_focal_adhesion_forces(d,subTemp);

forces.dampingX = -tempVeloX;
forces.dampingY = -tempVeloY;

% calculate the total forces
forces = get_substrate_total_forces_2(forces,d);

d.sub.velocitiesX = d.sub.velocitiesX + 0.5.*forces.totalForcesX./mass.*dt;
d.sub.velocitiesY = d.sub.velocitiesY + 0.5.*forces.totalForcesY./mass.*dt;    
  
end