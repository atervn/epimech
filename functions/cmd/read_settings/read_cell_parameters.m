function data = read_cell_parameters(fID, data)
% READ_CELL_PARAMETERS Read the cell parameter files
%   The function reads the cell parameter and simulation specific cell
%   parameter files from the config file. The cells parameter(s) are
%   given as a file paths one per line. Each line should have two files
%   separated by a space. The first file is the file (including path) to
%   the cell parameters and the second to the simulation specific cell
%   parameters. The number of the path lines must be either one or the
%   number of simulations. Also, the path can read "load" for selecting the
%   file later via getfile dialog.
%   INPUT:
%       fID: ID for the file
%       data: structure to collect config file data
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

% check if the next line in the file is "% cell parameters"
if strcmp(fgetl(fID),'% cell parameters')
    
    % loop until an empty line is found
    while 1
        
        % get the next line from the file
        line = fgetl(fID);
        
        % if the line is empty
        if strcmp(line,'')
            
            % if there are cell parameter files defined, break out of the
            % loop
            if numel(data.cellParameterFiles) > 0
                break
                
            % otherwise, give error and return
            else
                disp('Error. No cell parameter file(s) given.')
                data = 0;
                return
            end
            
        % if the line reads "% substrate parameters", or has other comment,
        % give error and return
        elseif strcmp(line,'% substrate parameters') || strcmp(line(1),'%')
            disp('Error. Wrong file format, there should be an empty line before ''% substrate parameters''.'); data = 0; return
            
        % otherwise
        else
            
            % scan the line to obtain two strings
            line = textscan(line,'%s %s');
            
            % if the first string on the line is "load", save it to the
            % cellParameterFiles cell
            if strcmp(line{1}{1},'load')
                data.cellParameterFiles{end+1} = 'load';
                
            % otherwise
            else
                
                % try to open the file
                fIDTemp = fopen(line{1}{1});
                
                % if the file can be opened
                if fIDTemp ~= -1
                
                    % close the file
                    fclose(fIDTemp);
                
                    % get the extension for the file
                    [~,~,ext] = fileparts(line{1}{1});
                
                    % check if this is a text file
                    if strcmp(ext,'.txt')
                    
                        % save the file name to cellParameterFiles cell
                        data.cellParameterFiles{end+1} = line{1}{1};
                    
                    % otherwise
                    else
                    
                        % if not, give error and return
                        disp('Error. Wrong file format, the cell parameters file should be be a .txt file.'); data = 0; return
                    end
                
                % if file not found
                else
                    
                    % give an error indicating which file cannot be opened
                    % or found and return
                    inputNumber = numel(data.cellParameterFiles)+1;
                    disp(['Error. The cell parameter file number ' num2str(inputNumber) ' cannot be found or opened.']); data = 0; return
                end
            end
            
            % if the second string on the line is "load", save it to the
            % specificCellParameterFiles cell
            if strcmp(line{2}{1},'load')
                data.specificCellParameterFiles{end+1} = 'load';
                
            % otherwise
            else
                
                % try to open the file
                fIDTemp = fopen(line{2}{1});
                
                 % if the file can be opened
                if fIDTemp ~= -1
                
                    % close the file
                    fclose(fIDTemp);
                
                    % get the extension for the file
                    [~,~,ext] = fileparts(line{2}{1});
                
                    % check if this is a text file
                    if strcmp(ext,'.txt')
                        
                        % save the file name to cellParameterFiles cell
                        data.specificCellParameterFiles{end+1} = line{2}{1};
                    
                    % otherwise
                    else
                    
                        % if not, give error and return
                        disp('Error. Wrong file format, the specific cell parameters should be a .txt file.'); data = 0; return
                    end
                
                % if file not found
                else
                    
                    % give an error indicating which file cannot be opened
                    % or found and return
                    inputNumber = numel(data.specificCellParameterFiles)+1;
                    disp(['Error. The specific cell parameter file number' num2str(inputNumber) ' cannot be found or opened.']); data = 0; return
                end
            end
        end
    end
    
% if no "% cell parameters" line is found, give error
else
    disp('Error. Wrong file format, the line ''% cell parameters'' not found after system parameter file definition.'); data = 0; return
end

% check if the number of the cell parameter files given is either one or
% the number of simulations
if ~any(length(data.cellParameterFiles) == [1 data.nSimulations])
    
    % if no, give error and return
    disp(['Error. The number of of given cell parameter files should either be one or the number of simulations (' num2str(data.nSimulations) ').']); data = 0; return
end

end