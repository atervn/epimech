function data = read_substrate_parameters(fID, data)
% READ_SUBSTRATE_PARAMETERS Read the substare settings
%   The function reads the substrate settings from the config file. The
%   line format depends on the substrate stiffness type:
%   Uniform stiffness:
%       "uniform [stiffness in Pa] [substrate parameter file] [FA parameter
%       file]"
%   Gradient stiffness:
%       "gradient [gradient information file] [substrate parameter file]
%       [FA parameter file]"
%   Heterogeneous stiffness:
%       "heterogeneous [stiffness in Pa] [heterogeneous information file]
%       [substrate parameter file] [FA parameter file]"
%   The number of the path lines must be either one or the number of
%   simulations. Also, the path can read "load" for selecting the file
%   later via getfile dialog.
%   INPUT:
%       fID: ID for the file
%       data: structure to collect config file data
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

% check if the next line in the file is "% cell parameters"
if strcmp(fgetl(fID),'% substrate parameters')
    
    % if the simulation type is other than growth
    if ~strcmp(data.simulationType,'growth')
        
        % initialize cells to collect the substrate data
        data.fFAInfo = {};
        data.stiffnessType = {};
        data.stiffness = {};
        data.stiffnessInfo = {};
        
        % loop until an empty line is found
        while 1
        
            % get the next line from the file
            line = fgetl(fID);
            
            % variable to keep track the component in each line
            lineIdx = 1;
            
            % if the line is empty
            if strcmp(line,'')
            
                % if there are substrate setting defined, break out of the
                % loop
                if numel(data.stiffnessType) > 0
                    break
                    
                % otherwise, give error and return    
                else
                    disp('Error. No substrate settings given.')
                    data = 0;
                    return
                end
                
            % if the line reads "% initial state", or has other comment,
            % give error and return
            elseif strcmp(line,'% initial state') || strcmp(line(1),'%')
                disp('Error. Wrong file format, there should be an empty line before ''% initial state''.'); data = 0; return
            
            % otherwise
            else
                
                % scan the line to obtain number of strings
                line = textscan(line,'%s');
                
                % if the first string is "uniform"
                if strcmp(line{1}{lineIdx},'uniform')
                    
                    % set the stiffness type
                    data.stiffnessType{end+1} = 'uniform';
                    
                    % increase the line index
                    lineIdx = lineIdx + 1;
                    
                    % get the stiffnee value and convert it to double
                    stiffness = str2double(line{1}{lineIdx});
                    
                    % no further stiffness info is required, so input zero
                    data.stiffnessInfo{end+1} = 0;
                    
                    % check if the stiffness is not a number
                    if isnan(stiffness)
                        
                        % if yes, give error and return
                        disp('Error. Stiffness is not a number'); data = 0; return
                        
                    % check if the stiffness is negative
                    elseif stiffness < 0
                        
                        % if yes, give error and return
                        disp('Error. Stiffness must be positive'); data = 0; return
                        
                    % otherwise
                    else
                        
                        % save the stiffness
                        data.stiffness{end+1} = stiffness;
                        
                        % increase the line index
                        lineIdx = lineIdx + 1;
                    end
                
                % if the first string is "gradient"
                elseif strcmp(line{1}{lineIdx},'gradient')
                    
                    % set the stiffness type
                    data.stiffnessType{end+1} = 'gradient';
                    
                    % set the stiffness to zero since it is defined in the
                    % gradient file
                    data.stiffness{end+1} = 0;
                    
                    % increase the line index
                    lineIdx = lineIdx + 1;
                    
                    % get the next string on the line, which should be
                    % gradient file
                    stiffnessGradientFile = line{1}{lineIdx};
                    
                    % if the the string is "load", save it to the
                    % stiffnessInfo cell and increase the line
                    % index
                    if strcmp(stiffnessGradientFile,'load')
                        data.stiffnessInfo{end+1} = 'load';
                        lineIdx = lineIdx + 1;
                        
                    % otherwise
                    else
                        
                        % get the extension for the file
                        [~,~,ext] = fileparts(stiffnessGradientFile);
                        
                         % check if this is a csv file
                        if ~strcmp(ext,'.csv')
                            
                            % if not, give error and return
                            disp('Error. Gradient file must be .csv file'); data = 0; return
                            
                        % otherwise
                        else
                            
                            % try to read the file, if not possible, give
                            % error and return
                            try
                                gradientInfoTemp = csvread(stiffnessGradientFile);
                            catch
                                disp('Error. Cannot open gradient file'); data = 0; return
                            end
                            
                            % check if the csv file contains three columns,
                            % if no, give error and return
                            if size(gradientInfoTemp,2) ~= 3
                                disp('Error. Gradient file must have three columns (one for positions, one for stiffnesses, and one for rotation angle).'); data = 0; return
                            
                            % check if all stiffness values in the file are
                            % positive, if no, give error and return
                            elseif any(gradientInfoTemp(:,2) <= 0)
                                disp('Error. All values in the second column of the gradient file must be larger than zero.'); data = 0; return
                            
                            % check if the values in the position column in
                            % the file are increasing, if no, give error
                            % and return
                            elseif any(diff(gradientInfoTemp(:,1)) <= 0)
                                disp('Error. The position values in the first column of the gradient file must be increasing'); data = 0; return
                            
                            % check if the values in the angle colum (the
                            % last one) are zero other than the first
                            % element, if no, give error and return
                            elseif size(gradientInfoTemp,1) > 1 && ~any(gradientInfoTemp(2:end,3) == 0)
                                disp('Error. The values in the third column of the gradient file should be zeroes excluding the first value (which can be zero).'); data = 0; return
                            end
                            
                            % save the stiffness gradient file to the
                            % stiffnessInfo cell
                            data.stiffnessInfo{end+1} = stiffnessGradientFile;
                            
                            % increase the line index
                            lineIdx = lineIdx + 1;
                        end
                    end
                
                % if the first string is "heterogeneous"
                elseif strcmp(line{1}{lineIdx},'heterogeneous')
                    
                    % set the stiffness type
                    data.stiffnessType{end+1} = 'heterogeneous';
                    
                    % increase the line index
                    lineIdx = lineIdx + 1;
                    
                    % get the stiffnee value and convert it to double
                    stiffness = str2double(line{1}{lineIdx});
                    
                    % check if the stiffness is not a number
                    if isnan(stiffness)
                        
                        % if yes, give error and return
                        disp('Error. Stiffness is not a number'); data = 0; return
                        
                    % check if the stiffness is negative
                    elseif stiffness < 0
                        
                        % if yes, give error and return
                        disp('Error. Stiffness must be positive'); data = 0; return
                        
                    % otherwise
                    else
                        
                        % save the stiffness
                        data.stiffness{end+1} = stiffness;
                        
                        % increase the line index
                        lineIdx = lineIdx + 1;
                    end
                    
                    % get the next string on the line, which should be
                    % heterogeneity file
                    stiffnessHeterogeneityFile = line{1}{lineIdx};
                    
                    % if the the string is "load", save it to the
                    % stiffnessInfo cell and increase the line
                    % index
                    if strcmp(stiffnessHeterogeneityFile,'load')
                        data.stiffnessInfo{end+1} = 'load';
                        lineIdx = lineIdx + 1;
                        
                    % otherwise
                    else
                        
                        % get the extension for the file
                        [~,~,ext] = fileparts(stiffnessHeterogeneityFile);
                        
                         % check if this is a csv file
                        if ~strcmp(ext,'.csv')
                            
                            % if not, give error and return
                            disp('Error. Stiffness heterogeneity file must be .csv file'); data = 0; return
                            
                        % otherwise
                        else
                            
                            % try to read the file, if not possible, give
                            % error and return
                            try
                                heterogeneityInfoTemp = csvread(stiffnessHeterogeneityFile);
                            catch
                                disp('Error. Cannot open heterogeneity file'); data = 0; return
                            end
                            
                            % if the first or second elements in the file
                            % are nonpositive or if the third element is
                            % smaller than zero
                            if heterogeneityInfoTemp(1) <= 0 || heterogeneityInfoTemp(2) <= 0 || heterogeneityInfoTemp(3) < 0
                                disp('Error. Stiffness heterogeneity file must have two autocorrelation length values (larger than zero), amplitude of the hetergeneity (nonnegative), and the rotation in rads'); data = 0; return
                            
                            % otherwise
                            else
                            
                                % save the stiffness gradient file to the
                                % stiffnessInfo cell
                                data.stiffnessInfo{end+1} = stiffnessHeterogeneityFile;
                                
                                % increase the line index
                                lineIdx = lineIdx + 1;
                            end
                        end
                    end
                    
                % no stiffness type on the line
                else
                    
                    % if the simulation type is not stretch, give error and
                    % return
                    if ~strcmp(data.simulationType,'stretch')
                        disp('Error. No proper stiffness type given, must be either uniform, heterogeneous, or gradient'); data = 0; return
                    
                    % if stretch
                    else
                        
                        % set default values, since the stiffness is not
                        % defined for the stretch simulation
                        data.stiffnessType{end+1} = 'uniform';
                        data.stiffness{end+1} = 0;
                        data.stiffnessInfo{end+1} = 0;
                    end
                end

                % get the extension for the substrate parameters file
                [~,~,ext] = fileparts(line{1}{lineIdx});
                
                % if the next string on the line is "load", save it to the
                % substrateParameterFiles cell and increase the line
                % index
                if strcmp(line{1}{lineIdx},'load')
                    data.substrateParameterFiles{end+1} = 'load';
                    lineIdx = lineIdx + 1;
                    
                % if the file type is not txt   
                elseif ~strcmp(ext,'.txt')
                    
                    % give error and return
                    disp('Error. Wrong file format, the substrate parameters should be a .txt file.'); data = 0; return
                    
                % otherwise
                else
                    
                    % try to open the file
                    fIDTemp = fopen(line{1}{lineIdx});
                    
                    % if the file can be opened
                    if fIDTemp ~= -1
                
                        % close the file
                        fclose(fIDTemp);
                    
                        % save the file name to substrateParameterFiles
                        % cell and increase the line index
                        data.substrateParameterFiles{end+1} = line{1}{lineIdx};
                        lineIdx = lineIdx + 1;
                        
                    % otherwise
                    else
                        
                        % give an error indicating which file cannot be
                        % opened or found and return
                        inputNumber = numel(data.substrateParameterFiles)+1;
                        disp(['Error. The substrate parameters file number ' num2str(inputNumber) ' cannot be found or opened']); data = 0; return
                    end
                end
                
                % get the extension for the focal adhesion file
                [~,~,ext] = fileparts(line{1}{lineIdx});
                
                % if the next string on the line is "load", save it to the
                % fFAInfo cell
                if strcmp(line{1}{lineIdx},'load')
                    data.fFAInfo{end+1} = 'load';
                    
                % if the file type is not csv
                elseif ~strcmp(ext,'.csv')
                    disp('Error. Wrong file format, focal adhesion parameter file should be a .csv file.'); data = 0; return
                
                % otherwise
                else
                    
                    % try to open the file
                    fIDTemp = fopen(line{1}{lineIdx});
                    
                    % if the file can be opened
                    if fIDTemp ~= -1
                
                        % close the file
                        fclose(fIDTemp);
                    
                        % save the file name to fFAInfo cell
                        data.fFAInfo{end+1} = line{1}{lineIdx};
                        
                    % otherwise
                    else
                        
                        % give an error indicating which file cannot be
                        % opened or found and return
                        inputNumber = numel(data.fFAInfo)+1;
                        disp(['Error. The focal adhesion parameters file number ' num2str(inputNumber) ' cannot be found or opened']); data = 0; return
                    end
                end
            end
        end
        
    % if growth simulation, read the next empty line
    else
       fgetl(fID); 
    end
        
% if no "% substrate parameters" line is found, give error
else
    disp('Error. Wrong file format, the line ''% substrate parameters'' not found after cell parameter files definition.'); data = 0; return
end

% check if the number of the substrate parameter files given is either one
% or the number of simulations
if ~strcmp(data.simulationType,'growth') && ~any(length(data.substrateParameterFiles) == [1 data.nSimulations])
    disp(['Error. The number of of given substrate parameter files should either be one or the number of simulations (' num2str(data.nSimulations) ').']); data = 0; return
end

end