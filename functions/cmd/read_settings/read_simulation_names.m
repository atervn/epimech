function data = read_simulation_names(fID,data)
% READ_SIMULATION_NAMES Read simulation names
%   The function reads the simulation names from the config file. If no
%   name is given, the default name "simulation" is used. If one simulation
%   name is given, the name will be postfixed with underscore and a number
%   later. If a single name is given and the name contains "#", the hashtag
%   is replaced by the the simulation number. This can be used to give the
%   simulation number elsewhere than in the end of the name. The user can
%   also give unique name for each simulation.
%   INPUT:
%       fID: ID for the file
%       data: structure to collect config file data
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

% check if the next line in the file is "% simulation names"
if strcmp(fgetl(fID),'% simulation names')
    
    % loop until an empty line is found or the file ends
    while 1
        
        % get the line
        line = fgetl(fID);
        
        % check if this is an empty line or the file has ended
        if strcmp(line,'') || sum(line == -1)
            
            % if there are names given, break out
            if numel(data.simulationNames) > 0
                break
                
            % if there are no names given, give the default name
            % "simulation"
            else
                data.simulationNames{1} = 'simulation';
            end
            
        % otherwise, save the name
        else
            data.simulationNames{end+1} = line;
        end
    end
    
% if the "% simulation names" line is not found, give error and return
else
    disp('Error. Wrong file format, the third line should be ''% simulation names''.'); data = 0; return
end

% if only one simulation name is given
if length(data.simulationNames) == 1
    
    % find if if there is a hashtag somewhere in the filename
    hashtagIdx = find(data.simulationNames{1} == '#');
    
    % if there is
    if numel(hashtagIdx) > 0
        
        % get the given name and empty the simulation names cell
        tempName = data.simulationNames{1};
        data.simulationNames = {};
        
        % go through the number of simulations
        for i = 1:data.nSimulations
            
            % if the hashtag is the first character
            if hashtagIdx == 1
                
                % replace the hashtag with the iteration number
                tempName = [num2str(i) tempName(hashtagIdx+1:end)];
                
                % save the name to the cell
                data.simulationNames{end+1} = tempName;
                
            % if the hashtag is the lat character
            elseif hashtagIdx == length(tempName)
                % replace the hashtag with the iteration number
                tempName = [tempName(1:hashtagIdx-1) num2str(i)];
                
                % save the name to the cell
                data.simulationNames{end+1} = tempName;
            else
                % replace the hashtag with the iteration number
                tempName = [tempName(1:hashtagIdx-1) num2str(i) tempName(hashtagIdx+1:end)];
                
                % save the name to the cell
                data.simulationNames{end+1} = tempName;
            end
        end
    end
end

% check if the number of simulation names is one or the number of
% simulations, if not, give error and return 
if ~any(length(data.simulationNames) == [1 data.nSimulations])
    disp(['Error. The number of given simulation names should either be one or the number of simulations (' num2str(data.nSimulations) ').']); data = 0; return
end

end