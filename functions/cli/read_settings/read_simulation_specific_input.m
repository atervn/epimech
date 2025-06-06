function data = read_simulation_specific_input(fID,data)
% READ_SIMULATION_SPECIFIC_INPUT Read the simulation specific settings
%   The function reads the simulation specific inputs for each simulation
%   type. For growth simulation, the size type is required (uniform or
%   mdck). For pointlike simulation, the input has to be the moved cell
%   number (number 0 uses the cell closest to the middle) followed by the
%   pointlike movement file. For stretch simulation, the line has the
%   stretch direction (uni or bi), followed by the stretch type (piecewise
%   or sine) followed by a file the described the stretch for the selected
%   stretch type. For opto simulation, the required input are the files
%   describing the activation and the activation shapes. The number of
%   definitions need to be either 1 (the same for all) or the number of
%   simulations.
%   INPUT:
%       fID: ID for the file
%       data: structure to collect config file data
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

% check if the next line in the file is "% simulation specific input"
if strcmp(fgetl(fID),'% simulation specific input')
    
    %% if growth simulation
    if strcmp(data.simulationType,'growth')
        
        % initialize cell size type
        data.sizeType = [];
        
        % loop until an empty line is found
        while 1
        
            % get the next line from the file
            line = fgetl(fID);
            
            % if the line is empty
            if strcmp(line,'')
            
                % if there is size type defined, break out of the loop
                if numel(data.sizeType) > 0
                    break
                    
                % otherwise, give error and return  
                else
                    disp('Error. No size type given (uniform or mdck).'); data = 0; return
                end
                
            % if the line reads "% parameter study", or has other comment,
            % give error and return
            elseif strcmp(line,'% parameter study') || strcmp(line(1),'%')
                disp('Error. Wrong file format, there should be an empty line before ''% parameter study''.'); data = 0; return
            
            % otherwise
            else
                
                % scan the line to obtain the string
                line = textscan(line,'%s');
                
                % if uniform size, save the type
                if strcmp('uniform',line{1}{1})
                    data.sizeType(end+1) = 1;
                    
                % if mdck size, save the type
                elseif strcmp('mdck',line{1}{1})
                    data.sizeType(end+1) = 2;
                    
                % otherwise
                else
                    
                    
                    inputNumber = numel(data.sizeType)+1;
                    disp(['Error. The cell size type for simulation number ' num2str(inputNumber) ' is incorrect.']); data = 0; return
                end
            end
        end
        
    %% if pointlike simulation
    elseif strcmp(data.simulationType,'pointlike')
        
        % initialize the cells to save the pointlike data
        data.pointlike.pointlikeMovement = {};
        data.pointlike.cell = {};
        
        % loop until an empty line is found
        while 1
            
            % get the next line from the file
            line = fgetl(fID);
            
            % if the line is empty
            if strcmp(line,'')
                
                % if there are pointlike setting defined, break out of the
                % loop
                if numel(data.pointlike.cell) > 0
                    break
                    
                % otherwise, give error and return
                else
                    disp('Error. No pointlike parameters given.'); data = 0; return
                end
                
            % if the line reads "% parameter study", or has other comment,
            % give error and return
            elseif strcmp(line,'% parameter study') || strcmp(line(1),'%')
                disp('Error. Wrong file format, there should be an empty line before ''% parameter study''.'); data = 0; return
                
            % otherwise
            else
                
                % scan the line to obtain two strings
                line = textscan(line,'%s %s');
                
                % get the cell number from the first string
                cellNumber = str2double(line{1}{1});
                
                % check if the cell number is not a number
                if isnan(cellNumber)
                    
                    % if yes, give error and return
                    inputNumber = numel(data.pointlike.cell)+1;
                    disp(['Error. The cell number in the simulation specific input for simulation number ' num2str(inputNumber) '  is incorrect.']); data = 0; return
                
                % check that the cell number is a nonnegative integer
                elseif ~(floor(cellNumber) == cellNumber && cellNumber >= 0)
                    
                    inputNumber = numel(data.pointlike.cell)+1;
                    disp(['Error. The cell number in the simulation specific input for simulatino number ' num2str(inputNumber) ' must be zero or a positive integer.']); data = 0; return
                
                % otherwise
                else
                    
                    % save the cell number
                    data.pointlike.cell{end+1} = cellNumber;
                end
                
                % get the file extension for the pointlike movement file
                [~,~,ext] = fileparts(line{2}{1});
                
                % if the the string is "load", save it to the
                % pointlike.pointlikeMovement
                if strcmp(line{2}{1},'load')
                    data.pointlike.pointlikeMovement{end+1} = 'load';
                    
                % if the file type is not txt, give error and return
                elseif ~strcmp(ext,'.txt')
                    inputNumber = numel(data.pointlike.pointlikeMovement)+1;
                    disp(['Error. Wrong file format for the pointlike movement for simulation number ' num2str(inputNumber) ', should be a .txt file.']); data = 0; return
                
                % otherwise
                else
                    
                    % open the movement file
                    fIDTemp = fopen(line{2}{1});
                    
                    % if the file can be opened
                    if fIDTemp ~= -1
                        
                        % close the file
                        fclose(fIDTemp);
                        
                        % save the file to pointlike.pointlikeMovement
                        data.pointlike.pointlikeMovement{end+1} = line{2}{1};
                        
                    % otherwise, give error and return
                    else
                        inputNumber = numel(data.pointlike.pointlikeMovement)+1;
                        disp(['Error. The pointlike movement file for simulation number ' num2str(inputNumber) '  cannot be found or opened.']); data = 0; return
                    end
                end
            end
        end
        
    %% if stretch simulation
    elseif strcmp(data.simulationType,'stretch')
        
        % initialize stretching data cells
        data.stretching.directions = {};
        data.stretching.type = {};
        data.stretching.info = {};
        
        % loop until an empty line is found
        while 1
            
            % get the next line from the file
            line = fgetl(fID);
            
            % if the line is empty
            if strcmp(line,'')
            
                % if there is stretch data defined, break out of the loop
                if numel(data.stretching.directions) > 0
                    break
                    
                % otherwise, give error and return
                else
                    disp('Error. No stretching parameters given.'); data = 0; return
                end
                
            % if the line reads "% parameter study", or has other comment,
            % give error and return
            elseif strcmp(line,'% parameter study') || strcmp(line(1),'%')
                disp('Error. Wrong file format, there should be an empty line before ''% parameter study''.'); data = 0; return
                
            % otherwise
            else
                
                % scan the line to obtain strings
                line = textscan(line,'%s');
                
                % variable to keep track of current item in the line
                lineIdx = 1;
                
                % if the stretch direction is "uni", save it and progress
                % the line index
                if strcmp(line{1}{lineIdx},'uni')
                    data.stretching.directions{end+1} = 1;
                    lineIdx = lineIdx + 1;
                    
                % if the stretch direction is "bi", save it and progress
                % the line index    
                elseif strcmp(line{1}{lineIdx},'bi')
                    data.stretching.directions{end+1} = 2;
                    lineIdx = lineIdx + 1;
                    
                % otherwise, give error and return
                else
                    inputNumber = numel(data.stretching.directions)+1;
                    disp(['Error. Stretching direction must be either uni or bi (simulation number ' num2str(inputNumber) ').']); data = 0; return
                end
                
                % if the stretch type is "piecewise", save it and progress
                % the line index
                if strcmp(line{1}{lineIdx},'piecewise')
                    data.stretching.type{end+1} = 1;
                    lineIdx = lineIdx + 1;
                    
                % if the stretch type is "sine", save it and progress the
                % line index
                elseif strcmp(line{1}{lineIdx},'sine')
                    data.stretching.type{end+1} = 2;
                    lineIdx = lineIdx + 1;
                    
                % otherwise, give error and return
                else
                    inputNumber = numel(data.stretching.type)+1;
                    disp(['Error. Stretching type must be either piecewise or sine (simulation number' num2str(inputNumber) ').']); data = 0; return
                end
                
                % if the stretch type is piecewise
                if data.stretching.type{end} == 1
                    
                    % get the stretch file name
                    stretchingFile = line{1}{lineIdx};
                    
                    % get the file extension
                    [~,~,ext] = fileparts(stretchingFile);
                    
                    % if the the string is "load", save it
                    if strcmp(line{1}{1},'load')
                        data.stretching.info{end+1} = 'load';
                        
                    % check if the extension is not a csv, if not, give
                    % error and return
                    elseif ~strcmp(ext,'.csv')
                        inputNumber = numel(data.stretching.type);
                        disp(['Error. The piecewise stretching file should be a .csv file (simulation number ' num2str(inputNumber) ').']); data = 0; return
                        
                        % otherwise
                    else
                        
                        % try to open the file
                        try
                            stretchingData = csvread(stretchingFile);
                            
                        % if it does not open, give error and return
                        catch
                            inputNumber = numel(data.stretching.type);
                            disp(['Error. Could not open the stretching file (simulation number ' num2str(inputNumber) ').']); data = 0; return
                        end
                        
                        % check if there are two columns in the file, if
                        % not, give error and return
                        if size(stretchingData,2) ~= 2
                            inputNumber = numel(data.stretching.type);
                            disp(['Error. There must be columns in the stretching file (simulation number ' num2str(inputNumber) ').']); data = 0; return
                        
                        % check that there is more than one row
                        elseif size(stretchingData,1) <= 1
                            inputNumber = numel(data.stretching.type);
                            disp(['Error. There must be more than one row in the stretching file (simulation number ' num2str(inputNumber) ').']); data = 0; return
                        
                        % check that the first time point is zero
                        elseif stretchingData(1,1) ~= 0
                            inputNumber = numel(data.stretching.type);
                            disp(['Error. The first time point must be zero (simulation number ' num2str(inputNumber) ').']); data = 0; return
                        
                        % check that the time points increase when going
                        % down the column
                        elseif ~all((stretchingData(2:end,1) - stretchingData(1:end-1,1)) > 0 )
                            inputNumber = numel(data.stretching.type);
                            disp(['Error. The time point values must be increasing (simulation number ' num2str(inputNumber) ').']); data = 0; return
                        
                        % check that the stretch values are all above zero
                        elseif ~all(stretchingData(:,2) > 0)
                            inputNumber = numel(data.stretching.type);
                            disp(['Error. The stretches must be above zero (simulation number ' num2str(inputNumber) ').']); data = 0; return
                        
                        % if all checks go through, save the file name
                        else
                            data.stretching.info{end+1} = stretchingFile;
                        end
                    end
                    
                % if the stretch type is sine
                elseif data.stretching.type{end+1} == 2
                    
                    % get the stretch file name
                    stretchingFile = line{1}{lineIdx};
                    
                    % get the file extension
                    [~,~,ext] = fileparts(stretchingFile);
                    
                    % if the the string is "load", save it
                    if strcmp(line{1}{1},'load')
                        data.stretching.info{end+1} = 'load';
                        
                    % check if the extension is not a csv, if not, give
                    % error and return
                    elseif ~strcmp(ext,'.csv')
                        inputNumber = numel(data.stretching.type);
                        disp(['Error. The sine stretching file should be a .csv file (simulation number ' num2str(inputNumber) ').']); data = 0; return
                    
                    % otherwise
                    else
                        
                        % try to open the file
                        try
                            stretchingData = csvread(stretchingFile);
                            
                        % if it does not open, give error and return
                        catch
                            inputNumber = numel(data.stretching.type);
                            disp(['Error. Could not open the stretching file (simulation number ' num2str(inputNumber) ').']); data = 0; return
                        end
                        
                        % check if there are three elements in the file, if
                        % not, give error and return
                        if length(stretchingData) ~= 3
                            inputNumber = numel(data.stretching.type);
                            disp(['Error. There must be three values in the sine stretching file (simulation number ' num2str(inputNumber) ').']); data = 0; return
                        
                        % check if the first value (amplitude) is positive,
                        % if not, give error and return
                        elseif stretchingData(1) < 0
                            inputNumber = numel(data.stretching.type);
                            disp(['Error. The first value in the sine stretching file (amplitude) must be above zero (simulation number ' num2str(inputNumber) ').']); data = 0; return
                        
                        % check if the second value (frequency) is
                        % nonnegative, if not, give error and return
                        elseif stretchingData(2) <= 0
                            inputNumber = numel(data.stretching.type);
                            disp(['Error. The first value in the sine stretching file (frequency) must be nonnegative (simulation number ' num2str(inputNumber) ').']); data = 0; return
                        
                        % if all checks go through, save the file name
                        else
                            data.stretching.info{end+1} = stretchingFile;
                        end
                    end
                end
            end
        end
        
    %% if opto simulation
    elseif strcmp(data.simulationType,'opto')
        
        % initialize opto data cells
        data.opto.activation = {};
        data.opto.shapes = {};
        
        % loop until an empty line is found
        while 1
            
            % get the next line from the file
            line = fgetl(fID);
            
            % if the line is empty
            if strcmp(line,'')
            
                % if there is size type defined, break out of the loop
                if numel(data.opto.activation) > 0
                    break
                    
                % otherwise, give error and return
                else
                    disp('Error. No opto parameters given.'); data = 0; return
                end
                
            % if the line reads "% parameter study", or has other comment,
            % give error and return
            elseif strcmp(line,'% parameter study') || strcmp(line(1),'%')
                disp('Error. Wrong file format, there should be an empty line before ''% parameter study''.') ;data = 0; return
            
            % otherwise
            else
                
                % scan the line to obtain two strings
                line = textscan(line,'%s %s');
                
                % get the file extension of the first file
                [~,~,ext] = fileparts(line{1}{1});
                
                % if the the string is "load", save it
                if strcmp(line{1}{1},'load')
                    data.opto.activation{end+1} = 'load';
                
                % otherwise, check that the extension is csv, if not, give
                % error and return
                elseif ~strcmp(ext,'.csv')
                    inputNumber = numel(data.opto.activation)+1;
                    disp(['Error. Wrong file format, should be a .csv file. (simulation number' num2str(inputNumber) ').']); data = 0; return
                else
                    
                    % open the file
                    fIDTemp = fopen(line{1}{1});
                    
                    % if it opens, close the file, and save the file name
                    if fIDTemp ~= -1
                        fclose(fIDTemp);
                        data.opto.activation{end+1} = line{1}{1};
                        
                    % otherwise, give error and return
                    else
                        inputNumber = numel(data.opto.activation)+1;
                        disp(['Error. The simulation number ' num2str(inputNumber) ' activation file cannot be found or opened']); data = 0; return
                    end
                end
                
                % get the file extension of the second file
                [~,~,ext] = fileparts(line{2}{1});
                
                % if the the string is "load", save it
                if strcmp(line{2}{1},'load')
                    data.opto.shapes{end+1} = 'load';
                
                % otherwise, check that the extension is csv, if not, give
                % error and return
                elseif ~strcmp(ext,'.csv')
                    inputNumber = numel(data.opto.shapes)+1;
                    disp(['Error. Wrong file format, should be a .csv file (simulation number ' num2str(inputNumber) ').']); data = 0; return
                
                % otherwise
                else
                    
                    % open the file
                    fIDTemp = fopen(line{2}{1});
                    
                    % if it opens, close the file, and save the file name
                    if fIDTemp ~= -1
                        fclose(fIDTemp);
                        data.opto.shapes{end+1} = line{2}{1};
                        
                    % otherwise, give error and return
                    else
                        inputNumber = numel(data.opto.shapes)+1;
                        disp(['Error. The simulation number ' num2str(inputNumber) ' shapes file cannot be found or opened']); data = 0; return
                    end
                end
            end
        end

    elseif strcmp(data.simulationType,'glass')

         % initialize opto data cells
        data.glass.movement = {};
        data.glass.shapes = {};
        
        % loop until an empty line is found
        while 1
            
            % get the next line from the file
            line = fgetl(fID);
            
            % if the line is empty
            if strcmp(line,'')
            
                % if there is size type defined, break out of the loop
                if numel(data.glass.movement) > 0
                    break
                    
                % otherwise, give error and return
                else
                    disp('Error. No glass parameters given.'); data = 0; return
                end
                
            % if the line reads "% parameter study", or has other comment,
            % give error and return
            elseif strcmp(line,'% parameter study') || strcmp(line(1),'%')
                disp('Error. Wrong file format, there should be an empty line before ''% parameter study''.') ;data = 0; return
            
            % otherwise
            else
                
                % scan the line to obtain two strings
                line = textscan(line,'%s %s');
                
                % get the file extension of the first file
                [~,~,ext] = fileparts(line{1}{1});
                
                % if the the string is "load", save it
                if strcmp(line{1}{1},'load')
                    data.glass.movement{end+1} = 'load';
                
                % otherwise, check that the extension is csv, if not, give
                % error and return
                elseif ~strcmp(ext,'.csv')
                    inputNumber = numel(data.glass.movement)+1;
                    disp(['Error. Wrong file format, should be a .csv file. (simulation number' num2str(inputNumber) ').']); data = 0; return
                else
                    
                    % open the file
                    fIDTemp = fopen(line{1}{1});
                    
                    % if it opens, close the file, and save the file name
                    if fIDTemp ~= -1
                        fclose(fIDTemp);
                        data.glass.movement{end+1} = line{1}{1};
                        
                    % otherwise, give error and return
                    else
                        inputNumber = numel(data.glass.movement)+1;
                        disp(['Error. The simulation number ' num2str(inputNumber) ' movement file cannot be found or opened']); data = 0; return
                    end
                end
                
                % get the file extension of the second file
                [~,~,ext] = fileparts(line{2}{1});
                
                % if the the string is "load", save it
                if strcmp(line{2}{1},'load')
                    data.glass.shapes{end+1} = 'load';
                
                % otherwise, check that the extension is csv, if not, give
                % error and return
                elseif ~strcmp(ext,'.csv')
                    inputNumber = numel(data.glass.shapes)+1;
                    disp(['Error. Wrong file format, should be a .csv file (simulation number ' num2str(inputNumber) ').']); data = 0; return
                
                % otherwise
                else
                    
                    % open the file
                    fIDTemp = fopen(line{2}{1});
                    
                    % if it opens, close the file, and save the file name
                    if fIDTemp ~= -1
                        fclose(fIDTemp);
                        data.glass.shapes{end+1} = line{2}{1};
                        
                    % otherwise, give error and return
                    else
                        inputNumber = numel(data.glass.shapes)+1;
                        disp(['Error. The simulation number ' num2str(inputNumber) ' shapes file cannot be found or opened']); data = 0; return
                    end
                end
            end
        end

    end
    
% otherwise, give error and return
else
    disp('Error. Wrong file format, the line ''% simulation specific input'' not found after simulation time definitions.'); data = 0; return
end

% if growth simulation
if strcmp(data.simulationType,'growth')
    
    % check if the number of size types is one or the number of
    % simulations, if not, give error and return
    if ~any(length(data.sizeType) == [1 data.nSimulations])
        disp(['Error. The number of the given cell size types should either be one or the number of simulations (' num2str(data.nSimulations) ').']); data = 0; return
    end
    
% if pointlike simulation    
elseif strcmp(data.simulationType,'pointlike')
    
    % check if the number of pointlike data is one or the number of
    % simulations, if not, give error and return
    if ~any(length(data.pointlike.cell) == [1 data.nSimulations])
        disp(['Error. The number of the given pointlike specifications should either be one or the number of simulations (' num2str(data.nSimulations) ').']); data = 0; return
    end

% if stretch simulation 
elseif strcmp(data.simulationType,'stretch')
    
    % check if the number of stretch data is one or the number of
    % simulations, if not, give error and return
    if ~any(length(data.initialStateFiles) == [1 data.nSimulations])
        disp(['Error. The number of the given initial state files should either be one or the number of simulations (' num2str(data.nSimulations) ').']); data = 0; return
    end
    
% if opto simulation     
elseif strcmp(data.simulationType,'opto')
    
    % check if the number of opto data is one or the number of simulations,
    % if not, give error and return 
    if ~any(length(data.opto.activation) == [1 data.nSimulations])
        disp(['Error. The number of the given optogenetica activation specifications should either be one or the number of simulations (' num2str(data.nSimulations) ').']); data = 0; return
    end
end

end