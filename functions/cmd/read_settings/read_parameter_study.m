function data = read_parameter_study(fID,data)

if strcmp(fgetl(fID),'% parameter study')
    line = fgetl(fID);
    if strcmp(line,'')
        
    elseif strcmp(line,'% initial state') || strcmp(line(1),'%')
        disp('Error. Wrong file format, there should be an empty line before ''% initial state''.')
        data = 0;
        return
    else
        
        line = textscan(line,'%s %s %s');
        
        cellParameters = {'rCell','membraneLength','junctionLength','fArea','fCortex','fJunctions','fContact','perimeterConstant','perimeterModelingRate'};
        
        switch data.simulationType
            case 'growth'
                systemParameters = {'eta','scalingLength','scalingTime','stopDivisionTime','cellMaximumMovement','cellMinimumMovement','junctionModificationTimeStep'};
                specificCellParameters = {'fMembrane','fDivision','divisionTimeMean','divisionTimeSD','maximumGrowthTime','maximumDivisionTime','divisionDistanceConstant','newCellAreaConstant','cellGrowthConstant','cellGrowthForceConstant','baseDivisionRate','divisionRateExponents','maxMembraneAngle','maxJunctionAngleConstant','minimumCellSize'};
            case 'pointlike'
                systemParameters = {'eta','scalingLength','scalingTime','cellMaximumMovement','cellMinimumMovement','junctionModificationTimeStep','substrateMaximumMovement','substrateMinimumMovement','fPointlike'};
                specificCellParameters = {'fMembrane','fEdgeCell','focalAdhesionBreakingForce'};
                substrateParameters = {'substratePointDistance','youngsModulus','youngsModulusConstant','restorativeForceConstant','repulsionLengthConstant','substrateEdgeConstant','honeycombConstants'};
            case 'opto'
                systemParameters = {'eta','scalingLength','scalingTime','cellMaximumMovement','cellMinimumMovement','junctionModificationTimeStep','substrateMaximumMovement','substrateMinimumMovement','fullActivationConstant'};
                specificCellParameters = {'fMembrane','fEdgeCell','maxMembraneAngle','maxJunctionAngleConstant','focalAdhesionBreakingForce'};
                substrateParameters = {'substratePointDistance','youngsModulus','youngsModulusConstant','restorativeForceConstant','repulsionLengthConstant','substrateEdgeConstant','honeycombConstants'};
            case 'stretch'
                systemParameters = {'eta','scalingLength','scalingTime','cellMaximumMovement','cellMinimumMovement','junctionModificationTimeStep','substrateMaximumMovement','substrateMinimumMovement'};
                specificCellParameters = {'fMembrane','fEdgeCell','maxMembraneAngle','maxJunctionAngleConstant','focalAdhesionBreakingForce'};
                substrateParameters = {'substratePointDistance','youngsModulus','youngsModulusConstant','restorativeForceConstant','repulsionLengthConstant','substrateEdgeConstant','honeycombConstants'};
        end

        
        if any(strcmp(line{1}{1},systemParameters))
            data.parameterStudy.type = 'system';
        elseif any(strcmp(line{1}{1},cellParameters))
            data.parameterStudy.type = 'cell';
        elseif any(strcmp(line{1}{1},specificCellParameters))
            data.parameterStydy.type = 'specific';
        elseif (strcmp(data.simulationType,'pointlike') || strcmp(data.simulationType,'opto') || strcmp(data.simulationType,'stretch')) && any(strcmp(line{1}{1},substrateParameters))
            data.parameterStudy.type = 'substrate';
        else
            disp(['Error. ' line{1}{1} ' is not a parameter with this simulation type.'])
            data = 0;
            return
        end
        data.parameterStudy.parameter = line{1}{1};
        if strcmp(line{2},'=')
            data.parameterStudy.operation = 'equal';
        elseif strcmp(line{2},'*')
            data.parameterStudy.operation = 'multiply';
        else
            disp('Error. Parameter study operation must be either ''='' (equal) or ''*'' (multiply).')
            data = 0;
            return
        end
        try
            values = cell2mat(textscan(line{3}{1},'','delimiter',','));
        catch
            switch data.parameterStudy.operation
                case 'equal'
                    disp('Error. Check that the parameter values are given correctly (e.g. normArea = 3,5,10).')
                    data = 0;
                    return
                case 'multiply'
                    disp('Error. Check that the parameter multipliers are given correctly  (e.g. normArea * 3,5,10).')
                    data = 0;
                    return
            end
        end
        if ~(length(values) == data.nSimulations)
            switch data.parameterStudy.operation
                case 'equal'
                    disp(['Error. The number of of given values should be equal to the number of simulations (' num2str(data.nSimulations) ').'])
                    data = 0;
                    return
                case 'multiply'
                    disp(['Error. The number of of given multipliers should be equal to the number of simulations (' num2str(data.nSimulations) ').'])
                    data = 0;
                    return
            end
        end
        data.parameterStudy.values = values;
        if ~strcmp(fgetl(fID),'')
            disp('Error. There should be an empty line before ''% initial state''.')
            data = 0;
            return
        end
    end
    
else
    disp('Error. Wrong file format, the third line should be ''% parameter study''.')
    data = 0;
    return
end