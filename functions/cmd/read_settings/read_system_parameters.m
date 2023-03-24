function data = read_system_parameters(fID, data)
% READ_SYSTEM_PARAMETERS Read the system parameter files
%   The function reads the system parameter files from the config file. The
%   system parameter(s) are given as a file (including paths), one per
%   line. The number of the path lines must be either one or the  number of
%   simulations. Also, the path can read "load" for selecting the file
%   later via getfile dialog.
%   INPUT:
%       fID: ID for the file
%       data: structure to collect config file data
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

% check if the next line in the file is "% system parameters"
if strcmp(fgetl(fID),'% system parameters')
    
    % loop until an empty line is found
    while 1
        
        % get the next line from the file
        line = fgetl(fID);
        
        % if the line is empty
        if strcmp(line,'')
            
            % if there are system parameter files defined, break out of the
            % loop
            if numel(data.systemParameterFiles) > 0
                break
                
            % otherwise, give error and return
            else
                disp('Error. No system parameter file(s) given.')
                data = 0;
                return
            end
            
        % if the line reads "load" save it to the systemParameterFiles cell
        elseif strcmp(line,'load')
            data.systemParameterFiles{end+1} = 'load';
            
        % if the line reads "% cell parameters", or has other comment,
        % give error and return
        elseif strcmp(line,'% cell parameters') || strcmp(line(1),'%')
            disp('Error. Wrong file format, there should be an empty line before ''% cell parameters''.')
            data = 0;
            return
            
        % otherwise
        else
            
            % try to open the file
            fIDTemp = fopen(line);
            
            % if the file can be opened
            if fIDTemp ~= -1
                
                % close the file
                fclose(fIDTemp);
                
                % get the extension for the file
                [~,~,ext] = fileparts(line);
                
                % check if this is a text file
                if strcmp(ext,'.txt')
                    
                    % save the file name to systemParameterFiles cell
                    data.systemParameterFiles{end+1} = line;
                    
                % otherwise
                else
                    
                    % if not, give error and return
                    disp('Error. Wrong file format, should be a .txt file.')
                    data = 0;
                    return
                end
                
            % if file not found
            else
                
                % give an error indicating which file cannot be opened or
                % found and return
                inputNumber = numel(data.systemParameterFiles)+1;
                disp(['Error. The system parameter file number ' num2str(inputNumber) '  cannot be found or opened'])
                data = 0;
                return
            end
        end
    end
    
% if no "% system parameters" line is found, give error
else
    disp('Error. Wrong file format, the line ''% system parameters'' not found after the simulation number definition.')
    data = 0;
    return
end

% check if the number of the system parameter files given is either one or
% the number of simulations
if ~any(length(data.systemParameterFiles) == [1 data.nSimulations])
    
    % if no, give error and return
    disp(['Error. The number of of given system parameter files should either be one or the number of simulations (' num2str(data.nSimulations) ').'])
    data = 0;
    return
end

end