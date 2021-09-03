function [app, stop] = setup_parameter_study(data,app,iLoop)

stop = false;

if strcmp(data.parameterStudy.type,'system')
    if strcmp(data.parameterStudy.operation,'equal')
        app.systemParameters.(data.parameterStudy.parameter) = data.parameterStudy.values(iLoop);
    elseif strcmp(data.parameterStudy.operation,'multiply')
        app.systemParameters.(data.parameterStudy.parameter) = app.systemParameters.(data.parameterStudy.parameter)*data.parameterStudy.values(iLoop);
    end
    
    value = app.systemParameters.(data.parameterStudy.parameter);
    
    switch data.parameterStudy.parameter
        case 'eta'
            if isnan(value)
                disp('eta must be numeric.')
            elseif value <= 0
                disp('eta must have a value above zero.');
                stop = true;
            end
        case 'scalingLength'
            if isnan(value)
                disp('scalingLength must be numeric.')
                stop = true;
            elseif value <= 0
                disp('scalingLength must have a value above zero.');
                stop = true;
            end
        case 'scalingTime'
            if isnan(value)
                disp('scalingTime must be numeric.')
                stop = true;
            elseif value <= 0
                disp('scalingTime must have a value above zero.');
                stop = true;
            end
        case 'stopDivisionTime'
            if isnan(value)
                disp('stopDivisionTime must be numeric.')
                stop = true;
            elseif value <= 0
                disp('stopDivisionTime must have a value above zero.');
                stop = true;
            end
        case 'cellMaximumMovement'
            if isnan(value)
                disp('cellMaximumMovement must be numeric.')
                stop = true;
            elseif value <= 0
                disp('cellMaximumMovement must have a value above zero.');
                stop = true;
            end
        case 'cellMinimumMovement'
            if isnan(value)
                disp('cellMinimumMovement must be numeric.')
                stop = true;
            elseif value <= 0
                disp('cellMinimumMovement must have a value above zero.');
                stop = true;
            end
        case 'junctionModificationTimeStep'
            if isnan(value)
                disp('junctionModificationTimeStep must be numeric.')
                stop = true;
            elseif value <= 0
                disp('junctionModificationTimeStep must have a value above zero.');
                stop = true;
            end
        case 'substrateMaximumMovement'
            if isnan(value)
                disp('substrateMaximumMovement must be numeric.')
                stop = true;
            elseif value <= 0
                disp('substrateMaximumMovement must have a value above zero.');
                stop = true;
            end
        case 'substrateMinimumMovement'
            if isnan(value)
                disp('substrateMinimumMovement must be numeric.')
                stop = true;
            elseif value <= 0
                disp('substrateMinimumMovement must have a value above zero.');
                stop = true;
            end
        case 'fullActivationConstant'
            if isnan(value)
                disp('fullActivationConstant must be numeric.')
                stop = true;
            elseif value <= 0
                disp('fullActivationConstant must have a value above zero.');
                stop = true;
            end
        case 'fPointlike'
            if isnan(value)
                disp('fPointlike must be numeric.')
                stop = true;
            elseif value <= 0
                disp('fPointlike must have a value above zero.');
                stop = true;
            end
    end
    
elseif strcmp(data.parameterStudy.type,'cell')
    if strcmp(data.parameterStudy.operation,'equal')
        app.cellParameters.(data.parameterStudy.parameter) = data.parameterStudy.values(iLoop);
    elseif strcmp(data.parameterStudy.operation,'multiply')
        app.cellParameters.(data.parameterStudy.parameter) = app.cellParameters.(data.parameterStudy.parameter)*data.parameterStudy.values(iLoop);
    end
    
    value = app.cellParameters.(data.parameterStudy.parameter);
    
    switch data.parameterStudy.parameter
        case 'rCell'
            if ~isnumeric(value)
                disp('rCell must be numeric.')
                stop = true;
            elseif value <= 0
                disp('rCell must have a value above zero.')
                stop = true;
            end
        case 'membraneLength'
            if ~isnumeric(value)
                disp('membraneLength must be numeric.')
                stop = true;
            elseif value <= 0
                disp('membraneLength must have a value above zero.')
                stop = true;
            end
        case 'junctionLength'
            if ~isnumeric(value)
                disp('junctionLength must be numeric.')
                stop = true;
            elseif value <= 0
                disp('junctionLength must have a value above zero.')
                stop = true;
            end
        case 'fArea'
            if ~isnumeric(value)
                disp('fArea must be numeric.')
                stop = true;
            elseif value <= 0
                disp('fArea must have a value above zero.')
                stop = true;
            end
        case 'fCortex'
            if ~isnumeric(value)
                disp('fCortex must be numeric.')
                stop = true;
            elseif value <= 0
                disp('fCortex must have a value above zero.')
                stop = true;
            end
        case 'fJunctions'
            if ~isnumeric(value)
                disp('fJunctions must be numeric.')
                stop = true;
            elseif value <= 0
                disp('fJunctions must have a value above zero.')
                stop = true;
            end
        case 'fContact'
            if ~isnumeric(value)
                disp('fContact must be numeric.')
                stop = true;
            elseif value <= 0
                disp('fContact must have a value above zero.')
                stop = true;
            end
        case 'perimeterModelingRate'
            if ~isnumeric(value)
                disp('perimeterModelingRate must be numeric.')
                stop = true;
            elseif value <= 0
                disp('perimeterModelingRate must have a value above zero.')
                stop = true;
            end
    end

elseif strcmp(data.parameterStudy.type,'specific')
    if strcmp(data.parameterStudy.operation,'equal')
        app.specificCellParameters.(data.parameterStudy.parameter) = data.parameterStudy.values(iLoop);
    elseif strcmp(data.parameterStudy.operation,'multiply')
        app.specificCellParameters.(data.parameterStudy.parameter) = app.cellParameters.(data.parameterStudy.parameter)*data.parameterStudy.values(iLoop);
    end
    
    value = app.specificCellParameters.(data.parameterStudy.parameter);
    
    switch data.parameterStudy.parameter
        case 'fMembrane'
            if ~isnumeric(value)
                disp('fMembrane must be numeric.')
                stop = true;
            elseif value <= 0
                disp('fMembrane must have a value above zero.')
                stop = true;
            end
        case 'fDivision'
            if ~isnumeric(value)
                disp('fDivision must be numeric.')
                stop = true;
            elseif value <= 0
                disp('fDivision must have a value above zero.')
                stop = true;
            end
        case 'divisionTimeMean'
            if ~isnumeric(value)
                disp('divisionTimeMean must be numeric.')
                stop = true;
            elseif value <= 0
                disp('divisionTimeMean must have a value above zero.')
                stop = true;
            end
        case 'divisionTimeSD'
            if ~isnumeric(value)
                disp('divisionTimeSD must be numeric.')
                stop = true;
            elseif value <= 0
                disp('divisionTimeSD must have a value above zero.')
                stop = true;
            end
        case 'divisionDistanceConstant'
            if ~isnumeric(value)
                disp('divisionDistanceConstant must be numeric.')
                stop = true;
            elseif value <= 0
                disp('divisionDistanceConstant must have a value above zero.')
                stop = true;
            end
        case 'newCellAreaConstant'
            if ~isnumeric(value)
                disp('newCellAreaConstant must be numeric.')
                stop = true;
            elseif value <= 0
                disp('newCellAreaConstant must have a value above zero.')
                stop = true;
            end
        case 'cellGrowthConstant'
            if ~isnumeric(value)
                disp('cellGrowthConstant must be numeric.')
                stop = true;
            elseif value <= 0
                disp('cellGrowthConstant must have a value above zero.')
                stop = true;
            end
        case 'cellGrowthForceConstant'
            if ~isnumeric(value)
                disp('cellGrowthForceConstant must be numeric.')
                stop = true;
            elseif value <= 0
                disp('cellGrowthForceConstant must have a value above zero.')
                stop = true;
            end
        case 'baseDivisionRate'
            if ~isnumeric(value)
                disp('baseDivisionRate must be numeric.')
                stop = true;
            elseif value <= 0
                disp('baseDivisionRate must have a value above zero.')
                stop = true;
            end
        case 'divisionRateExponents'
            if ~isnumeric(value)
                disp('divisionRateExponents must be numeric.')
                stop = true;
            elseif value <= 0
                disp('divisionRateExponents must have a value above zero.')
                stop = true;
            end
        case 'fEdgeCell'
            if ~isnumeric(value)
                disp('fEdgeCell must be numeric.')
                stop = true;
            elseif value <= 0
                disp('fEdgeCell must have a value above zero.')
                stop = true;
            end
        case 'maxMembraneAngle'
            if ~isnumeric(value)
                disp('maxMembraneAngle must be numeric.')
                stop = true;
            elseif value <= 0
                disp('maxMembraneAngle must have a value above zero.')
                stop = true;
            elseif value > 3.14
                disp('maxMembraneAngle must be below pi.')
            end
        case 'maxJunctionAngleConstant'
            if ~isnumeric(value)
                disp('maxJunctionAngleConstant must be numeric.')
                stop = true;
            elseif value <= 0
                disp('maxJunctionAngleConstant must have a value above zero.')
                stop = true;
            elseif value > 1
                disp('maxJunctionAngleConstant must have a value below one.')
                stop = true;
            end
        case 'focalAdhesionBreakingForce'
            if ~isnumeric(value)
                disp('focalAdhesionBreakingForce must be numeric.')
                stop = true;
            elseif value <= 0
                disp('focalAdhesionBreakingForce must have a value above zero.')
                stop = true;
            end
        case 'maximumGrowthTime'
            if ~isnumeric(value)
                disp('maximumGrowthTime must be numeric.')
                stop = true;
            elseif value <= 0
                disp('maximumGrowthTime must have a value above zero.')
                stop = true;
            end
        case 'maximumDivisionTime'
            if ~isnumeric(value)
                disp('maximumDivisionTime must be numeric.')
                stop = true;
            elseif value <= 0
                disp('maximumDivisionTime must have a value above zero.')
                stop = true;
            end
        case 'minimumCellSize'
            if ~isnumeric(value)
                disp('minimumCellSize must be numeric.')
                stop = true;
            elseif value < 0
                disp('minimumCellSize must have a nonnegative value.')
                stop = true;
            end
    end
    
elseif strcmp(data.parameterStudy.type,'substrate')
    if strcmp(data.parameterStudy.operation,'equal')
        app.substrateParameters.(data.parameterStudy.parameter) = data.parameterStudy.values(iLoop);
    elseif strcmp(data.parameterStudy.operation,'multiply')
        app.substrateParameters.(data.parameterStudy.parameter) = app.substrateParameters.(data.parameterStudy.parameter)*data.parameterStudy.values(iLoop);
    end
    
    value = app.substrateParameters.(data.parameterStudy.parameter);
    
    switch data.parameterStudy.parameter
        case 'substratePointDistance'
            if ~isnumeric(value)
                disp('substratePointDistance must be numeric.')
                stop = true;
                return
            elseif value <= 0
                disp('substratePointDistance must have a value above zero.')
                stop = true;
                return
            end
        case 'youngsModulus'
            if ~isnumeric(value)
                disp('youngsModulus must be numeric.')
                stop = true;
                return
            elseif value <= 0
                disp('youngsModulus must have a value above zero.')
                stop = true;
                return
            end
        case 'youngsModulusConstant'
            if ~isnumeric(value)
                disp('youngsModulusConstant must be numeric.')
                stop = true;
                return
            elseif value <= 0
                disp('youngsModulusConstant must have a value above zero.')
                stop = true;
                return
            end
        case 'restorativeForceConstant'
            if ~isnumeric(value)
                disp('restorativeForceConstant must be numeric.')
                stop = true;
                return
            elseif value <= 0
                disp('restorativeForceConstant must have a value above zero.')
                stop = true;
                return
            end
        case 'repulsionLengthMultiplier'
            if ~isnumeric(value)
                disp('repulsionLengthMultiplier must be numeric.')
                stop = true;
                return
            elseif value <= 0 || value > 1
                disp('repulsionLengthMultiplier must have a value between 0 and 1.')
                stop = true;
                return
            end
        case 'honeycombConstants'
            if ~isnumeric(value)
                disp('honeycombConstants must be numeric.')
                stop = true;
                return
            elseif value < 100 || value > 999
                disp('honeycombConstants must be a three digit number.')
                stop = true;
                return
            end
        case 'substrateEdgeConstant'
            if ~isnumeric(value)
                disp('substrateEdgeConstant must be numeric.')
                stop = true;
                return
            elseif value < 0
                disp('substrateEdgeConstant must have a nonnegative value.')
                stop = true;
                return
            end
            
    end
    
end