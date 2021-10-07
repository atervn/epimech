function [centralForcesX,centralForcesY] = get_substrate_central_forces(d,subTemp)
% GET_SUBSTRATE_CENTRAL_FORCES Calculate the substrate central forces
%   The function calculates the central forces between the substrate
%   points based on nonlinear springs
%   INPUTS:
%       d: main simulation data structure
%       subTemp: temporary structure that contains the substrate and cell
%       data used in the calculations
%   OUTPUT:
%       centralForcesX: x-components of the central forces
%       centralForcesY: y-components of the central forces
%   by Aapo Tervonen, 2021

% calculate the force strengths based on the nonlinear springs (the 
% centralInteractionSpringConstants is either a single value for a
% substrate with unifrom stiffness or has the length of the number of
% central interactions in the case for a heterogeneous stiffness).
forceStrengths = d.sub.centralInteractionSpringConstants.*(subTemp.vectorLengths - d.spar.substratePointDistance.^2.*subTemp.reciprocalVectorLengths);

% calculate the central forces for each interaction
centralForcesLinX = forceStrengths.*subTemp.unitVectorsX;
centralForcesLinY = forceStrengths.*subTemp.unitVectorsY;

% create empty matrices (with 6 rows for the maximum number of central
% interactions) and columns equal to the number of points) for the force
% components
centralForcesX = d.sub.emptyMatrix;
centralForcesY = d.sub.emptyMatrix;

% based on the predefined indices, input the calculated central forces to
% these matrices and also for the pair of each interaction (same magnitude
% but opposite direction force)  
centralForcesX(d.sub.interactionLinIdx) = centralForcesLinX;
centralForcesX(d.sub.counterInteractionLinIdx) = -centralForcesLinX;
centralForcesY(d.sub.interactionLinIdx) = centralForcesLinY;
centralForcesY(d.sub.counterInteractionLinIdx) = -centralForcesLinY;

% sum over the force matrix and rotate the vector to obtain the total
% central forces
centralForcesX = sum(centralForcesX,1)';
centralForcesY = sum(centralForcesY,1)';

end