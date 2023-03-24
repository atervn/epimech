function [repulsionForcesX,repulsionForcesY] = get_substrate_repulsion_forces(d,subTemp)
% GET_SUBSTRATE_REPULSION_FORCES Calculate the substrate repulsion forces
%   The function calculates the repulsion forces between the substrate
%   points and the line segments between their neigbors based on a
%   nonlinear spring.
%   INPUTS:
%       d: main simulation data structure
%       subTemp: temporary structure that contains the substrate and cell
%       data used in the calculations
%   OUTPUT:
%       repulsionForcesX: x-components of the central forces
%       repulsionForcesY: y-components of the central forces
%   by Aapo Tervonen, 2021

% get the vectors between the neighboring point and the current point
repulsionVectorsX = subTemp.vectorsX(d.sub.repulsionVectors1Idx);
repulsionVectorsY = subTemp.vectorsY(d.sub.repulsionVectors1Idx);

% get the unit vectors between two neighboring points (between which the
% line segment is)
repsulsionUnitVectorsX = subTemp.unitVectorsX(d.sub.repulsionVectors2Idx);
repsulsionUnitVectorsY = subTemp.unitVectorsY(d.sub.repulsionVectors2Idx);

% temporary variable (basically the length of the repulsion distance after
% it absolute values are taken)
temp = (repsulsionUnitVectorsX.*repulsionVectorsY - repsulsionUnitVectorsY.*repulsionVectorsX).*d.sub.repulsionChangeSigns;

% get the vectors for the repulsion
orthogonalInteractionX = -temp.*repsulsionUnitVectorsY;
orthogonalInteractionY = temp.*repsulsionUnitVectorsX;

% get the distances of the points from the line segments
orthogonalLength = abs(temp);

% find the cases that are too close
tooClose = orthogonalLength < d.spar.repulsionLength;

% get the reciprocal lengths of the too close ones
reciprocalOrthogonalLength = 1./orthogonalLength(tooClose);

% calculate the force magnitude based on the nonlinear springs (also divide
% by the lengths to get the unit vectors in the next step)
forceStrengths = d.sub.repulsionSpringConstants(tooClose).*(orthogonalLength(tooClose) - (d.spar.repulsionLength)^2.*reciprocalOrthogonalLength).*reciprocalOrthogonalLength;

% get the components for the repulsion forces
repulsionForcesLinX = forceStrengths.*orthogonalInteractionX(tooClose);
repulsionForcesLinY = forceStrengths.*orthogonalInteractionY(tooClose);

% initialize a matrix for the total forca calculations (with 6 rows for the
% maximum number of repulsive interactions) and columns equal to the number
% of points)
repulsionForcesX = d.sub.emptyMatrix;
repulsionForcesY = d.sub.emptyMatrix;

% find the linear indices for the repulsive interactions that are too close
tempIdx = d.sub.repulsionLinIdx(tooClose);

% input the too close repulsive forces to the matrix
repulsionForcesX(tempIdx) = repulsionForcesLinX;
repulsionForcesY(tempIdx) = repulsionForcesLinY;

% sum over the force matrix and rotate the vector to obtain the total
% repulsive forces
repulsionForcesX = sum(repulsionForcesX,1)';
repulsionForcesY = sum(repulsionForcesY,1)';

end