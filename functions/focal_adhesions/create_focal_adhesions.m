function [d, ok] = create_focal_adhesions(app,d)
% CREATE_FOCAL_ADHESIONS Create focal adhesions for the cell vertices
%   The function defined the focal adhesions for each cell. The focal
%   adhesion attachment point in defined with baryocentric coordinates
%   based on the three closest substrate points. The focal adhesion
%   strength value depends on the local stiffness at the attachment
%   positions. For gradient and heterogeneous susbtrates, the Youngs
%   modulus is calculated as the weighted average of the closest points.
%   INPUT:
%       app: main application object
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% initialize a vector to indicate how many focal adhesions interact with
% each substrate point
d.sub.adhesionNumbers = zeros(d.sub.nPoints,1);

% variable to indicate possible problems in the focal adhesion creation
ok = 1;

% calculate a variable that can be used to descale the restorative spring
% constant to obtain the Youngs modulus at that point (thus basically do
% the opposite to what was done in get_substrate_spring_constants function
% to obtain the restorative spring constants. The restorative constants are
% used to get the moduli since they depend purely on the position of the
% point itself, not any interactions.
springScaling = 1/app.substrateParameters.youngsModulusConstant/app.systemParameters.scalingTime*app.systemParameters.eta/(app.substrateParameters.restorativeForceConstant*2*sqrt(3)*(app.substrateParameters.substratePointDistance*1e6/2)^2);

% go through the cells
for k = 1:length(d.cells)
    
    % initialize vectors to store three substrate points for each cell
    % vertex and the columns in a matrix that is used to calculate the
    % focal adhesion forces for the substrate during simulation
    focalAdhesionPoints = zeros(d.cells(k).nVertices,3);
    adhesionLinkCols = zeros(d.cells(k).nVertices,3);
    
    % go through the vertices
    for i = 1:d.cells(k).nVertices
        
        % find the indices of the three closest susbtrate points
        [~, focalAdhesionPoints(i,:)] = mink((d.cells(k).verticesX(i) - d.sub.pointsX).^2 + (d.cells(k).verticesY(i) - d.sub.pointsY).^2,3);
        
        % increase the adhesion numbers for these three points
        d.sub.adhesionNumbers(focalAdhesionPoints(i,:)) = d.sub.adhesionNumbers(focalAdhesionPoints(i,:)) + 1;
        
        % save these indices as the column indices for the vertices
        adhesionLinkCols(i,:) = d.sub.adhesionNumbers(focalAdhesionPoints(i,:))';
    end
    
    % get the substrate point coordinates for the the closest points for
    % the vertices
    pointXs = d.sub.pointsX(focalAdhesionPoints(:));
    pointYs = d.sub.pointsY(focalAdhesionPoints(:));
    
    % reshape the the vectors into matrices so that they have a size of
    % nVertices-by-3
    pointXs = reshape(pointXs,[],3);
    pointYs = reshape(pointYs,[],3);
    
    % calculate the baryocentric weights for each substrate point based on
    % the position of the vertex in the triangle formed by the three
    % closest substrate points
    W1 = ((pointYs(:,2) - pointYs(:,3)).*(d.cells(k).verticesX - pointXs(:,3)) + (pointXs(:,3) - pointXs(:,2)).*(d.cells(k).verticesY - pointYs(:,3)))./...
        ((pointYs(:,2) - pointYs(:,3)).*(pointXs(:,1) - pointXs(:,3)) + (pointXs(:,3) - pointXs(:,2)).*(pointYs(:,1) - pointYs(:,3)));
    W2 = ((pointYs(:,3) - pointYs(:,1)).*(d.cells(k).verticesX - pointXs(:,3)) + (pointXs(:,1) - pointXs(:,3)).*(d.cells(k).verticesY - pointYs(:,3)))./...
        ((pointYs(:,2) - pointYs(:,3)).*(pointXs(:,1) - pointXs(:,3)) + (pointXs(:,3) - pointXs(:,2)).*(pointYs(:,1) - pointYs(:,3)));
    W3 = 1 - W1 - W2;
    
    % if any of the weights is NaN, stop and return (this results from the
    % case that the vertex is not within the triangle formed by the three
    % substrate points, i.e. the vertex is outside the substrate area. This
    % occurs if the multiplier used to expand the cells when removing
    % substrate points is too low, and thus it is increased and the process
    % starts from the beginning)
    if any(isnan([W1 W2 W3]))
        ok = 0;
        return;
    end
    
    % save the closest points in a nVertices-by-3 matrix
    d.cells(k).substrate.points = focalAdhesionPoints;
    
    % save the closest points in a vector with the length of 3*nVertices
    d.cells(k).substrate.pointsLin = focalAdhesionPoints(:);
    
    % save the closest point weigths in a nVertices-by-3 matrix
    d.cells(k).substrate.weights = [W1 W2 W3];
    
    % save the closest point weights in a vector with the length of 3*nVertices
    d.cells(k).substrate.weightsLin = d.cells(k).substrate.weights(:);
    
    % save the adhesion column data (needed to get the matrixIdx)
    d.cells(k).substrate.linkCols = adhesionLinkCols;
    
    % get the linear index of each interaction between the vertices and the
    % points in the matrix used to calculate the focal adhesion forces for
    % the substrate
    d.cells(k).substrate.matrixIdx = sub2ind([d.sub.nPoints 200],d.cells(k).substrate.pointsLin,d.cells(k).substrate.linkCols(:));
    
    % logical vector to indicate that all vertices have focal adhesions
    d.cells(k).substrate.connected = true(d.cells(k).nVertices,1);

    % if this is a stretch simulation
    if d.simset.simulationType == 3
        
        % the substrate stiffness is considered to be much higher than what
        % is considered e.g. in pointlike measurements, so 100000 is used
        % to get the focal adhesions strengths for the cell vertices
        d.cells(k).substrate.fFocalAdhesions = get_individual_fFAs(100000,app.fFAInfo,app.systemParameters,app.cellParameters);
        
    % if substrte with constant stiffness
    elseif strcmp(app.StiffnessstyleButtonGroup.SelectedObject.Text,'Constant')
        
        % calculate the Young's modulus from the restorative force
        % constants with the scaling factor defined before
        pointYoungs = d.sub.restorativeSpringConstants.*springScaling;
        
        % get the focal adhesion strength based on the stiffness
        d.cells(k).substrate.fFocalAdhesions = get_individual_fFAs(pointYoungs(1),app.fFAInfo,app.systemParameters,app.cellParameters);
    else
        
        % calculate the Young's modulus from the restorative force
        % constants with the scaling factor defined before (each point has
        % its own value)
        pointYoungs = d.sub.restorativeSpringConstants.*springScaling;
        
        % get the Youngs moduli for each vertex based on the baryocentric
        % weights
        FAYoungs = sum(pointYoungs(d.cells(k).substrate.points).*d.cells(k).substrate.weights,2);
        
        % get the focal adhesion strength based on the stiffness at each
        % vertex position
        d.cells(k).substrate.fFocalAdhesions = arrayfun(@(FAYoungs) get_individual_fFAs(FAYoungs,app.fFAInfo,app.systemParameters,app.cellParameters), FAYoungs);
    end
end

end

function fFocalAdhesion = get_individual_fFAs(vertexYoung,fFAInfo,systemParameters,cellParameters)
% GET_INDIVIDUAL_FFAS Calcualte the focal adhesion strentghs for vertices
%   The function calculates the focal adhesion strength for a vertex based
%   on the local Youngs modulus and the predefined piecewise function
%   between the strength and the Youngs modulus
%   INPUT:
%       vertexYoung: Youngs modulus at the vertex position
%       fFAInfo: matrix with the FA strengths and corresponding Youngs
%           moduli
%       d: main simulation data structure
%       systemParameters: unscaled system parameters
%       cellParameters: unscaled cell parameters
%   OUTPUT:
%       fFocalAdhesion: focal adhesion strength
%   by Aapo Tervonen, 2021

% if the modulus at the vertex is lower than the smallest value given in
% fFAInfo
if vertexYoung <= fFAInfo(1,1)
    
    % set the fFocalAdhesion corresponding to the lowest modulus
    fFATemp = fFAInfo(1,2);
    
% if the modulus at the vertex is higher than the largest value given in
% fFAInfo
elseif vertexYoung >= fFAInfo(end,1)
    
    % set the fFocalAdhesion corresponding to the highest modulus
    fFATemp = fFAInfo(end,2);
    
% otherwise
else
    
    % go through two consequtive moduli in the matrix
    for i = 1:size(fFAInfo,1)-1
        
        % if the vertex moduli is between the consequtive moduli
        if (vertexYoung >= fFAInfo(i,1)) && (vertexYoung <= fFAInfo(i+1,1))
            
            % linearly interpolate the get the focal adhesion strength
            fFATemp = (fFAInfo(i+1,2) - fFAInfo(i,2))/(fFAInfo(i+1,1) - fFAInfo(i,1)).*(vertexYoung - fFAInfo(i,1)) + fFAInfo(i,2);
            break;
        end
    end
end

% scaling at the end to take into account that the FA strength values are
% defined per um of membrane (membraneLength scaled to um instead of m)
fFocalAdhesion = fFATemp*systemParameters.scalingTime/systemParameters.eta*cellParameters.membraneLength/1e-6;

end