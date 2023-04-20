function data = read_simulation_type(fID,data)
% READ_SIMULATION_TYPE Read the simulation type data from the config file
%   The function reads the simulation type from the config file and makes
%   sure it is a valid simulation type. Also, it makes sure there is an
%   empty line before the "% number of cores" line
%   INPUT:
%       fID: ID for the file
%       data: structure to collect config file data
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

% check if the next line in the file is "% simulation type"
if strcmp(fgetl(fID),'% simulation type')
    
    % get the line following the % simulation type
    line = fgetl(fID);
    
    % set the simulation type based on the input
    if strcmp(line,'growth')
        data.simulationType = 'growth';
    elseif strcmp(line,'pointlike')
        data.simulationType = 'pointlike';
    elseif strcmp(line,'opto')
        data.simulationType = 'opto';
    elseif strcmp(line,'stretch')
        data.simulationType = 'stretch';
    
    % not correct simulation type
    else
        
        % give error and return
        disp('Error. Simulation type unknown. It has to be either growth, pointlike, opto, or stretch.')
        data = 0;
        return
    end
    
    % check if there is an empty line following the simulation type
    if ~strcmp(fgetl(fID),'')
        
        % give error and return
        disp('Error. There should be an empty line before ''% number of cores''.')
        data = 0;
        return
    end
    
% wrong file format, return
else
    disp('Error. Wrong file format, the line ''% simulation type'' not found in the beginning of the file.')
    data = 0;
    return
end

end