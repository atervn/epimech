function d = get_substrate_spring_constants(app,d)
% SETUP_SUBSTRATE_SPRING_CONSTANTS Define the substrate spring constants
%   The function finds the magnitudes for the substrate spring constants
%   for the three different cases of stiffness: uniform, heterogeneous, and
%   gradient. In the latter two cases, the value are defined based on the
%   predefined heterogeneous profile parameters and gradient profile.
%   INPUT:
%       app: main application object
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% initialize vectors for the restorative, central, and repulsion spring
% constants
d.sub.restorativeSpringConstants = zeros(d.sub.nPoints,1);
d.sub.centralSpringConstants = zeros(length(d.sub.interactionSelvesIdx),1);
d.sub.repulsionSpringConstants = zeros(length(d.sub.repulsionVectors1Idx),1);

% the restorative force multiplier is defined per area (in um^2) and thus
% the area of the subtrate that each point represents have to be used to
% scale it (in this case the are is the hexagon around it)
scaledRestorativeMultiplier = app.substrateParameters.restorativeForceConstant*2*sqrt(3)*(app.substrateParameters.substratePointDistance*1e6/2)^2;

% which substrate stiffness type
switch app.StiffnessstyleButtonGroup.SelectedObject.Text
    
    case 'Constant'
        
        % calculate the general substrate spring constant from Youngs
        % modulus and scale it
        if strcmp(app.simulationType,'glass')
            d.spar.fSubstrate = app.substrateParameters.youngsModulusConstant*app.substrateParameters.youngsModulus*app.systemParameters.scalingTime/app.substrateParameters.subEta;
        else
            d.spar.fSubstrate = app.substrateParameters.youngsModulusConstant*app.substrateParameters.youngsModulus*app.systemParameters.scalingTime/app.systemParameters.eta;
        end

        % calculate the restorartive spring constants
        d.sub.restorativeSpringConstants(:) = scaledRestorativeMultiplier*d.spar.fSubstrate;
        
        % calcualte the central spring constants (get a value for
        % each interaction by multiplying with the spring multipliers)
        d.sub.centralSpringConstants(:) = d.spar.fSubstrate.*d.sub.springMultipliers;
        
        % set the repulsion spring constants
        d.sub.repulsionSpringConstants(:) = d.spar.fSubstrate;
        
    case 'Heterogeneous'
        
        % calcualte the maximum substrate radius in um
        substrateRadius = ceil(1.05*sqrt(max(d.sub.pointsX.^2 + d.sub.pointsY.^2))*app.systemParameters.scalingLength*1e6);
        
        % generate random heterogeneous profile based on the parameter
        % defined in the GUI or in the heterogeneous files, the resolution
        % is so that the stiffness values are defined in a grid with 1 um
        % distance between points
        [gridValue,substrateGridX,substrateGridY] = rsgeng2D(2*substrateRadius,2*substrateRadius,app.heterogeneousStiffness(3),app.heterogeneousStiffness(1),app.heterogeneousStiffness(2));
        
        % scale the grid coordinates with the scaling length
        substrateGridX = substrateGridX.*1e-6/app.systemParameters.scalingLength;
        substrateGridY = substrateGridY.*1e-6/app.systemParameters.scalingLength;
        
        % create a meshgrid from the grid coordinates
        [substrateGridX, substrateGridY] = meshgrid(substrateGridX,substrateGridY);
        
        % if the heterogeneous profile is rotated with some nonzero angle
        if app.heterogeneousStiffness(4) ~= 0
            
            % rorate the coordinates with the defined angle using rotation
            % matrix
            rotatedCoordinates = [cosd(-app.heterogeneousStiffness(4)) -sind(-app.heterogeneousStiffness(4)) ; sind(-app.heterogeneousStiffness(4)) cosd(-app.heterogeneousStiffness(4))]*[substrateGridX(:)' ; substrateGridY(:)'];
            
            % get the rotated coordinates
            substrateGridX = rotatedCoordinates(1,:)';
            substrateGridY = rotatedCoordinates(2,:)';
        end

        % calculate the stiffness by summing the mean radius with the
        % variability provided by the grid
        gridStiffness = app.substrateParameters.youngsModulus + gridValue.*1000;
        
        % set stiffness below 500 Pa to 500 Pa
        gridStiffness(gridStiffness < 500) = 500;
        
        % calculate the general substrate spring at the grid points and
        % scale it
        gridfSubstrate = app.substrateParameters.youngsModulusConstant*gridStiffness*app.systemParameters.scalingTime/app.systemParameters.eta;
        
        % interpolate the stiffness data from the grid to the substrate
        % points
        pointSpringConstants = griddata(substrateGridX(:),substrateGridY(:),gridfSubstrate(:),d.sub.pointsX, d.sub.pointsY);
        
        % calculate the restorative spring constants for each points
        d.sub.restorativeSpringConstants = pointSpringConstants.*scaledRestorativeMultiplier;
        
        % get the spring constants for both the selves and pairs of each
        % interactions
        selfConstants = pointSpringConstants(d.sub.interactionSelvesIdx);
        pairConstants = pointSpringConstants(d.sub.interactionPairsIdx);
        
        % calculate the central spring constants as the combination fo the
        % of the two stiffness and the honeycomb multiplier
        d.sub.centralSpringConstants = d.sub.springMultipliers.*(1./(2.*selfConstants) + 1./(2.*pairConstants)).^-1;
        
        % get the repulsion spring constants
        d.sub.repulsionSpringConstants = pointSpringConstants(d.sub.interactionSelvesIdx(d.sub.repulsionVectors1Idx));
        
    case 'Gradient'
        
        % calculate the base substrate spring constants and scacle them
        fSubstrateGradientValues = app.substrateParameters.youngsModulusConstant.*app.stiffnessGradientInformation(:,2).*1000.*app.systemParameters.scalingTime./app.systemParameters.eta;
        
        % find the smallest fSubstrate value and relative value for each
        % value compared to this base
        basefSubstrate = min(fSubstrateGradientValues);
        baseMultipliers = fSubstrateGradientValues./basefSubstrate;

        % calculate the maximum substrate radius
        substrateRadius = 1.05*sqrt(max(d.sub.pointsX.^2 + d.sub.pointsY.^2));
        
        % create a square meshgrid with the point separation of half of the
        % substrate point distance 
        [substrateGridX, substrateGridY] = meshgrid(-substrateRadius:d.spar.substratePointDistance/2:substrateRadius+d.spar.substratePointDistance/2,-substrateRadius:d.spar.substratePointDistance/2:substrateRadius+d.spar.substratePointDistance/2);

        % scale the positions where the gradient changes
        gradientPositions = app.stiffnessGradientInformation(:,1).*1e-6/app.systemParameters.scalingLength;
        
        % interpolate the baseMultipliers from the line into the full grid
        % based on the scaled gradientPositions
        multipliers = arrayfun(@(position) get_gradient_multiplier(position,baseMultipliers,gradientPositions), substrateGridY);
        
        % if the gradient profile is rotated with some nonzero angle
        if app.stiffnessGradientInformation(1,3) ~= 0
            
            % rorate the coordinates with the defined angle using rotation
            % matrix
            rotatedCoordinates = [cosd(-app.stiffnessGradientInformation(3,1)) -sind(-app.stiffnessGradientInformation(3,1)) ; sind(-app.stiffnessGradientInformation(3,1)) cosd(-app.stiffnessGradientInformation(3,1))]*[substrateGridX(:)' ; substrateGridY(:)'];
            
            % get the rotated coordinates
            substrateGridX = rotatedCoordinates(1,:)';
            substrateGridY = rotatedCoordinates(2,:)';
        end
        
        % interpolate the multiplier data from the grid to the substrate
        % points
        multipliers = griddata(substrateGridX(:),substrateGridY(:),multipliers(:),d.sub.pointsX, d.sub.pointsY);
        
        % calculate the fSubstrate values in each substrate point
        pointSpringConstants = multipliers.*basefSubstrate;
        
        % calculate the restorative spring constants for each points
        d.sub.restorativeSpringConstants = pointSpringConstants.*scaledRestorativeMultiplier;
        
        % get the spring constants for both the selves and pairs of each
        % interactions
        selfConstants = pointSpringConstants(d.sub.interactionSelvesIdx);
        pairConstants = pointSpringConstants(d.sub.interactionPairsIdx);
        
        % calculate the central spring constants as the combination fo the
        % of the two stiffness and the honeycomb multiplier
        d.sub.centralSpringConstants = d.sub.springMultipliers.*(1./(2.*selfConstants) + 1./(2.*pairConstants)).^-1;
        
        % get the repulsion spring constants
        d.sub.repulsionSpringConstants = pointSpringConstants(d.sub.interactionSelvesIdx(d.sub.repulsionVectors1Idx));
end

end

function multiplier = get_gradient_multiplier(position,baseMultipliers,gradientPositions)
% GET_GRADIENT_MULTIPLIER Obtain gradient stiffness multipliers for the
% grid
%   The function interpolates the data from the gradient change positions
%   to the grid points based on their y-coordinates.
%   INPUT:
%       positions: y-coordinate of a grid point
%       baseMultipliers: relative stiffness multipliers for each stiffness
%           value at the gradientPositions
%       gradientPositions: y-coordinates where there are changes in the
%           stiffness gradient
%   OUTPUT:
%       multiplier: stiffness multiplier at each grid point
%   by Aapo Tervonen, 2021

% if there is only on gridposition (i.e. the substrate is uniform)
if length(gradientPositions) == 1
    
    % set the only multiplier for all points
    multiplier = baseMultipliers(1);
    
% otherwise
else
    
    % if the grid point coordinate is smaller than any of the gradient
    % positions
    if position <= gradientPositions(1)
        
        % set the multiplier as the first stiffness value given
        multiplier = baseMultipliers(1);
        
    % if the grid point coordinate is larger than any of the gradient
    % positions
    elseif position >= gradientPositions(end)
        
        % set the multiplier as the last stiffness value given
        multiplier = baseMultipliers(end);
        
    % otherwise
    else
        
        % go through the pairs of two consequtive stiffness positions
        for i = 1:length(gradientPositions)-1
            
            % if the grid point is between the consequtive points
            if  position > gradientPositions(i) && position <= gradientPositions(i+1)
                
                % linearly interpolate the stiffness multiplier and return
                multiplier = (baseMultipliers(i+1) - baseMultipliers(i))/(gradientPositions(i+1) - gradientPositions(i)).*(position - gradientPositions(i)) + baseMultipliers(i);
                return
            end
        end
    end
end

end