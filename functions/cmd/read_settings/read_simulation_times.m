function data = read_simulation_times(fID,data)
% READ_SIMULATION_TIMES Read the simulation time and time step
%   The function reads the line specifying the simulation time and time
%   step, as well as a time point to end dividing for growth simulation.
%   The times are specified by a magnitude followed by a time unit (d, h,
%   m, s, or ms). The line should be of the form "[sim time] [sim time
%   unit] [time step] [time step unit] ([end div time] [end div time
%   unit]).
%   INPUT:
%       fID: ID for the file
%       data: structure to collect config file data
%   OUTPUT:
%       data: structure to collect config file data
%   by Aapo Tervonen, 2021

% check if the next line in the file is "% simulation time"
if strcmp(fgetl(fID),'% simulation time')
    
    % get the next line from the file
    line = fgetl(fID);
    
    % scan the line to get the magnitudes and unit strings
    line = textscan(line,'%f %s %f %s %f %s');
    
    % make sure that the simulation times and time steps are given
    if ~(length(line{1}) == 1 && length(line{2}) == 1 && length(line{3}) == 1 && length(line{4}) == 1)
        
        % if not, give error and return
        disp('Error. Simulation time and time step not correctly defined.'); data = 0; return
    end
    
    % check that there is correct number of items in the line
    if ~any(length(line) == [4 6])
        
        % if not, give error and return
        disp('Error. Wrong number of times defined.'); data = 0; return
    end
    
    % calculate the corresponding simulation time in seconds based on the
    % defined time unit and save it to simulationTime
    if strcmp(line{2}{1},'d')
        data.simulationTime = line{1}*60*60*24;
    elseif strcmp(line{2}{1},'h')
        data.simulationTime = line{1}*60*60;
    elseif strcmp(line{2}{1},'m')
        data.simulationTime = line{1}*60;
    elseif strcmp(line{2}{1},'s')
        data.simulationTime = line{1};
        
    % if no correct simulation time unit given, give error and return
    else
        disp('Error. Simulation time unit not recognized, it should be either d, h, m, or s.'); data = 0; return
    end
    
    % calculate the corresponding maximum time step in seconds based on the
    % defined time unit and save it to simulationTime
    if strcmp(line{4}{1},'d')
        data.maximumTimeStep = line{3}*60*60*24;
    elseif strcmp(line{4}{1},'h')
        data.maximumTimeStep = line{3}*60*60;
    elseif strcmp(line{4}{1},'m')
        data.maximumTimeStep = line{3}*60;
    elseif strcmp(line{4}{1},'s')
        data.maximumTimeStep = line{3};
    elseif strcmp(line{4}{1},'ms')
        data.maximumTimeStep = line{3}/1000;
        
    % if no correct simulation time unit given, give error and return
    else
        disp('Error. Time step unit not recognized, it should be either d, h, m, s, or ms.'); data = 0; return
    end
    
    % check if there is stop division time given
    if length(line{6}) == 1
        
        % calculate the corresponding stop division time in seconds based
        % on the defined time unit and save it to simulationTime
        if strcmp(line{6}{1},'d')
            data.stopDivisionTime = line{5}*60*60*24;
        elseif strcmp(line{6}{1},'h')
            data.stopDivisionTime = line{5}*60*60;
        elseif strcmp(line{6}{1},'m')
            data.stopDivisionTime = line{5}*60;
        elseif strcmp(line{6}{1},'s')
            data.stopDivisionTime = line{5};
        elseif strcmp(line{6}{1},'ms')
            data.stopDivisionTime = line{5}/1000;
            
        % if no correct simulation time unit given, give error and return
        else
            disp('Error. Time step unit not recognized, it should be either d, h, m, s, or ms.'); data = 0; return
        end
    end
    
    % if there is no empty line before "% simulation specific input", give
    % error and return
    if ~strcmp(fgetl(fID),'')
        disp('Error. There should be an empty line before ''% simulation specific input''.'); data = 0; return
    end
    
% if no "% simulation time" line is found, give error
else
    disp('Error. Wrong file format, the line ''% simulation time'' not found after initial state definition.'); data = 0; return
end

end