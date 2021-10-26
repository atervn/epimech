function data = read_number_of_cores(fID,data)
% READ_NUMBER_OF_CORES Read the number of cores to be used
%   The function reads the number of CPU cores to be used in the
%   simulation. The number of cores is defined with a positive integer.
%   INPUT:
%       fID: ID for the file
%       data: structure to collect config file data
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

% check if the next line in the file is "% number of cores"
if strcmp(fgetl(fID),'% number of cores')
    
    % get the line following the % number of cores
    line = fgetl(fID);
    
    % if the line is empty, use the default number of 1 core
    if strcmp(line,'')
        data.nCores = 1;
        
    % if no number of cores is given and there is no empty line before the
    % next comment line, if yes, give error and return
    elseif strcmp(line,'% number of simulations') || strcmp(line(1),'%')
        disp('Error. If no core number is given, there should be an empty line between ''% number of cores'' and ''% number of simulations''.')
        data = 0;
        return
        
    % otherwise
    else
        
        % scan the line
        line = textscan(line,'','Delimiter',' ;,');
        
        % check if there are more than one value on the line, if yes, give
        % error and return
        if length(line) > 1
            disp('Error. The line after ''% number of cores'' should either be empty of have a single positive integer.')
            data = 0;
            return
            
        % otherwise
        else
            
            % check if the value given is an integer and if the integer has
            % a positive value
            if floor(line{1}) == line{1} && line{1} > 0
                
                % set the number of cores
                data.nCores = line{1};
                
            % otherwise, give error and return
            else
                disp('Error. The number of cores should be a positive integer.')
                data = 0;
                return
            end
        end
    end
    
    % check if there is an empty line before "% number of simulations", if
    % no, give error and return
    if ~strcmp(fgetl(fID),'')
        disp('Error. There should be an empty line between the given number of cores and ''% number of simulations''.')
        data = 0;
        return
    end
    
% if no "% number of cores" line is found, give error
else
    disp('Error. Wrong file format, the line following the empty line after the simulation type should be ''% number of cores''.')
    data = 0;
    return
end

end