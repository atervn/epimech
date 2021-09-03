function data = read_simulation_types(fID,data)

if strcmp(fgetl(fID),'% simulation type')
    line = fgetl(fID);
    if strcmp(line,'growth')
        data.simulationType = 'growth';
    elseif strcmp(line,'pointlike')
        data.simulationType = 'pointlike';
    elseif strcmp(line,'stretch')
        data.simulationType = 'stretch';
    elseif strcmp(line,'opto')
        data.simulationType = 'opto';
    else
        disp('Error. Simulation type unknown. It has to be either growth, pointlike, opto, or stretching.')
        data = 0;
        return
    end
    if ~strcmp(fgetl(fID),'')
        disp('Error. There should be an empty line before ''% number of cores''.')
        data = 0;
        return
    end
else
    disp('Error. Wrong file format, the first line should be ''% simulation type''.')
    data = 0;
    return
end