function app = setup_parameter_study(data,app,iLoop)
% SETUP_PARAMETER_STUDY Setup the parameter study
%   The function sets the parameter values for the parameter study by
%   either replacing the default parameter or multiplying it based on the
%   defined settings. Also, the function checks that the new value fulfills
%   the requirements for the parameter.
%   INPUT:
%       data: structure to collect config file data
%       app: the application structure replication the properties of the
%           GUI app
%       iLoop: current simulation index
%   OUTPUT:
%       app: the application structure replication the properties of the
%           GUI app
%   by Aapo Tervonen, 2021

% if the studied parameter is a system parameter
if strcmp(data.parameterStudy.type,'system')
    
    % if the study operation is equal, set the parameter value from the
    % defined values
    if strcmp(data.parameterStudy.operation,'equal')
        app.systemParameters.(data.parameterStudy.parameter) = data.parameterStudy.values(iLoop);
        
    % if the study operation is multiply, multiply the selected parameter
    % with the defined multiplier
    elseif strcmp(data.parameterStudy.operation,'multiply')
        app.systemParameters.(data.parameterStudy.parameter) = app.systemParameters.(data.parameterStudy.parameter)*data.parameterStudy.values(iLoop);
    end
    
    % get the new value for the parameter
    value = app.systemParameters.(data.parameterStudy.parameter);
    
    % check that the new parameter fulfills the requirements for the
    % parameter in question, and if not, give error and return
    switch data.parameterStudy.parameter
        case 'eta'
            if isnan(value)
                disp('Parameter study: eta must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: eta must have a value above zero.'); app = 0; return
            end
        case 'scalingLength'
            if isnan(value)
                disp('Parameter study: scalingLength must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: scalingLength must have a value above zero.'); app = 0; return
            end
        case 'scalingTime'
            if isnan(value)
                disp('Parameter study: scalingTime must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: scalingTime must have a value above zero.'); app = 0; return
            end
        case 'stopDivisionTime'
            if isnan(value)
                disp('Parameter study: stopDivisionTime must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: stopDivisionTime must have a value above zero.'); app = 0; return
            end
        case 'cellMaximumMovement'
            if isnan(value)
                disp('Parameter study: cellMaximumMovement must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: cellMaximumMovement must have a value above zero.'); app = 0; return
            end
        case 'cellMinimumMovement'
            if isnan(value)
                disp('Parameter study: cellMinimumMovement must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: cellMinimumMovement must have a value above zero.'); app = 0; return
            end
        case 'junctionModificationTimeStep'
            if isnan(value)
                disp('Parameter study: junctionModificationTimeStep must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: junctionModificationTimeStep must have a value above zero.'); app = 0; return
            end
        case 'substrateMaximumMovement'
            if isnan(value)
                disp('Parameter study: substrateMaximumMovement must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: substrateMaximumMovement must have a value above zero.'); app = 0; return
            end
        case 'substrateMinimumMovement'
            if isnan(value)
                disp('Parameter study: substrateMinimumMovement must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: substrateMinimumMovement must have a value above zero.'); app = 0; return
            end
        case 'fullActivationConstant'
            if isnan(value)
                disp('Parameter study: fullActivationConstant must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: fullActivationConstant must have a value above zero.'); app = 0; return
            end
        case 'fPointlike'
            if isnan(value)
                disp('Parameter study: fPointlike must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: fPointlike must have a value above zero.'); app = 0; return
            end
    end
    
% if the studied parameter is a basic cell parameter
elseif strcmp(data.parameterStudy.type,'cell')
    
    % if the study operation is equal, set the parameter value from the
    % defined values
    if strcmp(data.parameterStudy.operation,'equal')
        app.cellParameters.(data.parameterStudy.parameter) = data.parameterStudy.values(iLoop);
        
    % if the study operation is multiply, multiply the selected parameter
    % with the defined multiplier
    elseif strcmp(data.parameterStudy.operation,'multiply')
        app.cellParameters.(data.parameterStudy.parameter) = app.cellParameters.(data.parameterStudy.parameter)*data.parameterStudy.values(iLoop);
    end
    
    % get the new value for the parameter
    value = app.cellParameters.(data.parameterStudy.parameter);
    
    % check that the new parameter fulfills the requirements for the
    % parameter in question, and if not, give error and return
    switch data.parameterStudy.parameter
        case 'rCell'
            if ~isnumeric(value)
                disp('Parameter study: rCell must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: rCell must have a value above zero.'); app = 0; return
            end
        case 'membraneLength'
            if ~isnumeric(value)
                disp('Parameter study: membraneLength must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: membraneLength must have a value above zero.'); app = 0; return
            end
        case 'junctionLength'
            if ~isnumeric(value)
                disp('Parameter study: junctionLength must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: junctionLength must have a value above zero.'); app = 0; return
            end
        case 'fArea'
            if ~isnumeric(value)
                disp('Parameter study: fArea must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: fArea must have a value above zero.'); app = 0; return
            end
        case 'fCortex'
            if ~isnumeric(value)
                disp('Parameter study: fCortex must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: fCortex must have a value above zero.'); app = 0; return
            end
        case 'fJunctions'
            if ~isnumeric(value)
                disp('Parameter study: fJunctions must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: fJunctions must have a value above zero.'); app = 0; return
            end
        case 'fContact'
            if ~isnumeric(value)
                disp('Parameter study: fContact must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: fContact must have a value above zero.'); app = 0; return
            end
        case 'perimeterModelingRate'
            if ~isnumeric(value)
                disp('Parameter study: perimeterModelingRate must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: perimeterModelingRate must have a value above zero.'); app = 0; return
            end
        case 'minimumCellSize'
            if ~isnumeric(value)
                disp('Parameter study: minimumCellSize must be numeric.'); app = 0; return
            elseif value < 0
                disp('Parameter study: minimumCellSize must have a nonnegative value.'); app = 0; return
            end
    end

% if the studied parameter is a specific cell parameter
elseif strcmp(data.parameterStudy.type,'specific')
    
    % if the study operation is equal, set the parameter value from the
    % defined values
    if strcmp(data.parameterStudy.operation,'equal')
        app.specificCellParameters.(data.parameterStudy.parameter) = data.parameterStudy.values(iLoop);
        
    % if the study operation is multiply, multiply the selected parameter
    % with the defined multiplier
    elseif strcmp(data.parameterStudy.operation,'multiply')
        app.specificCellParameters.(data.parameterStudy.parameter) = app.cellParameters.(data.parameterStudy.parameter)*data.parameterStudy.values(iLoop);
    end
    
    % get the new value for the parameter
    value = app.specificCellParameters.(data.parameterStudy.parameter);
    
    % check that the new parameter fulfills the requirements for the
    % parameter in question, and if not, give error and return
    switch data.parameterStudy.parameter
        case 'fMembrane'
            if ~isnumeric(value)
                disp('Parameter study: fMembrane must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: fMembrane must have a value above zero.'); app = 0; return
            end
        case 'fDivision'
            if ~isnumeric(value)
                disp('Parameter study: fDivision must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: fDivision must have a value above zero.'); app = 0; return
            end
        case 'divisionTimeMean'
            if ~isnumeric(value)
                disp('Parameter study: divisionTimeMean must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: divisionTimeMean must have a value above zero.'); app = 0; return
            end
        case 'divisionTimeSD'
            if ~isnumeric(value)
                disp('Parameter study: divisionTimeSD must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: divisionTimeSD must have a value above zero.'); app = 0; return
            end
        case 'divisionDistanceConstant'
            if ~isnumeric(value)
                disp('Parameter study: divisionDistanceConstant must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: divisionDistanceConstant must have a value above zero.'); app = 0; return
            end
        case 'newCellAreaConstant'
            if ~isnumeric(value)
                disp('Parameter study: newCellAreaConstant must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: newCellAreaConstant must have a value above zero.'); app = 0; return
            end
        case 'cellGrowthConstant'
            if ~isnumeric(value)
                disp('Parameter study: cellGrowthConstant must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: cellGrowthConstant must have a value above zero.'); app = 0; return
            end
        case 'cellGrowthForceConstant'
            if ~isnumeric(value)
                disp('Parameter study: cellGrowthForceConstant must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: cellGrowthForceConstant must have a value above zero.'); app = 0; return
            end
        case 'baseDivisionRate'
            if ~isnumeric(value)
                disp('Parameter study: baseDivisionRate must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: baseDivisionRate must have a value above zero.'); app = 0; return
            end
        case 'divisionRateExponents'
            if ~isnumeric(value)
                disp('Parameter study: divisionRateExponents must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: divisionRateExponents must have a value above zero.'); app = 0; return
            end
        case 'fEdgeCell'
            if ~isnumeric(value)
                disp('Parameter study: fEdgeCell must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: fEdgeCell must have a value above zero.'); app = 0; return
            end
        case 'maxMembraneAngle'
            if ~isnumeric(value)
                disp('Parameter study: maxMembraneAngle must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: maxMembraneAngle must have a value above zero.'); app = 0; return
            elseif value > 3.14
                disp('Parameter study: maxMembraneAngle must be below pi.'); app = 0; return
            end
        case 'maxJunctionAngleConstant'
            if ~isnumeric(value)
                disp('Parameter study: maxJunctionAngleConstant must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: maxJunctionAngleConstant must have a value above zero.'); app = 0; return
            elseif value > 1
                disp('Parameter study: maxJunctionAngleConstant must have a value below one.'); app = 0; return
            end
        case 'focalAdhesionBreakingForce'
            if ~isnumeric(value)
                disp('Parameter study: focalAdhesionBreakingForce must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: focalAdhesionBreakingForce must have a value above zero.'); app = 0; return
            end
        case 'maximumGrowthTime'
            if ~isnumeric(value)
                disp('Parameter study: maximumGrowthTime must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: maximumGrowthTime must have a value above zero.'); app = 0; return
            end
        case 'maximumDivisionTime'
            if ~isnumeric(value)
                disp('Parameter study: maximumDivisionTime must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: maximumDivisionTime must have a value above zero.'); app = 0; return
            end
    end

% if the studied parameter is a substrate parameter    
elseif strcmp(data.parameterStudy.type,'substrate')
    
    % if the study operation is equal, set the parameter value from the
    % defined values
    if strcmp(data.parameterStudy.operation,'equal')
        app.substrateParameters.(data.parameterStudy.parameter) = data.parameterStudy.values(iLoop);
        
    % if the study operation is multiply, multiply the selected parameter
    % with the defined multiplier
    elseif strcmp(data.parameterStudy.operation,'multiply')
        app.substrateParameters.(data.parameterStudy.parameter) = app.substrateParameters.(data.parameterStudy.parameter)*data.parameterStudy.values(iLoop);
    end
    
    % get the new value for the parameter
    value = app.substrateParameters.(data.parameterStudy.parameter);
    
    % check that the new parameter fulfills the requirements for the
    % parameter in question, and if not, give error and return
    switch data.parameterStudy.parameter
        case 'substratePointDistance'
            if ~isnumeric(value)
                disp('Parameter study: substratePointDistance must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: substratePointDistance must have a value above zero.'); app = 0; return
            end
        case 'youngsModulus'
            if ~isnumeric(value)
                disp('Parameter study: youngsModulus must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: youngsModulus must have a value above zero.'); app = 0; return
            end
        case 'youngsModulusConstant'
            if ~isnumeric(value)
                disp('Parameter study: youngsModulusConstant must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: youngsModulusConstant must have a value above zero.'); app = 0; return
            end
        case 'restorativeForceConstant'
            if ~isnumeric(value)
                disp('Parameter study: restorativeForceConstant must be numeric.'); app = 0; return
            elseif value <= 0
                disp('Parameter study: restorativeForceConstant must have a value above zero.'); app = 0; return
            end
        case 'repulsionLengthMultiplier'
            if ~isnumeric(value)
                disp('Parameter study: repulsionLengthMultiplier must be numeric.'); app = 0; return
            elseif value <= 0 || value > 1
                disp('Parameter study: repulsionLengthMultiplier must have a value between 0 and 1.'); app = 0; return
            end
        case 'honeycombConstants'
            if ~isnumeric(value)
                disp('Parameter study: honeycombConstants must be numeric.'); app = 0; return
            elseif value < 100 || value > 999
                disp('Parameter study: honeycombConstants must be a three digit number.'); app = 0; return
            end
        case 'substrateEdgeConstant'
            if ~isnumeric(value)
                disp('Parameter study: substrateEdgeConstant must be numeric.'); app = 0; return
            elseif value < 0
                disp('Parameter study: substrateEdgeConstant must have a nonnegative value.'); app = 0; return
            end    
    end
end

end