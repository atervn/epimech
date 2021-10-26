function data = read_number_of_simulations(fID,data)
% READ_NUMBER_OF_SIMULATIONS Read the number of simulations to be run
%   The function reads the number of simulation to be run. The number of
%   simulations is defined with a positive integer.
%   INPUT:
%       fID: ID for the file
%       data: structure to collect config file data
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

% check if the next line in the file is "% number of simulations"
if strcmp(fgetl(fID),'% number of simulations')
    
    % get the line following the % number of simulations
    line = fgetl(fID);
    
    % if the line is empty, use the default number of 1 simulation
    if strcmp(line,'')
        data.nSimulations = 1;
        
    % if no number of cores is given and there is no empty line before the
    % next comment line, if yes, give error and return
    elseif strcmp(line,'% system parameters') || strcmp(line(1),'%')
        disp('Error. If no simulation number is given, there should be an empty line between ''% number of simulations'' and ''% system parameters''.')
        data = 0;
        return
        
    % otherwise
    else
        
        % scan the line
        line = textscan(line,'','Delimiter',' ;,');
        
        % check if there are more than one value on the line, if yes, give
        % error and return
        if length(line) > 1
            disp('Error. The line after ''% number of simulations'' should either be empty of have a single positive integer.')
            data = 0;
            return
            
        % otherwise
        else
            
            % check if the value given is an integer and if the integer has
            % a positive value
            if floor(line{1}) == line{1} && line{1} > 0
                
                % set the number of simulations
                data.nSimulations = line{1};
                
            % otherwise, give error and return
            else
                disp('Error. The number of simulations should be a positive integer.')
                data = 0;
                return
            end
        end
    end
    
    % check if there is an empty line before "% ystem parameters", if
    % no, give error and return
    if ~strcmp(fgetl(fID),'')
        disp('Error. There should be an empty line between the given number of simulations and ''% system parameters''.')
        data = 0;
        return
    end
    
% if no "% number of simulation" line is found, give error
else
    disp('Error. Wrong file format, the line ''% number of simulations'' not found after core number definition.')
    data = 0;
    return
end

end