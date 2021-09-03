function data = read_simulation_times(fID,data)

if strcmp(fgetl(fID),'% simulation time')
    
    line = fgetl(fID);
    line = textscan(line,'%f %s %f %s %f %s');
    if ~(length(line{1}) == 1 && length(line{2}) == 1 && length(line{3}) == 1 && length(line{4}) == 1)
        disp('Error. Simulation time and time step not correctly defined.')
        data = 0;
        return
    end
    if ~any(length(line) == [4 6])
        disp('Error. Wrong number of times defined.')
        data = 0;
        return
    end
    % simulation time
    if strcmp(line{2}{1},'d')
        data.simulationTime = line{1}*60*60*24;
    elseif strcmp(line{2}{1},'h')
        data.simulationTime = line{1}*60*60;
    elseif strcmp(line{2}{1},'m')
        data.simulationTime = line{1}*60;
    elseif strcmp(line{2}{1},'s')
        data.simulationTime = line{1};
    else
        disp('Error. Simulation time unit not recognized, it should be either d, h, m, or s.')
        data = 0;
        return
    end
    
    % time step
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
    else
        disp('Error. Time step unit not recognized, it should be either d, h, m, s, or ms.')
        data = 0;
        return
    end
    
    % stop division
    if length(line{6}) == 1
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
        else
            disp('Error. Time step unit not recognized, it should be either d, h, m, s, or ms.')
            data = 0;
            return
        end
    end
    if ~strcmp(fgetl(fID),'')
        disp('Error. There should be an empty line before ''% simulation specific input''.')
        data = 0;
        return
    end
else
    disp('Error. Wrong file format, the third line should be ''% simulation time''.')
    data = 0;
    return
end