function [d, repeat] = get_substrate_increments(d, subTemp, kIncrement, dt, varargin)
% GET_SUBSTRATE_INCREMENT Calculate the 4th order Runge-Kutta increments
%   The function calculates the increment for the 4th order Runge-Kutta
%   method for the substrate points by calculating the total force at each
%   increment and multiplying it by the time step. If the movement
%   increment are too large, the function will return so that the time step
%   can be halved.
%   INPUTS:
%       d: main simulation data structure
%       subTemp: temporary structure that contains the substrate and cell
%       data used in the calculations
%       kIncrement: the number of the increment (1 or 2)
%       dt: current time step
%       varargin: may contain the variable value for firstTime, to indicate
%       that the forces should be saved
%   OUTPUT:
%       d: main simulation data structure
%       repeat: variable to indicate if the time step is to be repeated
%   by Aapo Tervonen, 2021

% variable to indicate that there are too large increments
repeat = false;

% if this is the first increment
if kIncrement == 1
    
    % get the substrate point coordinates
    subTemp.pointsX = d.sub.pointsX;
    subTemp.pointsY = d.sub.pointsY;
    
    % get the vectors between the pairs and "selves"
    subTemp.vectorsX = subTemp.pairsX - subTemp.selvesX;
    subTemp.vectorsY = subTemp.pairsY - subTemp.selvesY;
    
% other increments
else
    
    % if this is the second increment, get the previous increment values
    % (and divided by two)
    if kIncrement == 2
        kPrevX = d.sub.increments.k1X./2;
        kPrevY = d.sub.increments.k1Y./2;
        
    % if this is the third increment, get the previous increment values
    % (and divided by two)
    elseif kIncrement == 3
        kPrevX = d.sub.increments.k2X./2;
        kPrevY = d.sub.increments.k2Y./2;
        
    % if this is the fourth increment, get the previous increment values
    elseif kIncrement == 4
        kPrevX = d.sub.increments.k3X;
        kPrevY = d.sub.increments.k3Y;
    end
    
    % calcualte the new point coordinates
    subTemp.pointsX = d.sub.pointsX + kPrevX;
    subTemp.pointsY = d.sub.pointsY + kPrevY;
    
    % get the "selves" the central forces
    subTemp.selvesX = subTemp.selvesX + kPrevX(d.sub.interactionSelvesIdx);
    subTemp.selvesY = subTemp.selvesY + kPrevY(d.sub.interactionSelvesIdx);
    
    % get the pairs the central forces
    subTemp.pairsX = subTemp.pairsX + kPrevX(d.sub.interactionPairsIdx);
    subTemp.pairsY = subTemp.pairsY + kPrevY(d.sub.interactionPairsIdx);
    
    % get the vectors between the "selves" and the pairs
    subTemp.vectorsX = subTemp.pairsX - subTemp.selvesX;
    subTemp.vectorsY = subTemp.pairsY - subTemp.selvesY;
end

% get the central force vector lengths and their reciprocals
subTemp.vectorLengths = sqrt((subTemp.vectorsX).^2 + (subTemp.vectorsY).^2); 
subTemp.reciprocalVectorLengths = 1./subTemp.vectorLengths;

% get the central force unit vectors
subTemp.unitVectorsX = subTemp.vectorsX.*subTemp.reciprocalVectorLengths;
subTemp.unitVectorsY = subTemp.vectorsY.*subTemp.reciprocalVectorLengths;

% initialize a structure for the substrate forces
forces = initialize_substrate_forces_struct(d.sub.nPoints);

% calculate the central substrate forces
[forces.centralForcesX,forces.centralForcesY] = get_substrate_central_forces(d,subTemp);

% calculate the repulsive forces between points and line segments between
% the neighboring edges
[forces.repulsionForcesX,forces.repulsionForcesY] = get_substrate_repulsion_forces(d,subTemp);

% calculate the restorative forces
[forces.restorativeForcesX,forces.restorativeForcesY] = get_substrate_restorative_forces(d,subTemp);

% calculate the focal adhesion forces
[forces.focalAdhesionForcesX,forces.focalAdhesionForcesY] = get_substrate_focal_adhesion_forces(d,subTemp);

% calculate the total forces
forces = get_substrate_total_forces(forces);

% first increment
if kIncrement == 1
    
    % if this is the first iteration, save the substrate forces
    if numel(varargin) > 0 && varargin{1} == 1
        d.sub = save_substrate_forces(forces,d.sub);
    end
    
    % calculate the increments
    d.sub.increments.k1X = dt.*forces.totalForcesX;
    d.sub.increments.k1Y = dt.*forces.totalForcesY;
    
    % if the maximum increment is too large, return to halve the time step
    if max(d.sub.increments.k1X.^2 + d.sub.increments.k1Y.^2) >= 5*d.spar.substrateMaximumMovementSq
        repeat = true;
        return
    end
    
% second increment    
elseif kIncrement == 2
    
    % calculate the increments
    d.sub.increments.k2X = dt.*forces.totalForcesX;
    d.sub.increments.k2Y = dt.*forces.totalForcesY;
    
    % if the maximum increment is too large, return to halve the time step
    if max(d.sub.increments.k2X.^2 + d.sub.increments.k2Y.^2) >= 5*d.spar.substrateMaximumMovementSq
        repeat = true;
        return
    end
    
% third increment
elseif kIncrement == 3
    
    % calculate the increments
    d.sub.increments.k3X = dt.*forces.totalForcesX;
    d.sub.increments.k3Y = dt.*forces.totalForcesY;
    
    % if the maximum increment is too large, return to halve the time step
    if max(d.sub.increments.k3X.^2 + d.sub.increments.k3Y.^2) >= 5*d.spar.substrateMaximumMovementSq
        repeat = true;
        return
    end
    
% fourth increment
elseif kIncrement == 4
    
    % calculate the increments
    d.sub.increments.k4X = dt.*forces.totalForcesX;
    d.sub.increments.k4Y = dt.*forces.totalForcesY;
end

end