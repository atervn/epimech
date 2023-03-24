function data = read_initial_states(fID,data)
% READ_INITIAL_STATES Read the initial state files
%   The function reads the initial state files for the simulation(s). The
%   line can be empty to indicate the the simulation only has a single
%   cell initially. Each line must contain at least the file name
%   (including path) of the zip file for the simulation result to be used
%   as well as 0 or 1 to indicate the use of cell parameters from the
%   config file (0) or from the imported simulation data (1). Additionally,
%   the user can give a string to remove cells outside a shape whose type
%   and dimensions are defined in the string. First, the type is defined
%   (c: circle, s: square) followed by the size in um. E.g. to remove cells
%   outside circle with the diamater of 200 um, the string would be "c200".
%   The number of the lines must be either one or the number of
%   simulations. Also, the initial file can be replaced by "load" for
%   selecting the file later via getfile dialog. 
%   INPUT:
%       fID: ID for the file
%       data: structure to collect config file data
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

% check if the next line in the file is "% initial state"
if strcmp(fgetl(fID),'% initial state')
    
    % loop until an empty line is found
    while 1
        
        % get the next line from the file
        line = fgetl(fID);
        
        % if the line is empty, break
        if strcmp(line,'')
            break
            
        % if the line reads "% simulation time", or has other comment, give
        % error and return
        elseif strcmp(line,'% simulation time') || strcmp(line(1),'%')
            disp('Error. Wrong file format, there should be an empty line before ''% simulation time''.'); data = 0; return
            
        % otherwise
        else
            
            % scan the line to obtain number of strings
            line = textscan(line,'%s');
            
            % if the first string on the line is "load", save it to the
            % initialStateFiles cell
            if strcmp(line{1}{1},'load')
                data.initialStateFiles{end+1} = 'load';
            
            % otherwise
            else
                
                % check if the file exists
                if exist(line{1}{1},'file') == 0
                    
                    % if not, give error and return
                    inputNumber = numel(data.initialStateFiles)+1;
                    disp(['Error. The initial state file number ' num2str(inputNumber) ' not found (' line{1}{1} ').']); data = 0; return
                end
                
                % get the file extension
                [~,~,ext] = fileparts(line{1}{1});
                
                % check if it is a zip file, if yes, save to
                % initialStateFiles
                if strcmp(ext,'.zip')
                    data.initialStateFiles{end+1} = line{1}{1};
                
                % if no, give error and return
                else
                    inputNumber = numel(data.initialStateFiles)+1;
                    disp(['Error. Wrong file format on initial cell file number ' num2str(inputNumber) ', should be a .zip file.']); data = 0; return
                end
            end
            
            % check if there is a next string
            if length(line{1}) < 2 || isempty(line{1}{2})
                
                % if no, give error and return
                inputNumber = numel(data.loadedParameters)+1;
                disp(['Error. the flag after the initial file name number ' num2str(inputNumber) ' for either given or loaded cell parameters is missing (0 or 1)']); data = 0; return
                
            % check if the cell parameter flag is 0 or 1
            elseif ~(strcmp(line{1}{2},'0') || strcmp(line{1}{2},'1'))
                
                % if no, give error and return
                inputNumber = numel(data.loadedParameters)+1;
                disp(['Error. the flag must be either 0 or 1 for given or loaded cell parameters (missing for initial file number ' num2str(inputNumber) ', respectively']); data = 0; return
            
            % otherwise
            else
                
                % save the cell parameter flag to loadedParameters cell
                data.loadedParameters(end+1) = str2double(line{1}{2});
            end
            
            % if there is a third string in the line to remove cells
            if length(line{1}) > 2
                
               % get the string
               string = line{1}{3};
               
               % if the string has less than two characters, give error and
               % return
               if length(string) < 2
                   inputNumber = numel(data.removeCells.type)+1;
                   disp(['Error. The cell removal flag must have the shape type (c or s) followed by the size in µm (initial state number ' num2str(inputNumber) ').']); data = 0; return
               end
               
               % if the first character is not "c" or "r", give error and
               % return
               if ~(strcmp(string(1),'c') || strcmp(string(1),'r'))
                   inputNumber = numel(data.removeCells.type)+1;
                   disp(['Error. The cell removal shape type must be the first letter (c or s) of the removal flag (initial state number ' num2str(inputNumber) ').']); data = 0; return
               
               % otherwise, save the removal shape type to removeCells.type
               % cell
               else
                   data.removeCells.type{end+1} = string(1);
               end
               
               % get get the rest of the string as the shape size
               shapeSize = str2double(string(2:end));
               
               % if the size is not a number, give error and return
               if isnan(shapeSize) 
                   inputNumber = numel(data.removeCells.size)+1;
                   disp(['Error. Cannot read the cell removal size, not a number (initial state number ' num2str(inputNumber) ').']); data = 0; return
                   
               % if the shape size is negative, give error and return
               elseif shapeSize <= 0
                   inputNumber = numel(data.removeCells.size)+1;
                   disp(['Error. The cell removal size must be a positive number(initial state number ' num2str(inputNumber) ').']); data = 0; return
               
               % otherwise, save the shape size to removeCells.size cell
               else
                   data.removeCells.size{end+1} = shapeSize;
               end
            end
        end
    end
    
% if not 
else
    disp('Error. Wrong file format, the line ''% initial state'' not found after substrate settings files definition.'); data = 0; return
end

% check if the number of the initial states given is either zero, one, or
% the number of simulations
if ~any(length(data.initialStateFiles) == [0 1 data.nSimulations])
    disp(['Error. The number of of given initial state files must be zero, one, or the number of simulations (' num2str(data.nSimulations) ').']); data = 0; return
end

end