function [focalAdhesionForcesX,focalAdhesionForcesY] = get_substrate_focal_adhesion_forces(d,subTemp)
% GET_SUBSTRATE_FOCAL_ADHESION_FORCES Calculate the substrate focal
% adhesion forces
%   The function calculates the focal adhesion forces between the substrate
%   points and the cell vertices
%   INPUTS:
%       d: main simulation data structure
%       subTemp: temporary structure that contains the substrate and cell
%       data used in the calculations
%   OUTPUT:
%       focalAdhesionForcesX: x-components of the focal adhesion forces
%       focalAdhesionForcesY: y-components of the focal adhesion forces
%   by Aapo Tervonen, 2021

% initialize empty matrices for the focal adhesion forces (number of lines
% equals to the number of substrate points and the number rows to the
% maximum number of focal adhesion connection that there for a substrate
% point
focalAdhesionForcesX = zeros(d.sub.nPoints,max(d.sub.adhesionNumbers));
focalAdhesionForcesY = focalAdhesionForcesX;

% go through the cells
for k = 1:length(subTemp.verticesX)

    % get the coordinates of the three closest substrate points for each
    % cell vertex that has a focal adhesion (in a vector)
    substrateX = subTemp.pointsX(subTemp.pointsLin{k});
    substrateY = subTemp.pointsY(subTemp.pointsLin{k});
    
    % based on the the weigths for each substrate point in each focal
    % adhesion, calculate the actual adhesion points for each focal
    % adhesion in cell k (multiply the substrate coordinate and the weight
    % vectors, reshape so that one row corresponds to each cell vertex and
    % columns to the weighted substrate points, and sum over columns)
    adhesionPointsX = sum(reshape(substrateX.*subTemp.weightsLin{k},[],3),2);
    adhesionPointsY = sum(reshape(substrateY.*subTemp.weightsLin{k},[],3),2);

    % calculate the focal adhesion forces between the adhesion point and
    % the cell vertices (including the focal adhesion strength which may be
    % vertex-dependent)
    forcesX = -subTemp.fFocalAdhesions{k}.*(adhesionPointsX - subTemp.verticesX{k});
    forcesY = -subTemp.fFocalAdhesions{k}.*(adhesionPointsY - subTemp.verticesY{k});

    % calculate how much of these forces affect each substrate point based
    % on the weights and assign the forces into the focalAdhesionForces
    % matrices to the correct substrate points based on the linear
    % coordinates 
    focalAdhesionForcesX(subTemp.matrixIdx{k}) = repmat(forcesX,3,1).*subTemp.weightsLin{k};
    focalAdhesionForcesY(subTemp.matrixIdx{k}) = repmat(forcesY,3,1).*subTemp.weightsLin{k};
end

% sum over the columns to obtain the total focal adhesion force components
focalAdhesionForcesX = sum(focalAdhesionForcesX,2);
focalAdhesionForcesY = sum(focalAdhesionForcesY,2);

end