function data = read_export_settings(fID,data)
% READ_EXPORT_SETTINGS Read export settings for the simulations
%   The function reads the export settings for the simulations. The line
%   must have the export time step (multiplier that multiplies the default
%   time step to obtain the step how often exported is done. Following the
%   multiplier, the file containing the export settings have to be given.
%   The number of settings need to be either 1 (the same for all) or the
%   number of simulations.
%   INPUT:
%       fID: ID for the file
%       data: structure to collect config file data
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

% check if the next line in the file is "% export settings"
if strcmp(fgetl(fID),'% export settings')
    
    % loop until an empty line is found
    while 1
        
        % get the next line from the file
        line = fgetl(fID);
            
        % if the line is empty
        if strcmp(line,'')
            
            % if there is size type defined, break out of the loop
            if numel(data.exportSettings) > 0
                break
                
            % otherwise, give error and return  
            else
                disp('Error. No export settings file(s) given.'); data = 0; return
            end
            
        % if the line reads "% simulation name", or has other comment,
        % give error and return    
        elseif strcmp(line,'% simulation name') || strcmp(line(1),'%')
            disp('Error. Wrong file format, there should be an empty line before ''% simulation name''.'); data = 0; return
            
        % otherwise
        else
            
            % scan the line to obtain a number and a string
            line = textscan(line,'%f %s');
            
            % check that the export time step is a number, if not giver
            % error and return
            if ~isnumeric(line{1})
                inputNumber = numel(data.exportDt)+1;
                disp(['Error. The export time step for simulation number ' num2str(inputNumber) '  is not a number.']); data = 0; return
            end
            
            % save the export time step
            data.exportDt{end+1} = line{1};
            
            % open the export settings file
            fIDTemp = fopen(line{2}{1});
            
            % check if the file name is "load", if yes, save it
            if strcmp(line{2}{1},'load')
                data.exportSettings{end+1} = 'load';
                
            % if the file can be opened
            elseif fIDTemp ~= -1
                
                % close the file
                fclose(fIDTemp);
                
                % get the file extension
                [~,~,ext] = fileparts(line{2}{1});
                
                % if the extension is not txt, give error and return
                if ~strcmp(ext,'.txt')
                    inputNumber = numel(data.exportSettings)+1;
                    disp(['Error. Wrong file format for export settings file number ' num2str(inputNumber) ', should be a .txt file.']); data = 0; return
                
                % otherwise, save the settins
                else
                    data.exportSettings{end+1} = line{2}{1};
                end
                
            % otherwise, give error and return
            else
                inputNumber = numel(data.exportSettings)+1;
                disp(['Error. The export settings file number ' num2str(inputNumber) ' cannot be found or opened']); data = 0; return
            end
        end
    end
    
% otherwise, give error and return
else
    disp('Error. Wrong file format, the line ''% export settings'' is not found after parameter study settings.'); data = 0; return
end

% check if the number of export settings is one or the number of
% simulations, if not, give error and return
if ~any(length(data.exportSettings) == [1 data.nSimulations])
    disp(['Error. The number of of given export settings files should either be one or the number of simulations (' num2str(data.nSimulations) ').']); data = 0; return
end

end