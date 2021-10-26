function data = read_parameter_study(fID,data)
% READ_PARAMETER_STUDY Read the parameter study defintions
%   The function reads the parameter stude definitions to vary the values
%   of a parameter between simulations. The line can be left empty for not
%   varying the values. The line must read the [parameter name]
%   [definition type] [values]. The definition type is either = or * (the
%   first defines the absolute value of the parameter and the latter the
%   relative value to the default value). The values are separated by
%   commas and their number must equal to the number of simulations.
%   INPUT:
%       fID: ID for the file
%       data: structure to collect config file data
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

% check if the next line in the file is "% parameter study"
if strcmp(fgetl(fID),'% parameter study')
    
    % get the line
    line = fgetl(fID);
    
    % if empty line, return
    if strcmp(line,'')
        return
        
    % if the line reads "% export settings", or has other comment, give
    % error and return
    elseif strcmp(line,'% export settings') || strcmp(line(1),'%')
        disp('Error. Wrong file format, there should be an empty line before ''% export settings''.'); data = 0; return
    
    % otherwise
    else
        
        % scan the line to obtain three string
        line = textscan(line,'%s %s %s');
        
        % create list of parameter for the basic cell parameters, and the
        % simulation specific system, specific cell parameters, and
        % substrate parameters
        cellParameters = {'rCell','membraneLength','junctionLength','fArea','fCortex','fJunctions','fContact','perimeterConstant','perimeterModelingRate','minimumCellSize'};
        switch data.simulationType
            case 'growth'
                systemParameters = {'eta','scalingLength','scalingTime','stopDivisionTime','cellMaximumMovement','cellMinimumMovement','junctionModificationTimeStep'};
                specificCellParameters = {'fMembrane','fDivision','divisionTimeMean','divisionTimeSD','maximumGrowthTime','maximumDivisionTime','divisionDistanceConstant','newCellAreaConstant','cellGrowthConstant','cellGrowthForceConstant','baseDivisionRate','divisionRateExponents','maxMembraneAngle','maxJunctionAngleConstant'};
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

        % check which parameter list the parameter belongs to and save the
        % list name
        if any(strcmp(line{1}{1},systemParameters))
            data.parameterStudy.type = 'system';
        elseif any(strcmp(line{1}{1},cellParameters))
            data.parameterStudy.type = 'cell';
        elseif any(strcmp(line{1}{1},specificCellParameters))
            data.parameterStydy.type = 'specific';
        elseif (strcmp(data.simulationType,'pointlike') || strcmp(data.simulationType,'opto') || strcmp(data.simulationType,'stretch')) && any(strcmp(line{1}{1},substrateParameters))
            data.parameterStudy.type = 'substrate';
        
        % if parameter is not found in any list, give error and return
        else
            disp(['Error. ' line{1}{1} ' is not a parameter with this simulation type.']); data = 0; return
        end
        
        % save the parameter name
        data.parameterStudy.parameter = line{1}{1};
        
        % if the parameter values are given directly
        if strcmp(line{2},'=')
            data.parameterStudy.operation = 'equal';
            
        % if the parameter values are given as multipliers
        elseif strcmp(line{2},'*')
            data.parameterStudy.operation = 'multiply';
            
        % otherwise, give error and return
        else
            disp('Error. Parameter study operation must be either ''='' (equal) or ''*'' (multiply).'); data = 0; return
        end
        
        % try to scan the rest of the line with a delimited "," and convert
        % it to matrix
        try
            values = cell2mat(textscan(line{3}{1},'','delimiter',','));
            
        % if this fails, give error and return
        catch
            switch data.parameterStudy.operation
                case 'equal'
                    disp('Error. Check that the parameter values are given correctly (e.g. normArea = 3,5,10).'); data = 0; return
                case 'multiply'
                    disp('Error. Check that the parameter multipliers are given correctly  (e.g. normArea * 3,5,10).'); data = 0; return
            end
        end
        
        % check if the number of given values equals the number of
        % simulations
        if ~(length(values) == data.nSimulations)
            
            % if not, give error and return
            switch data.parameterStudy.operation
                case 'equal'
                    disp(['Error. The number of of given values should be equal to the number of simulations (' num2str(data.nSimulations) ').']); data = 0; return
                case 'multiply'
                    disp(['Error. The number of of given multipliers should be equal to the number of simulations (' num2str(data.nSimulations) ').']); data = 0; return
            end
        end
        
        % save the values
        data.parameterStudy.values = values;
        
        % check if there is an empty line before "% export settings"
        if ~strcmp(fgetl(fID),'')
            disp('Error. There should be an empty line before ''% export settings''.'); data = 0; return
        end
    end

% otherwise, give error and return
else
    disp('Error. Wrong file format, the line ''% parameter study'' should follow the simulation specific definitions.'); data = 0; return
end

end